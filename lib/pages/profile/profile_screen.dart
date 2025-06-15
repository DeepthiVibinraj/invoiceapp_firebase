import 'dart:io';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/cancel_button.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  String? _displayName;
  String? _email;
  String? _photoUrl;
  File? _image;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    _fetchUserDetails();
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: Color.fromARGB(250, 253, 180, 27),
                    ),
                    title: const Text(
                      'Gallery',
                    ),
                    onTap: () {
                      _pickGalleryImage();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera,
                      color: Color.fromARGB(250, 253, 180, 27)),
                  title: const Text(
                    'Camera',
                  ),
                  onTap: () {
                    _pickCameraImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _displayName = snapshot.data()?['name'];
        _email = user.email;
        _photoUrl = snapshot.data()?['photoURL'];
        _displayNameController.text = _displayName ?? '';
      });
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _updateUserDetails() async {
    if (user != null) {
      try {
        await user?.updateDisplayName(_displayNameController.text);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'name': _displayNameController.text,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update details')));
      }
    }
  }

  Future<void> _pickCameraImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _pickGalleryImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _updateUserPhoto() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _image != null) {
      try {
        String imageName = 'profile_image_${user.uid}.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child('profile_images/$imageName');
        await storageReference.putFile(_image!);

        String imageUrl = await storageReference.getDownloadURL();

        await user.updatePhotoURL(imageUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'photoURL': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Updated successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update photo')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(),
        drawer: const SideMenuDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: getPadding(all: defaultPadding),
            child: Column(
              children: [
                _photoUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(_photoUrl!),
                        radius: 50.0,
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(ImageConstant.defaultUser),
                        radius: 50.0,
                      ),
                const SizedBox(height: defaultPadding / 2),
                if (isEdit)
                  TextButton(
                    onPressed: () {
                      showPicker(context);
                    },
                    child: Text(
                      'Change Photo',
                      style: textTheme.titleMedium!
                          .copyWith(color: colorScheme.secondary),
                    ),
                  ),
                if (isEdit)
                  TextButton(
                    onPressed: () async {
                      await deleteImage(_photoUrl!);
                      await removeImageUrl(user!.uid);
                    },
                    child: Text(
                      'Delete Photo',
                      style: textTheme.titleMedium!
                          .copyWith(color: colorScheme.primary),
                    ),
                  ),
                const SizedBox(height: 50.0),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Name :',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    if (_displayName != null && !isEdit)
                      Expanded(
                        flex: 4,
                        child: Text(
                          _displayName!,
                          style: textTheme.bodyLarge!
                              .copyWith(color: Colors.black54),
                        ),
                      ),
                    if (isEdit)
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.red),
                              hintStyle: textTheme.labelLarge
                                  ?.copyWith(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                    color: Colors.deepOrangeAccent
                                        .withOpacity(0.3),
                                    width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Email : ',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    if (_email != null)
                      Expanded(
                        flex: 4,
                        child: Text(
                          _email!,
                          style: textTheme.bodyLarge!
                              .copyWith(color: Colors.black54),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ),
        floatingActionButton: !isEdit
            ? SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.edit,
                    size: 25,
                    color: Color.fromARGB(250, 253, 180, 27),
                  ),
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CancelButton(
                      function: () => Get.offAllNamed(AppRoutes.profileScreen)),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  SubmitButton(function: () {
                    setState(() {
                      isEdit = false;
                    });
                    _updateUserDetails();
                    _updateUserPhoto();
                  })
                ],
              ));
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(imageUrl);

      await storageReference.delete();
    } catch (e) {}
  }

  Future<void> removeImageUrl(String userId) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      await userRef.update({
        'photoURL': ImageConstant.defaultUser,
      });
    } catch (e) {}
  }
}
