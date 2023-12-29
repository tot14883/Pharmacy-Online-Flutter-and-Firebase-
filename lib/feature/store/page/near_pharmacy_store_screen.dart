import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';

class NearPharmacyStoreScreen extends ConsumerStatefulWidget {
  static const routeName = 'NearPharmacyStoreScreen';

  const NearPharmacyStoreScreen({super.key});

  @override
  _NearPharmacyStoreScreenState createState() =>
      _NearPharmacyStoreScreenState();
}

class _NearPharmacyStoreScreenState
    extends ConsumerState<NearPharmacyStoreScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  Marker? nearestMarker;
  double? nearestDistance;
  double myLatitude = 0.0;
  double myLongtitude = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final GoogleMapController controller = await mapController.future;

      final _myLatitude = ref.watch(
        storeControllerProvider.select((value) => value.myLatitude),
      );
      final _myLongtitude = ref.watch(
        storeControllerProvider.select((value) => value.myLongtitude),
      );

      myLatitude = _myLatitude ?? 0.0;
      myLongtitude = _myLongtitude ?? 0.0;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(myLatitude, myLongtitude),
            zoom: 15,
          ),
        ),
      );
    });
    super.initState();
  }

  // ฟังก์ชันสำหรับคำนวณ Marker ที่ใกล้ที่สุด
  void findNearestMarker({
    bool opennow = false,
    required List<PharmacyInfoResponse> pharmacyInfoList,
    required Set<Marker> markList,
  }) async {
    final GoogleMapController controller = await mapController.future;
    double minDistance = double.infinity;
    Marker? nearest;

    for (Marker marker in markList) {
      double distance = Geolocator.distanceBetween(
        myLatitude,
        myLongtitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = marker;
      }
    }
    if (opennow) {
      nearestMarker = nearest;
      nearestDistance = minDistance;

      final nearPharmacyStore = pharmacyInfoList
          .where((val) => MarkerId('${val.uid}') == nearestMarker?.markerId)
          .toList();

      if (nearPharmacyStore.isNotEmpty) {
        navigateToPharmacyStore(nearPharmacyStore.first);
      }
    } else {
      setState(() {
        nearestMarker = nearest;
        nearestDistance = minDistance;
      });
    }

    if (nearest != null) {
      controller.animateCamera(CameraUpdate.newLatLng(nearest.position));
    }
  }

  void navigateToPharmacyStore(PharmacyInfoResponse pharmacyInfoItem) {
    Navigator.of(context).pushNamed(
      StoreDetailScreen.routeName,
      arguments: StoreDetailArgs(pharmacyInfoResponse: pharmacyInfoItem),
    );
  }

  Set<Marker> createMarker(
    List<PharmacyInfoResponse> pharmacyList,
  ) {
    Set<Marker> markerList = {};

    for (final pharmacyItem in pharmacyList) {
      Marker newMarker = Marker(
        markerId: MarkerId('${pharmacyItem.uid}'),
        infoWindow: InfoWindow(
          title: '${pharmacyItem.nameStore}',
          snippet: 'Click to See Pharmacy Store',
          onTap: () {
            navigateToPharmacyStore(pharmacyItem);
          },
        ),
        position: LatLng(
          pharmacyItem.latitude ?? 0.0,
          pharmacyItem.longtitude ?? 0.0,
        ),
      );

      markerList.add(newMarker);
    }

    return markerList;
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyInfoList = ref.watch(
      storeControllerProvider.select(
        (value) => value.pharmacyInfoList,
      ),
    );

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'ค้นหาร้านขายยาใกล้คุณ',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrainted) {
        return AsyncValueWidget(
          value: pharmacyInfoList,
          data: (_pharmacyInfoList) {
            return GoogleMap(
              markers: createMarker(_pharmacyInfoList ?? []),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(myLatitude, myLongtitude),
                zoom: 15,
              ),
            );
          },
        );
      },
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              findNearestMarker(
                pharmacyInfoList: pharmacyInfoList.value ?? [],
                markList: createMarker(pharmacyInfoList.value ?? []),
              );
            },
            label: Text(
              "ค้นหาร้านที่ใกล้ที่สุด",
              style: AppStyle.txtBody2,
            ),
            icon: const Icon(Icons.place),
          ),
          if (nearestMarker != null && nearestDistance != null) ...[
            Text("Marker ที่ใกล้ที่สุด: ${nearestMarker!.infoWindow.title}"),
          ],
          if (nearestMarker != null && nearestDistance != null) ...[
            Text("ระยะทาง: ${nearestDistance!.toStringAsFixed(2)} เมตร"),
          ],
        ],
      ),
    );
  }
}
