import 'package:toptalents/app_export.dart';
import 'package:toptalents/core/utils/size_utils.dart';
import 'package:toptalents/constants/constants.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  PageHeader({
    super.key,
    required this.textTheme,
    required this.header,
    required this.function,
    required this.action,
  });

  final TextTheme textTheme;
  String header;
  Function function;
  String action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: getPadding(all: defaultPadding),
      color: colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              header,
              style: textTheme.headlineMedium,
            ),
          ),
          if (action.isNotEmpty)
            GestureDetector(
              onTap: () => function(),
              child: Container(
                  color: colorScheme.primary,
                  child: Padding(
                    padding: getPadding(
                        top: defaultPadding,
                        bottom: defaultPadding,
                        left: defaultPadding * 1.5,
                        right: defaultPadding * 1.5),
                    child: Center(
                      child: Text(
                        action,
                        style: textTheme.titleSmall
                            ?.copyWith(color: colorScheme.surface),
                      ),
                    ),
                  )),
            )
        ],
      ),
    );
  }
}
