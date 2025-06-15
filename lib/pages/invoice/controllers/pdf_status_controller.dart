import 'package:get/get.dart';

class PdfStatusController extends GetxController {
  var isSent = false.obs;
  var isSharing = false.obs;

  void startSharing() {
    isSharing.value = true;
  }

  void stopSharing() {
    isSharing.value = false;
  }

  void markAsSent() {
    isSent.value = true;
    isSharing.value = false;
  }

  void markAsNotSent() {
    isSent.value = false;
    isSharing.value = false;
  }

  void resetStatus() {
    isSent.value = false;
    isSharing.value = false;
  }
}
