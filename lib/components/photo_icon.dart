import 'package:flutter/cupertino.dart';

class PhotoIcon extends StatelessWidget {
  const PhotoIcon({super.key, required this.photoUrl, this.height, this.width});

  final String photoUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.network(
        photoUrl,
        height: height ?? 30,
        width: width ?? 30,
      ),
    );
  }
}
