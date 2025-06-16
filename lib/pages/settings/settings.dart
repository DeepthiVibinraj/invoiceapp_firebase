import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/core/theme/common_widgets/custom_appbar.dart';
import 'package:toptalents/core/theme/common_widgets/custom_container.dart';
import 'package:toptalents/core/theme/common_widgets/header_text.dart';

import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showNotSent = true;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const SideMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: getPadding(all: defaultPadding),
            child: HeaderText('Settings'),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: CustomContainer(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.password),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text('Reset Password'),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_sharp),
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.resetPasswordScreen);
                  },
                )
              ],
            )

                // ListTile(
                //     leading: const Icon(Icons.password),
                //     title: const Text('Reset Password'),
                //     trailing: ),
                ),
          )
        ],
      ),
    );
  }
}
