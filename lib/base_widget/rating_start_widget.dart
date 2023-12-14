import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingStartWidget extends StatelessWidget {
  final Function(double) onRatingUpdate;
  final bool allowHalfRating;
  final bool isReadable;
  final double initialRating;
  final double? itemSize;

  const RatingStartWidget({
    super.key,
    required this.onRatingUpdate,
    this.allowHalfRating = true,
    this.isReadable = false,
    this.initialRating = 0,
    this.itemSize,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      ignoreGestures: isReadable,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating,
      itemCount: 5,
      itemSize: itemSize ?? 40,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0).w,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}
