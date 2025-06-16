import 'package:toptalents/app_export.dart';

class GridMenuModel {
  GridMenuModel(this.image, this.menuName, this.route);
  String menuName;
  String image;
  String route;
}

List<GridMenuModel> menus = [
  GridMenuModel(ImageConstant.staff, 'Staff', AppRoutes.staffScreen),
  GridMenuModel(ImageConstant.training, 'Courses', AppRoutes.courseScreen),
  GridMenuModel(ImageConstant.vendor, 'Vendors', AppRoutes.vendorScreen),
  GridMenuModel(ImageConstant.invoice, 'Invoice', AppRoutes.invoiceScreen)
];
