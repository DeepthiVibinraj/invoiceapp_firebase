import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/custom_container.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';
import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';
import 'package:toptalents/pages/vendor/vendor_details_screen.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _fullList = [];
  List<DocumentSnapshot> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredList = List.from(_fullList);
      } else {
        _filteredList = _fullList
            .where((doc) => doc['Vendor Name']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const SideMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: getPadding(all: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText('Vendors'),
                IconButton(
                    onPressed: () =>
                        Get.toNamed(AppRoutes.addVendorScreen, arguments: {
                          'argument1': false,
                          'argument2': null,
                        }),
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 25,
                ),
                hintText: 'Search Vendor ...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendor_collection')
                  .orderBy('Vendor Name', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _fullList = snapshot.data!.docs;

                  if (_searchController.text.isNotEmpty) {
                    _filteredList = _fullList
                        .where((doc) => doc['Vendor Name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();
                  } else {
                    _filteredList = List.from(_fullList);
                  }

                  return _filteredList.isEmpty
                      ? const NoDataFound()
                      : ListView.builder(
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final doc = _filteredList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VendorDetailsScreen(docId: doc.id),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: getPadding(
                                    left: defaultPadding,
                                    right: defaultPadding),
                                child: CustomContainer(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                doc[
                                                                    'Vendor Name'],
                                                                style: textTheme
                                                                    .titleLarge),
                                                            const SizedBox(
                                                              height:
                                                                  defaultPadding /
                                                                      8,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: defaultPadding / 2,
                                                  ),
                                                  Text(
                                                    doc['City'],
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                  Padding(
                                                    padding: getPadding(
                                                        top: defaultPadding / 4,
                                                        bottom:
                                                            defaultPadding / 4),
                                                    child: const Divider(),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.call,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width:
                                                            defaultPadding / 4,
                                                      ),
                                                      Text(doc['Phone Number']
                                                          .toString()),
                                                      const SizedBox(
                                                        width: defaultPadding,
                                                      ),
                                                      const Icon(
                                                        Icons.mail,
                                                        size: 20,
                                                      ),
                                                      const SizedBox(
                                                        width:
                                                            defaultPadding / 4,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                              doc['Email'])),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VendorDetailsScreen(
                                                        docId: doc.id),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
