import 'package:toptalents/pages/settings/reset_password.dart';
import 'package:toptalents/pages/settings/settings.dart';
import 'package:toptalents/pages/courses/add_course_screen.dart';
import 'package:toptalents/pages/courses/course_screen.dart';

import 'package:toptalents/pages/home/home_screen.dart';
import 'package:toptalents/pages/invoice/add_invoice_screen.dart';
import 'package:toptalents/pages/invoice/invoice_screen.dart';
import 'package:toptalents/pages/profile/profile_screen.dart';
import 'package:toptalents/pages/staff/add_staff_screen.dart';
import 'package:toptalents/pages/staff/staff_details_screen.dart';
import 'package:toptalents/pages/staff/staff_screen.dart';
import 'package:toptalents/pages/vendor/add_vendror_screen.dart';
import 'package:toptalents/pages/vendor/vendor_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String homeScreen = '/home_screen';
  static const String staffScreen = '/staff_screen';
  static const String addStaffScreen = '/add_staff_screen';
  static const String staffDetailsScreen = '/staff_details_screen';

  static const String vendorScreen = '/vendor_screen';
  static const String addVendorScreen = '/add_vendor_screen';

  static const String courseScreen = '/course_screen';
  static const String addCourseScreen = '/add_course_screen';
  static const String courseDetailsScreen = '/course_details_screen';

  static const String invoiceScreen = '/invoice_screen';
  static const String addInvoiceScreen = '/add_invoice_screen';
  static const String invoiceItem = '/invoice_item';

  static const String profileScreen = '/profile_screen';

  static const String settingsScreen = '/settings_screen';
  static const String resetPasswordScreen = '/reset_password_screen';

  static String initialRoute = '/';
  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: staffScreen,
      page: () => const StaffScreen(),
    ),
    GetPage(
      name: addStaffScreen,
      page: () => AddStaffScreen(),
    ),
    GetPage(
      name: staffDetailsScreen,
      page: () => const StaffDetailsScreen(
        docId: '',
      ),
    ),
    GetPage(
      name: vendorScreen,
      page: () => const VendorsScreen(),
    ),
    GetPage(
      name: addVendorScreen,
      page: () => const AddVendorScreen(),
    ),
    GetPage(
      name: courseScreen,
      page: () => CourseScreen(),
    ),
    GetPage(
      name: addCourseScreen,
      page: () => AddCourseScreen(),
    ),
    GetPage(
      name: invoiceScreen,
      page: () => InvoiceScreen(),
    ),
    GetPage(
      name: addInvoiceScreen,
      page: () => const AddInvoiceScreen(),
    ),
    GetPage(
      name: profileScreen,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: settingsScreen,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => ResetPasswordPage(),
    ),
  ];
}
