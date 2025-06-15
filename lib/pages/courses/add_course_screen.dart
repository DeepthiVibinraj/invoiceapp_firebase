import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptalents/core/theme/common_widgets/cancel_button.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/details_textformfield.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/mandatory_text.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/core/theme/common_widgets/text_form_field.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedInstructor;
  List<String> _staff = [];

  //Course Details
  final _courseNameController = TextEditingController();
  final _courseDescriptionController = TextEditingController();
  final _coursePriceController = TextEditingController();

  //File? _imageFile;
  final picker = ImagePicker();
  String? imageUrl;
  String? itemId;
  bool? isEdit;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getStaff();

    final arguments = Get.arguments;
    isEdit = arguments['argument1'];
    itemId = arguments['argument2'];

    if (isEdit!) {
      fetchDataAndPopulateForm();
    }

    //formattedDate = '';
  }

  void _getStaff() async {
    final staffSnapshot = await _firestore.collection('Staff').get();
    List<String> staff = [];
    staffSnapshot.docs.forEach((doc) {
      staff.add(doc.data()['First Name']);
    });
    setState(() {
      _staff = staff;
    });
  }

  void fetchDataAndPopulateForm() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('courses_collection')
        .doc(itemId)
        .get();
    setState(() {
      imageUrl = snapshot.data()?['url'];
      _courseNameController.text = snapshot.data()?['Course Name'];
      _courseDescriptionController.text =
          snapshot.data()?['Course Description'];
      _selectedInstructor = snapshot.data()?['Instructor Name'];

      _coursePriceController.text = snapshot.data()?['Course Price'];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  //   _uploadImage();
  // }

  // Future<void> _uploadImage() async {
  //   if (_imageFile == null) return;

  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child('images/${DateTime.now().toString()}');
  //   await ref.putFile(_imageFile!);
  //   imageUrl = await ref.getDownloadURL();
  // }

  // DateTime? _selectedDate;
  // String? formattedDate;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //     });
  //   }
  //   formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(
          backButton: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('courses_collection')
                .snapshots(),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        HeaderText(isEdit! ? 'Edit Course' : 'Add Course'),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[]),
                        const mandatoryText(text: 'Course Name'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        customTextFormField(
                            context,
                            colorScheme,
                            textTheme,
                            _courseNameController,
                            'Course Name',
                            TextInputType.name, () {
                          if (_courseNameController.text.trim().isEmpty) {
                            return 'Please enter your course name';
                          }
                          return null;
                        }, 'course_name', 'courseName', false),
                        const SizedBox(height: defaultPadding),
                        const mandatoryText(text: 'Description'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        detailsTextformfield(_courseDescriptionController,
                            context, 'Description', 'description'),
                        const SizedBox(height: defaultPadding),
                        const mandatoryText(text: 'Course Price'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        TextFormField(
                          controller: _coursePriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            if (TextInputType.number == TextInputType.number)
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Course Price',
                            hintStyle: textTheme.labelLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (_coursePriceController.text.trim().isEmpty) {
                              return 'Please enter course price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                        const mandatoryText(text: 'Select an Instructor'),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        DropdownButtonFormField<String>(
                          iconEnabledColor:
                              const Color.fromARGB(250, 253, 180, 27),
                          dropdownColor:
                              const Color.fromARGB(250, 253, 180, 27),
                          value: _staff.contains(_selectedInstructor)
                              ? _selectedInstructor
                              : null,

                          //  value: _selectedInstructor,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedInstructor = value;
                            });
                          },
                          items: _staff.map((staff) {
                            return DropdownMenuItem<String>(
                              value: staff,
                              child: Text(
                                staff,
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            hintText: 'Select an Instructor',
                            hintStyle: textTheme.labelLarge
                                ?.copyWith(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an instructor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: defaultPadding * 1.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CancelButton(
                                function: () =>
                                    Get.offAllNamed(AppRoutes.courseScreen)),
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
                                  await FirebaseFirestore.instance
                                      .collection('courses_collection')
                                      .add({
                                    'url': imageUrl == null
                                        ? 'https://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg'
                                        : imageUrl,
                                    'Course Name': capitalizeFirstLetter(
                                        _courseNameController.text),
                                    'Course Description': capitalizeFirstLetter(
                                        _courseDescriptionController.text),
                                    'Instructor Name': _selectedInstructor,
                                    'Course Price': _coursePriceController.text,
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('courses_collection')
                                      .doc(itemId)
                                      .update({
                                    'url': imageUrl,
                                    'Course Name': capitalizeFirstLetter(
                                        _courseNameController.text),
                                    'Course Description': capitalizeFirstLetter(
                                        _courseDescriptionController.text),
                                    'Instructor Name': _selectedInstructor,
                                    'Course Price': _coursePriceController.text,
                                  });
                                }

                                Get.offAllNamed(AppRoutes.courseScreen);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(!isEdit!
                                            ? 'Course added successfully'
                                            : 'Course updated successfully')));
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
