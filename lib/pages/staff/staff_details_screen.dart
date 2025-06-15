import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';

class StaffDetailsScreen extends StatefulWidget {
  final String docId;

  const StaffDetailsScreen({super.key, required this.docId});

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  bool isEdit = false;
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
                    content: const Text(
                      'Are you sure you want to delete the staff?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.staffScreen);
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
                              .collection('Staff')
                              .doc(widget.docId)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Staff deleted successfully')));
                          Navigator.of(context).pop(true);
                          Get.offAllNamed(AppRoutes.staffScreen);
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
              .collection('Staff')
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
            final staff = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: staff['url'] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(staff['url']),
                            radius: 50.0,
                            backgroundColor: Colors.amber,
                          )
                        : const Icon(
                            Icons.account_circle,
                            size: 100.0,
                            color: Colors.grey,
                          ),
                  ),

                  const SizedBox(height: defaultPadding * 2),
                  Text(
                    'Personal Details',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Name: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: Text(staff['First Name'] + staff['Last Name']))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Date of Birth: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    if (staff['Date of Birth'].isNotEmpty)
                      Expanded(flex: 3, child: Text(staff['Date of Birth']))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Address: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    if (staff['Date of Birth'].isNotEmpty)
                      Expanded(
                        flex: 3,
                        child: Text(staff['Address Line1'] +
                                "\n" +
                                staff['Address Line2'] +
                                "\n" +
                                staff['City']
                            // ","
                            // +
                            // itemData['state'] +
                            // "\n" +
                            // itemData['country']
                            ),
                      ),
                  ]),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Text(
                    'Designation',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Designation: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    Expanded(flex: 3, child: Text(staff['Designation']))
                  ]),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),

                  Text(
                    'Contact Details',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Phone Number: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    Expanded(flex: 3, child: Text(staff['Phone Number']))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Email: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    Expanded(flex: 3, child: Text(staff['Email']))
                  ]),
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
          child: const Icon(Icons.edit,
              size: 25, color: Color.fromARGB(250, 253, 180, 27)),
          onPressed: () {
            setState(() {
              isEdit = true;
            });
            Get.toNamed(AppRoutes.addStaffScreen, arguments: {
              'argument1': isEdit,
              'argument2': widget.docId,
            });
          },
        )));
  }
}
