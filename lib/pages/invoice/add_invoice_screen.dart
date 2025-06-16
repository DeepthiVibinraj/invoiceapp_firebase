import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/core/theme/common_widgets/cancel_button.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/form_label.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/mandatory_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';
import 'package:toptalents/core/theme/common_widgets/submit_button.dart';
import 'package:toptalents/core/theme/common_widgets/text_form_field.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _invoiceDueDateController =
      TextEditingController();
  DateTime _invoiceDate = DateTime.now();
  DateTime _invoiceDueDate = DateTime.now().add(const Duration(days: 15));
  String? itemId;
  bool? isEdit;
  String? vendorName;

  List<String> _selectedCoursesNew = [];

  Future<void> _selectDate(BuildContext context, bool isInvoiceDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isInvoiceDate ? _invoiceDate : _invoiceDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != (isInvoiceDate ? _invoiceDate : _invoiceDueDate)) {
      setState(() {
        if (isInvoiceDate) {
          _invoiceDate = picked;
          _invoiceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _invoiceDueDate = picked;
          _invoiceDueDateController.text =
              DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    final arguments = Get.arguments;
    isEdit = arguments['argument1'];
    itemId = arguments['argument2'];
    vendorName = arguments['argument3'];

    if (isEdit!) {
      fetchDataAndPopulateForm();
    }
    _getVendors();

    _fetchCourses();
    if (itemId != null) {
      _fetchInvoiceDetails();
    }
    _invoiceDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    _invoiceDueDateController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 15)));
  }

  Future<void> _fetchCourses() async {
    try {
      setState(() {
// Done loading
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {});
    }
  }

  Future<void> _fetchInvoiceDetails() async {
    try {
      DocumentSnapshot invoiceDoc = await FirebaseFirestore.instance
          .collection('invoice_collection')
          .doc(itemId)
          .get();

      if (invoiceDoc.exists) {
        Map<String, dynamic> invoiceData =
            invoiceDoc.data() as Map<String, dynamic>;
        setState(() {
          _selectedCoursesNew =
              List<String>.from(invoiceData['selectedCourses'] ?? []);
        });
      }
    } catch (e) {
      print('Error fetching invoice details: $e');
    }
  }

  void _onCourseSelected(String courseName) {
    setState(() {
      if (_selectedCoursesNew.contains(courseName)) {
        _selectedCoursesNew.remove(courseName);
      } else {
        _selectedCoursesNew.add(courseName);
      }
    });
  }

  Future<void> _saveInvoice() async {
    String notes = _noteController.text.trim().isEmpty
        ? "Thank you"
        : _noteController.text.trim();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (itemId == null) {
          String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

          String invoiceId = 'INV$uniqueId';

          await FirebaseFirestore.instance
              .collection('invoice_collection')
              .add({
            'invoiceId': invoiceId,
            'Vendor Name': selectedVendor,
            'notes': notes,
            'isShared': false,
            'timestamp': FieldValue.serverTimestamp(),
            'selectedCourses': _selectedCoursesNew,
            'gstRate': _gstRateController.text,
            'invoiceDate': _invoiceDateController.text,
            'invoiceDueDate': _invoiceDueDateController.text,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('invoice_collection')
              .doc(itemId)
              .update({
            // 'invoiceId': invoi,
            'Vendor Name': vendorName!,

            'notes': _noteController.text,
            'isShared': false,
            'timestamp': FieldValue.serverTimestamp(),
            'selectedCourses': _selectedCoursesNew,
            'gstRate': _gstRateController.text,
            'invoiceDate': _invoiceDateController.text,
            'invoiceDueDate': _invoiceDueDateController
                .text, // Update other invoice details here
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(!isEdit!
                  ? 'Invoice created successfully.'
                  : 'Invoice updated successfully')),
        );
        Get.offAllNamed(AppRoutes.invoiceScreen);
        // Get.back();/ Go back after saving
      } catch (e) {
        print('Error saving invoice: $e');
      }
      //ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Text(!isEdit!
      //             ? 'Invoice created successfully.'
      //             : 'Invoice updated successfully')),
      //   );
      //   Get.offAllNamed(AppRoutes.invoiceScreen);
      //   // Get.back();
    }
  }
  ///////////////////////////////////////////

  void fetchDataAndPopulateForm() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('invoice_collection')
        .doc(itemId)
        .get();

    setState(() {
      _invoiceDateController.text = snapshot.data()!['invoiceDate'];
      _invoiceDueDateController.text = snapshot.data()!['invoiceDueDate'];
      //_selectedCourses = snapshot.data()!['selectedCourses'];
      _gstRateController.text = snapshot.data()!['gstRate'];
      _noteController.text = snapshot.data()!['notes'];
      //   imageUrl = snapshot.data()?['url'];
      // _courseNameController.text = snapshot.data()?['Course Name'];
      // _courseDescriptionController.text =
      //     snapshot.data()?['Course Description'];
      // //_selectedInstructor = snapshot.data()?['Instructor Name'];

      // _coursePriceController.text = snapshot.data()?['Course Price'];
    });
  }

  void _getVendors() async {
    final fruitSnapshot =
        await _firestore.collection('vendor_collection').get();
    List<String> vendors = [];
    fruitSnapshot.docs.forEach((doc) {
      vendors.add(doc.data()['Vendor Name']);
    });
    setState(() {});
  }

  Query vendorsQuery =
      FirebaseFirestore.instance.collection('vendor_collection');
  String? selectedVendor;
  List<String>? selectedCourses;
  Map<String, TextEditingController> participantControllers = {};
  final _gstRateController = TextEditingController();
  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String InvoiceName = '';

  final CollectionReference sourceCollection =
      FirebaseFirestore.instance.collection('courses_collection');
  final CollectionReference targetCollection =
      FirebaseFirestore.instance.collection('invoice_collection');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        backButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: getPadding(all: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderText(!isEdit! ? 'Add Invoice' : 'Edit Invoice'),
              const SizedBox(
                height: defaultPadding,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const mandatoryText(text: 'Select a Vendor'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      if (isEdit!)
                        Text(vendorName!,
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.black54)),
                      if (!isEdit!)
                        StreamBuilder<QuerySnapshot>(
                          stream: vendorsQuery.snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            final List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  iconEnabledColor:
                                      const Color.fromARGB(250, 253, 180, 27),
                                  dropdownColor:
                                      const Color.fromARGB(250, 253, 180, 27),
                                  value: selectedVendor,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedVendor = newValue;
                                      selectedCourses = documents
                                          .firstWhere((doc) =>
                                              doc['Vendor Name'] ==
                                              newValue)['selectedCourses']
                                          .cast<String>();
                                      participantControllers = {
                                        for (var course in selectedCourses!)
                                          course: TextEditingController()
                                      };
                                    });
                                  },
                                  items: documents
                                      .map<DropdownMenuItem<String>>(
                                          (DocumentSnapshot document) {
                                    final data =
                                        document.data() as Map<String, dynamic>;
                                    return DropdownMenuItem<String>(
                                      value: data['Vendor Name'],
                                      child: Text(data['Vendor Name']),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: 'Select a Vendor',
                                    hintStyle: textTheme.labelLarge
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a vendor';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      NonMandatoryText(text: 'Invoice Date'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      TextFormField(
                        controller: _invoiceDateController,
                        decoration: InputDecoration(
                            hintText: 'Invoice Date',
                            suffixIcon: GestureDetector(
                                onTap: () => _selectDate(context, true),
                                child: const Icon(Icons.calendar_month))),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      NonMandatoryText(text: 'Invoice Due Date'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      TextFormField(
                        controller: _invoiceDueDateController,
                        decoration: InputDecoration(
                            hintText: 'Invoice Due Date',
                            suffixIcon: GestureDetector(
                                onTap: () => _selectDate(context, false),
                                child: const Icon(Icons.calendar_month))),
                        readOnly: true,
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const mandatoryText(text: 'Select Courses'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: sourceCollection.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const NoDataFound();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormField<List<String>>(
                                initialValue: _selectedCoursesNew,
                                validator: (value) {
                                  if (_selectedCoursesNew.isEmpty) {
                                    return 'Please select at least one course';
                                  }
                                  return null; // No error if a course is selected
                                },
                                builder: (FormFieldState<List<String>> field) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        children:
                                            snapshot.data!.docs.map((doc) {
                                          Map<String, dynamic> data = doc.data()
                                              as Map<String, dynamic>;
                                          String courseName =
                                              data['Course Name'];
                                          return CheckboxListTile(
                                            side: const BorderSide(
                                              color: Color.fromARGB(
                                                  250, 253, 180, 27),
                                            ),
                                            checkColor: Colors.white,
                                            activeColor: const Color.fromARGB(
                                                250, 253, 180, 27),
                                            title: Text(
                                              courseName,
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.black54),
                                            ),
                                            value: _selectedCoursesNew
                                                .contains(courseName),
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _onCourseSelected(courseName);
                                                field.didChange(
                                                    _selectedCoursesNew); // Notify FormField of state change
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      if (field.hasError)
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              defaultPadding / 2),
                                          child: Text(
                                            field.errorText ?? '',
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const mandatoryText(text: 'GST Rate'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      customTextFormField(
                          context,
                          colorScheme,
                          textTheme,
                          _gstRateController,
                          'GST Rate (%)',
                          TextInputType.number, () {
                        if (_gstRateController.text.trim().isEmpty) {
                          return 'Please enter GST Rate';
                        }
                        return null;
                      }, 'gst_rate', 'gst', false),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      NonMandatoryText(text: 'Add Notes'),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      TextFormField(
                        maxLines: 4,
                        key: const ValueKey('notes'),
                        validator: (value) {
                          return null;
                        },
                        controller: _noteController,
                        keyboardType: TextInputType.multiline,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              150), // Set your desired max length here
                        ],
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(color: Colors.red),
                          hintText: "Notes: ",
                          hintStyle: textTheme.labelLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CancelButton(
                              function: () =>
                                  Get.offAllNamed(AppRoutes.invoiceScreen)),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          SubmitButton(
                              text: !isEdit! ? 'Create' : 'Update',
                              function: () {
                                _saveInvoice();
                              })
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
