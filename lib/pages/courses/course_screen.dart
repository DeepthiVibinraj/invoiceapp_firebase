import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptalents/core/theme/common_widgets/custom_container.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';
import 'package:toptalents/core/theme/common_widgets/no_data_found.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/pages/courses/course_details_screen.dart';
import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _fullList = [];
  List<DocumentSnapshot> _filteredList = [];
  List<String> _staffNames = [];
  //Map staff=FirebaseFirestore.instance.collection('Staff').snapshots();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterList);
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

  void _filterList() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredList = List.from(_fullList);
      } else {
        _filteredList = _fullList
            .where((doc) => doc['Course Name']
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

  Future<void> _handleRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const SideMenuDrawer(),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: getPadding(all: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText('Courses'),
                  IconButton(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.addCourseScreen, arguments: {
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
                  hintText: 'Search Course ...',
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
                    .collection('courses_collection')
                    .orderBy('Course Name', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _fullList = snapshot.data!.docs;

                    if (_searchController.text.isNotEmpty) {
                      _filteredList = _fullList
                          .where((doc) => doc['Course Name']
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
                                          CourseDetailsScreen(docId: doc.id),
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
                                                                      'Course Name'],
                                                                  style: textTheme
                                                                      .titleLarge),
                                                              const SizedBox(
                                                                height:
                                                                    defaultPadding /
                                                                        8,
                                                              ),
                                                              Text(
                                                                  doc[
                                                                      'Course Description'],
                                                                  style: textTheme
                                                                      .bodyMedium)
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: getPadding(
                                                          top: defaultPadding /
                                                              4,
                                                          bottom:
                                                              defaultPadding /
                                                                  4),
                                                      child: const Divider(),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.currency_rupee,
                                                          size: 20,
                                                          // color: Colors
                                                          //         .deepOrangeAccent[
                                                          //     100],
                                                        ),
                                                        const SizedBox(
                                                          width:
                                                              defaultPadding /
                                                                  4,
                                                        ),
                                                        Text(
                                                          doc['Course Price']
                                                              .toString(),
                                                          style: textTheme
                                                              .bodyMedium,
                                                        ),
                                                        const SizedBox(
                                                          width: defaultPadding,
                                                        ),
                                                        const Icon(
                                                          Icons.person,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width:
                                                              defaultPadding /
                                                                  4,
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                          _staffNames.contains(doc[
                                                                  'Instructor Name'])
                                                              ? doc[
                                                                  'Instructor Name']
                                                              : 'Not available',
                                                          style: textTheme
                                                              .bodyMedium,
                                                        )),
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
                                                      CourseDetailsScreen(
                                                          docId: doc.id),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              // color: Colors.deepOrangeAccent[100],
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
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
