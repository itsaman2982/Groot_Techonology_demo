import 'package:demoproject/screen/splash/record/controller/recorder_controller.dart';
import 'package:get/get.dart';

class RecorderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RecordController());
  }
}
