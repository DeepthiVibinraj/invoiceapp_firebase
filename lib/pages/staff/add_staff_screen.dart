import 'dart:io';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toptalents/core/theme/common_widgets/cancel_button.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/form_label.dart';
import 'package:toptalents/core/theme/common_widgets/form_sub_head.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/mandatory_text.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/core/theme/common_widgets/text_form_field.dart';

class AddStaffScreen extends StatefulWidget {
  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  //Personal Details
  final _staffFirstNameController = TextEditingController();
  final TextEditingController _staffLastNameController =
      TextEditingController();
  final TextEditingController _staffDobController = TextEditingController();
  //Contact Details
  final TextEditingController _staffPhoneNumberController =
      TextEditingController();
  final TextEditingController _staffEmailController = TextEditingController();
  final TextEditingController _staffDesignationController =
      TextEditingController();
  //Address
  final TextEditingController _staffAddress1Controller =
      TextEditingController();
  final TextEditingController _staffAddress2Controller =
      TextEditingController();
  final TextEditingController _staffCityController = TextEditingController();

  String selectedCountry = "";
  String selectedState = "";
  File? _imageFile;
  final picker = ImagePicker();
  String? imageUrl;
  String? itemId;
  bool? isEdit;
  String? oldName;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    final arguments = Get.arguments;
    isEdit = arguments['argument1'];
    itemId = arguments['argument2'];

    if (isEdit!) {
      fetchDataAndPopulateForm();
    }

    formattedDate = '';
  }

  void fetchDataAndPopulateForm() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('Staff').doc(itemId).get();
    setState(() {
      imageUrl = snapshot.data()?['url'];

      _staffFirstNameController.text = snapshot.data()?['First Name'];
      oldName = snapshot.data()?['First Name'];
      _staffLastNameController.text = snapshot.data()?['Last Name'];
      formattedDate = snapshot.data()?['Date of Birth'];
      _staffDesignationController.text = snapshot.data()?['Designation'];
      _staffAddress1Controller.text = snapshot.data()?['Address Line1'];
      _staffAddress2Controller.text = snapshot.data()?['Address Line2'];
      _staffCityController.text = snapshot.data()?['City'];
      //_staffDobController.text = snapshot.data()?['Date of Birth'];

      _staffEmailController.text = snapshot.data()?['Email'];
      _staffPhoneNumberController.text = snapshot.data()?['Phone Number'];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Variables.country = '';
    // Variables.state = '';
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toString()}');
    await ref.putFile(_imageFile!);
    imageUrl = await ref.getDownloadURL();
  }

  DateTime? _selectedDate;
  String? formattedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
    formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    _staffDobController.text = formattedDate.toString();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(
          backButton: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Staff').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        HeaderText(isEdit! ? 'Edit Staff' : 'Add Staff'),

                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),

                        Row(
                          children: [
                            isEdit!
                                ? Center(
                                    child: imageUrl == null
                                        ? const Icon(
                                            Icons.account_circle,
                                            size: 100.0,
                                            color: Colors.grey,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            child: Image.network(imageUrl!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover)))
                                : Center(
                                    child: _imageFile == null
                                        ? const Icon(
                                            Icons.account_circle,
                                            size: 100.0,
                                            color: Colors.grey,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            child: Image.file(
                                              _imageFile!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            )),
                                  ),
                            TextButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                child: Text(
                                  isEdit! ? 'Change Photo' : 'Add Photo',
                                  style: textTheme.titleLarge!.copyWith(
                                      color: const Color.fromARGB(
                                          250, 253, 180, 27)),
                                )),

                            // ElevatedButton(
                            //   onPressed: _uploadImage,
                            //   child: Text('Upload Image'),
                            // ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        const FormSubHead(text: 'Personal Detail'),
                        const SizedBox(height: 20),

                        const mandatoryText(text: 'First Name'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[]),

                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffFirstNameController,
                            'First Name',
                            TextInputType.name, () {
                          if (_staffFirstNameController.text.trim().isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        }, 'first_name', 'firstName', false),

                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        NonMandatoryText(text: 'Last Name'),

                        const SizedBox(
                          height: defaultPadding / 2,
                        ),

                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffLastNameController,
                            'Last Name',
                            TextInputType.name, () {
                          return null;
                        }, 'last_name', 'lastName', false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        NonMandatoryText(text: 'Date of Birth'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),

                        TextFormField(
                          readOnly: true,
                          controller: _staffDobController,
                          decoration: InputDecoration(
                            hintText: 'Date of birth',
                            hintStyle: textTheme.labelLarge
                                ?.copyWith(color: Colors.grey),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  //color: Colors.deepOrangeAccent,
                                )),
                          ),
                        ),

                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        // Divider(),
                        // const SizedBox(
                        //   height: defaultPadding * 1.5,
                        // ),
                        mandatoryText(text: 'Designation'),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffDesignationController,
                            'Designation',
                            TextInputType.text, () {
                          if (_staffDesignationController.text.trim().isEmpty) {
                            return 'Please enter designation';
                          }

                          return null;
                        }, 'designation', 'designation', false),

                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),

                        const Divider(),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        const FormSubHead(text: 'Contact Details'),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        mandatoryText(text: 'Phone Number'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffPhoneNumberController,
                            'Phone number',
                            TextInputType.phone, () {
                          if (_staffPhoneNumberController.text.trim().isEmpty ||
                              _staffPhoneNumberController.text.trim().length !=
                                  10) {
                            return 'Please enter ten digits phone number';
                          }

                          return null;
                        }, 'phone_number', 'phoneNumber', false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        mandatoryText(text: 'Email'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),

                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffEmailController,
                            'Email',
                            TextInputType.emailAddress, () {
                          if (_staffEmailController.text.trim().isEmpty) {
                            return 'Please enter staff email';
                          }
                          // Basic email validation
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(_staffEmailController.text.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }, 'email', 'email', false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        // Divider(),
                        // const SizedBox(
                        //   height: defaultPadding * 1.5,
                        // ),
                        NonMandatoryText(text: 'Address'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffAddress1Controller,
                            'Address Line 1',
                            TextInputType.streetAddress, () {
                          return null;
                        }, 'address_line1', "addressLine1", false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffAddress2Controller,
                            'Address Line 2',
                            TextInputType.streetAddress, () {
                          return null;
                        }, 'address_line2', "addressLine2", false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _staffCityController,
                            'City',
                            TextInputType.streetAddress, () {
                          return null;
                        }, 'city', "city", false),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),

                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CancelButton(function: () {
                              Get.offAllNamed(AppRoutes.staffScreen);
                            }),
                            const SizedBox(
                              width: defaultPadding,
                            ),
                            SubmitButton(function: () async {
                              print('haiiiiiiiiiiii');
                              print(isEdit);
                              print(itemId);
                              print('hoooooooooooooooi');
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (!isEdit!) {
                                  // String capitalizedFirstName =
                                  //     capitalizeFirstLetter(
                                  //         _staffFirstNameController.text);
                                  await FirebaseFirestore.instance
                                      .collection('Staff')
                                      .add({
                                    'url':
                                        imageUrl ?? ImageConstant.defaultUser,
                                    'First Name': capitalizeFirstLetter(
                                        _staffFirstNameController.text),
                                    // _staffFirstNameController.text,
                                    'Last Name': capitalizeFirstLetter(
                                        _staffLastNameController.text),
                                    'Date of Birth': _staffDobController.text,
                                    'Phone Number':
                                        _staffPhoneNumberController.text,
                                    'Email': _staffEmailController.text,
                                    'Designation': capitalizeFirstLetter(
                                        _staffDesignationController.text),

                                    'Address Line1': capitalizeFirstLetter(
                                        _staffAddress1Controller.text),

                                    'Address Line2': capitalizeFirstLetter(
                                        _staffAddress2Controller.text),

                                    'City': capitalizeFirstLetter(
                                      _staffCityController.text,
                                    ),

                                    // 'state': Variables.state,
                                    // 'country': Variables.country
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('Staff')
                                      .doc(itemId)
                                      .update({
                                    'url':
                                        imageUrl ?? ImageConstant.defaultUser,
                                    'First Name': capitalizeFirstLetter(
                                        _staffFirstNameController.text),
                                    'Last Name': capitalizeFirstLetter(
                                        _staffLastNameController.text),

                                    'Date of Birth': _staffDobController.text,
                                    'Phone Number':
                                        _staffPhoneNumberController.text,
                                    'Email': _staffEmailController.text,
                                    'Designation': capitalizeFirstLetter(
                                        _staffDesignationController.text),

                                    'Address Line1': capitalizeFirstLetter(
                                        _staffAddress1Controller.text),

                                    'Address Line2': capitalizeFirstLetter(
                                        _staffAddress2Controller.text),

                                    'City': capitalizeFirstLetter(
                                        _staffCityController.text),

                                    // 'state': Variables.state,
                                    // 'country': Variables.country
                                  });

                                  QuerySnapshot querySnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('courses_collection')
                                          .where('Instructor Name',
                                              isEqualTo: oldName)
                                          .get();
                                  for (QueryDocumentSnapshot doc
                                      in querySnapshot.docs) {
                                    await FirebaseFirestore.instance
                                        .collection('courses_collection')
                                        .doc(doc.id)
                                        .update({
                                      'Instructor Name':
                                          _staffFirstNameController.text,
                                    });
                                  }
                                }

                                Get.offAndToNamed(AppRoutes.staffScreen);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(!isEdit!
                                            ? 'Staff added successfully'
                                            : 'Staff updated successfully')));
                              }
                            })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
