import 'package:image_picker/image_picker.dart';

class ChatWithPharmacyRequest {
  final String? id;
  final String? message;
  final String? pharmacyId;
  final XFile? chatImg;
  final bool? isApprove;

  ChatWithPharmacyRequest({
    this.id,
    this.message,
    this.pharmacyId,
    this.chatImg,
    this.isApprove,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'pharmacyId': pharmacyId,
      'chatImg': chatImg,
      'isApprove': isApprove,
    };
  }
}
