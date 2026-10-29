import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFields extends StatefulWidget {
  const ImageFields({
    super.key,
    required this.onImageChanged,
    this.initialImageUrl,
  });
  final Function(File?) onImageChanged;
  final String? initialImageUrl;

  @override
  State<ImageFields> createState() => _ImageFieldsState();
}

class _ImageFieldsState extends State<ImageFields> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickImage(ImageSource sourceImg) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: sourceImg,
      imageQuality: 90,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        widget.onImageChanged(_selectedImage);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final hasNewImage = _selectedImage != null;
    final hasOldImage = _imageUrl != null && _imageUrl!.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            border: BoxBorder.all(),
            borderRadius: BorderRadius.circular(6),
          ),
          child: hasNewImage
              ? ClipRRect(
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  ),
                )
              : hasOldImage
              ? ClipRRect(
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  ),
                )
              : const Center(child: Icon(Icons.image, size: 50)),
        ),
        if (hasNewImage || hasOldImage)
          TextButton.icon(
            onPressed: _removeImage,
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        Row(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              icon: Icon(Icons.image_outlined, size: 35),
            ),
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              icon: Icon(Icons.add_a_photo_outlined, size: 35),
            ),
          ],
        ),
      ],
    );
  }
}
