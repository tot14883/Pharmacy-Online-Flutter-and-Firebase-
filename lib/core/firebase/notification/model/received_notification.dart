
/// When you create a notification the instance of this class is required
/// [id] unique id for this notification
/// [payload] is used when user click on the notification
class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final String? imageUrl;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.imageUrl,
  });


  
}
