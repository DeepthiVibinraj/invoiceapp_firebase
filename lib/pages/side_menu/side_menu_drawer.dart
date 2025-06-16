import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/auth_screen.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/pages/staff/staff_screen.dart';

class SideMenuDrawer extends StatefulWidget {
  const SideMenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(color: Colors.indigo[100]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.asset(
                              ImageConstant.institution_emblem,
                              height: height * 0.2,
                            ),
                          ),
                        ],
                      )),
                  DrawerListTile(
                    title: "Staff".tr,
                    icon: Icons.person,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StaffScreen(),
                      ));
                    },
                  ),
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Courses",
                    icon: Icons.cast_for_education,
                    press: () {
                      Get.offAllNamed(AppRoutes.courseScreen);
                    },
                  ),
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Vendors".tr,
                    icon: Icons.business,
                    press: () {
                      Get.offAllNamed(AppRoutes.vendorScreen);
                    },
                  ),
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Invoices".tr,
                    icon: Icons.list_alt_sharp,
                    press: () {
                      Get.offAllNamed(AppRoutes.invoiceScreen);
                    },
                  ),
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Profile".tr,
                    icon: Icons.account_box,
                    press: () {
                      Get.offAllNamed(AppRoutes.profileScreen);
                    },
                  ),
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Settings".tr,
                    icon: Icons.settings,
                    press: () {
                      Get.offAllNamed(AppRoutes.settingsScreen);
                    },
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  const Divider(
                      indent: defaultPadding, endIndent: defaultPadding),
                  Padding(
                    padding:
                        getPadding(left: defaultPadding, right: defaultPadding),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Version 1.1.0',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: Colors.black54),
                            ),
                            IconButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut().then(
                                      (value) => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthScreen())));
                                },
                                icon: const Icon(
                                  Icons.logout,
                                ))
                          ],
                        ),
                        FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            String displayName = snapshot.data!['name'];

                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: textTheme.bodyLarge!
                                            .copyWith(color: Colors.black87),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: press,
      leading: Icon(
        icon,
        color: const Color.fromARGB(250, 253, 180, 27),
      ),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: Colors.black54),
      ),
    );
  }
}
