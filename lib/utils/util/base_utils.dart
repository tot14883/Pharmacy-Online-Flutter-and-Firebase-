import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:multiple_result/multiple_result.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:pharmacy_online/core/error/failure.dart';

final baseUtilsProvider = Provider<BaseUtils>(
  (ref) => BaseUtils(),
);

class BaseUtils {
  // void launchURL(String? url) async {
  //   if (url != null) {
  //     final _url = Uri.parse(url);
  //     //  check that url can open in browser.
  //     if (await canLaunchUrl(_url)) {
  //       await launchUrl(_url);
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   }
  // }

  bool allowFileExtension(
    String file,
    List<String> allowFiles,
  ) {
    final _file = p.extension(file);
    return allowFiles.contains(_file);
  }

  String? enumToStringSnakeCase(enumValue) {
    if (enumValue == null) return null;

    String enumString = enumValue.toString().split('.')[1];
    return enumString
        .replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) => '_${match.group(0)}',
        )
        .toLowerCase();
  }

  Future<bool> checkUrl(String? url) async {
    try {
      if (url == null) return false;

      final response = await http.head(Uri.parse(url));
      return (response.statusCode >= 200 && response.statusCode < 300);
    } catch (e) {
      return false;
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<Result<Position, Failure>> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Error(Failure(message: 'No Permission'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Error(Failure(message: 'No Permission'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Error(Failure(message: 'No Permission'));
    }

    return Success(await Geolocator.getCurrentPosition());
  }

  DateTime parseTime(dynamic date) {
    return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
  }
}
