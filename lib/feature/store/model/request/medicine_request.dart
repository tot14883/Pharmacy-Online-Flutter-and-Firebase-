import 'package:image_picker/image_picker.dart';

class MedicineRequest {
  final String? id;
  final String? name;
  final double? price;
  final XFile? medicineImg;
  final String? currentMedicineImg;
  final String? medicineType;
  final String? band;

  MedicineRequest({
    this.id,
    this.name,
    this.price,
    this.medicineImg,
    this.currentMedicineImg,
    this.medicineType,
    this.band,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'medicineImg': medicineImg,
      'currentMedicineImg': currentMedicineImg,
      'medicineType': medicineType,
      'band': band,
    };
  }
}
