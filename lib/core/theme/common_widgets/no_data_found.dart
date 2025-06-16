import 'package:flutter/material.dart';
import 'package:toptalents/constants/image_constant.dart';
import 'package:toptalents/core/utils/size_utils.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.1,
        ),
        Center(
          child: Image.asset(
            ImageConstant.no_data,
            height: height * 0.15,
            width: width * 0.25,
          ),
        ),
        const Text(
          'NO DATA FOUND',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 188, 187, 187)),
        )
      ],
    );
  }
}
