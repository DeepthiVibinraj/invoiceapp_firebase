import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String docId;

  const CourseDetailsScreen({Key? key, required this.docId}) : super(key: key);

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isEdit = false;
  List<String> _staffNames = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffNames();
  }

  // Function to fetch staff names from Firestore
  Future<void> _fetchStaffNames() async {
    try {
      QuerySnapshot staffSnapshot =
          await FirebaseFirestore.instance.collection('Staff').get();
      List<String> staffList = staffSnapshot.docs.map((doc) {
        return doc['First Name']
            as String; // Assuming staffName is the field in Firestore
      }).toList();

      setState(() {
        _staffNames = staffList;
      });
    } catch (e) {
      print('Error fetching staff names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: CustomAppBar(
            detailScreen: true,
            deleteFunction: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Confirm Deletion',
                    ),
                    content: Text(
                      'Are you sure you want to delete the course?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes
                              .courseScreen); // Return false to not delete;
                        },
                        child: Text(
                          'Cancel',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.secondary),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('courses_collection')
                              .doc(widget.docId)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Course deleted successfully')));
                          Navigator.of(context)
                              .pop(true); // Return true to delete
                          Get.offAllNamed(AppRoutes.courseScreen);
                        },
                        child: Text('Delete',
                            style: TextStyle(color: colorScheme.secondary)),
                      ),
                    ],
                  );
                },
              );
            }),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('courses_collection')
              .doc(widget.docId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const NoDataFound();
            }

            // Get document data
            final course = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: defaultPadding),
                  HeaderText('Course Detail'),
                  const SizedBox(height: defaultPadding),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Course Name: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    Expanded(flex: 3, child: Text(course!['Course Name']))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),

                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Description: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    Expanded(flex: 3, child: Text(course['Course Description']))
                  ]),
                  const SizedBox(height: defaultPadding),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Course Price: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    Expanded(
                        flex: 3,
                        child: Text('Rs. ${course['Course Price'].toString()}'))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Instructor Name: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                          _staffNames.contains(course['Instructor Name'])
                              ? course['Instructor Name']
                              : 'Not available'),
                    ),
                  ]),

                  const SizedBox(
                    height: defaultPadding / 2,
                  ),

                  const SizedBox(
                    height: defaultPadding,
                  ),
                  // Add more fields as needed
                ],
              ),
            );
          },
        ),
        floatingActionButton: Card(
            child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.edit,
            size: 25,
            color: Color.fromARGB(250, 253, 180, 27),
          ),
          onPressed: () {
            setState(() {
              isEdit = true;
            });
            Get.toNamed(AppRoutes.addCourseScreen, arguments: {
              'argument1': isEdit,
              'argument2': widget.docId,
              // Add more arguments as needed
            });
          },
        )));
  }
}
