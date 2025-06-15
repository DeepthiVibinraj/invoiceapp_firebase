import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/cancel_button.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/text_form_field.dart';
import 'package:toptalents/pages/vendor/vendor_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/mandatory_text.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({super.key});

  @override
  _AddVendorScreenState createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  bool? isEdit = false;
  String? itemId;
  String selectedVendorCountry = "";
  String selectedVendorState = "";
  final List<String> _selectedCourses = [];
  final CollectionReference sourceCollection =
      FirebaseFirestore.instance.collection('courses_collection');
  final CollectionReference targetCollection =
      FirebaseFirestore.instance.collection('vendor_collection');
  //String? _vendorName;
  final _formKey = GlobalKey<FormState>();
  final _vendorNameController = TextEditingController();
  final TextEditingController _vendorPhoneNumberController =
      TextEditingController();
  final TextEditingController _vendorEmailController = TextEditingController();
  //Address
  final TextEditingController _vendorAddress1Controller =
      TextEditingController();
  final TextEditingController _vendorAddress2Controller =
      TextEditingController();
  final TextEditingController _vendorCityController = TextEditingController();
  final _vendorCountryController = TextEditingController();
  final _vendorStateController = TextEditingController();

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
  }

  void fetchDataAndPopulateForm() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('vendor_collection')
        .doc(itemId)
        .get();
    setState(() {
      _vendorNameController.text = snapshot.data()?['Vendor Name'];
      _selectedCourses;

      _vendorAddress1Controller.text = snapshot.data()?['Address Line1'];
      _vendorAddress2Controller.text = snapshot.data()?['Address Line2'];
      _vendorCityController.text = snapshot.data()?['City'];

      _vendorEmailController.text = snapshot.data()?['Email'];
      _vendorPhoneNumberController.text = snapshot.data()?['Phone Number'];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _onCourseSelected(String courseName) {
  //   setState(() {
  //     if (_selectedCourses.contains(courseName)) {
  //       _selectedCourses.remove(courseName);
  //     } else {
  //       _selectedCourses.add(courseName);
  //     }
  //   });
  // }

  Future<void> _saveSelectedCourses() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await targetCollection.add({
          'date': DateTime.now(),
          'Vendor Name': capitalizeFirstLetter(_vendorNameController.text),
          'Phone Number': _vendorPhoneNumberController.text,
          'Email': _vendorEmailController.text,
          'Address Line1':
              capitalizeFirstLetter(_vendorAddress1Controller.text),
          'Address Line2':
              capitalizeFirstLetter(_vendorAddress2Controller.text),
          'City': capitalizeFirstLetter(_vendorCityController.text),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vendor added successfully.')),
        );
        Get.offAllNamed(AppRoutes.vendorScreen);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VendorsScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error saving data: $e')));
      }
    }
  }

  Future<void> _updateVendorDetails() async {
    if (_vendorNameController.text == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter a vendor name and select at least one course.')),
      );
      return;
    }

    try {
      await targetCollection.doc(itemId).update({
        'date': DateTime.now(),
        'Vendor Name': capitalizeFirstLetter(_vendorNameController.text),
        'Phone Number': _vendorPhoneNumberController.text,
        'Email': _vendorEmailController.text,
        'Address Line1': capitalizeFirstLetter(_vendorAddress1Controller.text),
        'Address Line2': capitalizeFirstLetter(_vendorAddress2Controller.text),
        'City': capitalizeFirstLetter(_vendorCityController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vendor updated successfully')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VendorsScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    _vendorCountryController.text = selectedVendorCountry;
    _vendorStateController.text = selectedVendorState;
    return Scaffold(
      appBar: CustomAppBar(
        backButton: true,
      ),
      backgroundColor: colorScheme.surface,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: getPadding(all: defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(isEdit! ? 'Edit Vendor' : 'Add Vendor'),
                const SizedBox(
                  height: defaultPadding,
                ),
                const mandatoryText(text: 'Vendor Name'),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorNameController,
                    'Vendor Name',
                    TextInputType.name, () {
                  if (_vendorNameController.text.trim().isEmpty) {
                    return 'Please enter vendor name';
                  }
                  return null;
                }, 'vendor_name', 'vendorName', false),
                const SizedBox(
                  height: defaultPadding,
                ),
                const mandatoryText(text: 'Phone Number'),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorPhoneNumberController,
                    'Phone number',
                    TextInputType.phone, () {
                  if (_vendorPhoneNumberController.text.trim().isEmpty ||
                      _vendorPhoneNumberController.text.trim().length != 10) {
                    return 'Please enter ten digits phone number';
                  }

                  return null;
                }, 'phone_number', 'phoneNumber', false),
                const SizedBox(
                  height: defaultPadding,
                ),
                const mandatoryText(text: 'Email'),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorEmailController,
                    'Email',
                    TextInputType.emailAddress, () {
                  if (_vendorEmailController.text.trim().isEmpty) {
                    return 'Please enter vendor email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(_vendorEmailController.text.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }, 'email', 'email', false),
                const SizedBox(
                  height: defaultPadding,
                ),
                const mandatoryText(text: 'Address'),
                const SizedBox(
                  height: defaultPadding / 2,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorAddress1Controller,
                    'Address Line 1',
                    TextInputType.streetAddress, () {
                  if (_vendorAddress1Controller.text.trim().isEmpty) {
                    return 'Please enter address line1';
                  }
                  return null;
                }, 'address_line1', "addressLine1", false),
                const SizedBox(
                  height: defaultPadding * 1.5,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorAddress2Controller,
                    'Address Line 2',
                    TextInputType.streetAddress, () {
                  if (_vendorAddress2Controller.text.trim().isEmpty) {
                    return 'Please enter address line2';
                  }
                  return null;
                }, 'address_line2', "addressLine2", false),
                const SizedBox(
                  height: defaultPadding * 1.5,
                ),
                customTextFormField(
                    context,
                    colorScheme,
                    textTheme,
                    _vendorCityController,
                    'City',
                    TextInputType.streetAddress, () {
                  if (_vendorCityController.text.trim().isEmpty) {
                    return 'Please enter city';
                  }
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
                    CancelButton(
                        function: () =>
                            Get.offAllNamed(AppRoutes.vendorScreen)),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    SubmitButton(
                        function: !isEdit!
                            ? _saveSelectedCourses
                            : _updateVendorDetails)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
}
