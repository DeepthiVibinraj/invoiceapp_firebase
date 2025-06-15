import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptalents/app_export.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading:
                        const Icon(Icons.photo_library, color: Colors.indigo),
                    title: const Text(
                      'Gallery',
                      style:
                          TextStyle(color: Color.fromARGB(250, 253, 180, 27)),
                    ),
                    onTap: () {
                      _pickGalleryImage();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.indigo),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(250, 253, 180, 27)),
                  ),
                  onTap: () async {
                    final pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                        maxWidth: 150);
                    if (pickedImage == null) {
                      return null;
                    }
                    setState(() {
                      _pickedImageFile = File(pickedImage.path);
                    });
                    widget.onPickedImage(_pickedImageFile!);
                    //_pickCameraImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  // Future<void> _pickCameraImage() async {
  //   final pickedImage = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
  //   if (pickedImage == null) {
  //     return null;
  //   }
  //   setState(() {
  //     _pickedImageFile = File(pickedImage.path);
  //   });
  //   widget.onPickedImage(_pickedImageFile!);
  // }

  Future<void> _pickGalleryImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    if (pickedImage == null) {
      return null;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickedImage(_pickedImageFile!);
  }
  // void _pickImage() async {
  //   final pickedImage = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
  //   if (pickedImage == null) {
  //     return null;
  //   }
  //   setState(() {
  //     _pickedImageFile = File(pickedImage.path);
  //   });
  //   widget.onPickedImage(_pickedImageFile!);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor:
              _pickedImageFile != null ? Colors.grey : Colors.white,
          foregroundImage: _pickedImageFile != null
              ? FileImage(_pickedImageFile!)
              : AssetImage(
                  ImageConstant.user_not_found,
                ),
        ),
        TextButton.icon(
            onPressed: () => showPicker(context),
            icon: const Icon(
              Icons.image,
              color: Colors.indigo,
            ),
            label: Text(
              'Add Image',
              style: TextStyle(color: Color.fromARGB(250, 253, 180, 27)),
            ))
      ],
    );
  }
}
