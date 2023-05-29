import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({super.key, required this.imagePath});

  static const name = '/image-view';
  static const path = '/image-view/:path';
  static const pathParam = 'path';

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black38,
      body: Center(
        child: Hero(
            tag: imageFile.path,
            child: Image.file(imageFile)),
      ),
    );
  }
}