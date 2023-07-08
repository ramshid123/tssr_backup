import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class SSLCPage extends StatelessWidget {
  String imageUrl;
  SSLCPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}
