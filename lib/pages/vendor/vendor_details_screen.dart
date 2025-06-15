import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';

class VendorDetailsScreen extends StatefulWidget {
  final String docId;

  const VendorDetailsScreen({Key? key, required this.docId}) : super(key: key);

  @override
  State<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> {
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
                      'Are you sure you want to delete the vendor?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.vendorScreen);
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
                              .collection('vendor_collection')
                              .doc(widget.docId)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Vendor deleted successfully')));
                          Navigator.of(context).pop(true);
                          Get.offAllNamed(AppRoutes.vendorScreen);
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
              .collection('vendor_collection')
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

            final vendor = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderText('Vendor Details'),
                  const SizedBox(height: defaultPadding),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Name: ',
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    Expanded(flex: 3, child: Text(vendor['Vendor Name']))
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
                    Expanded(
                      flex: 3,
                      child: Text(vendor['Address Line1'] +
                          ", " +
                          vendor['Address Line2'] +
                          "\n" +
                          vendor['City']),
                    ),
                  ]),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
                  Text(
                    'Contact Details',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Row(children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Phone Number: ',
                          style: textTheme.titleMedium!
                              .copyWith(color: Colors.black54),
                        )),
                    Expanded(flex: 3, child: Text(vendor['Phone Number']))
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
                    Expanded(flex: 3, child: Text(vendor['Email']))
                  ]),
                  const SizedBox(
                    height: defaultPadding,
                  ),
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
            Get.toNamed(AppRoutes.addVendorScreen, arguments: {
              'argument1': isEdit,
              'argument2': widget.docId,
            });
          },
        )));
  }
}
