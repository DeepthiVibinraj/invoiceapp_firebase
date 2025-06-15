import 'package:flutter/material.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData icon;
  final String route;
  final bool backButton;
  final bool detailScreen;
  final VoidCallback deleteFunction;
  const CustomAppBar(
      {this.icon = Icons.home,
      this.route = AppRoutes.homeScreen,
      this.backButton = false,
      VoidCallback? deleteFunction,
      this.detailScreen = false,
      super.key})
      : this.deleteFunction = deleteFunction ?? _defaultDeleteFunction;
  static void _defaultDeleteFunction() {
    print("Default delete function called");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: backButton
          ? BackButton(
              onPressed: () => Get.back(),
            )
          : null,
      backgroundColor: colorScheme.primary,
      actions: [
        if (!detailScreen)
          IconButton(onPressed: () => Get.offAllNamed(route), icon: Icon(icon)),
        if (detailScreen)
          PopupMenuButton<String>(
            onSelected: (String result) {
              print(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'home',
                onTap: () => Get.offAllNamed(AppRoutes.homeScreen),
                child: const Row(
                  children: [
                    Icon(Icons.home),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text('Home'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                onTap: deleteFunction,
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return AppBar().preferredSize;
  }
}
