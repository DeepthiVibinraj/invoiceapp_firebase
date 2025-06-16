import 'package:toptalents/pages/home/widgets/grid_menu_model.dart';
import 'package:toptalents/app_export.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:flutter/material.dart';

class GridMenu extends StatelessWidget {
  GridMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      int crossAxisCount;
      if (constraints.maxWidth > 1200) {
        crossAxisCount = 5;
      } else if (constraints.maxWidth > 800) {
        crossAxisCount = 3;
      } else {
        crossAxisCount = 2;
      }
      return SizedBox(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: menus.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Get.toNamed(menus[index].route),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    // Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(defaultPadding / 2)),
                padding: getPadding(all: defaultPadding / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      image: AssetImage(
                        menus[index].image,
                      ),
                      height: height * 0.1,
                      width: width * 0.2,
                    ),
                    Center(
                      child: Text(
                        menus[index].menuName,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
