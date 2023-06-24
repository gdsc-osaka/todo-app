import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({super.key, required this.imagePath, required this.imageUrl});

  static const name = '/image-view';
  static const path = '/image-view';
  static const pathParam = 'path';
  static const urlParam = 'url';

  final String? imagePath;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    File? imageFile;
    if (imagePath != null) {
      imageFile = File(imagePath!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black38,
      body: Center(
        child: Hero(
            tag: imageFile != null ? imageFile.path : imageUrl!,
            child: imageFile != null ? Image.file(imageFile) : Image.network(imageUrl!)),
      ),
    );
  }
}
