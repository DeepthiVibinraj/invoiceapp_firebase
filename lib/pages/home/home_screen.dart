import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:toptalents/pages/home/widgets/grid_menu.dart';
import 'package:toptalents/pages/home/widgets/latest_activity.dart';
import 'package:toptalents/pages/home/widgets/welcome.dart';
import 'package:toptalents/pages/side_menu/side_menu_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 97, 152),
        title: const Text(''),
      ),
      drawer: const SideMenuDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Welcome(),
            Padding(
              padding: getPadding(all: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [GridMenu(), const LatestActivity()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
