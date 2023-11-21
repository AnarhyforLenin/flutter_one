import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_one/domain_layer/product.dart';
import 'package:image_picker/image_picker.dart';

class CustomImageWidget extends StatefulWidget {
  final Product product;

  CustomImageWidget({required this.product});

  @override
  _CustomImageWidgetState createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {
  File? _image;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  Widget _buildImage() {
    if (widget.product.imageUrl!.startsWith('assets/')) {
      return Image.asset(
        widget.product.imageUrl!,
        fit: BoxFit.contain,
      );
    } else {
      return _buildImageFromFile(widget.product.imageUrl);
    }
  }

  Widget _buildImageFromFile(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.fill,
      );
    } else {
      return Container();
    }
  }

  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }
}