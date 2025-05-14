import 'package:get/get.dart';

import '../../../middleware/local_storage.dart';
import '../controllers/home_controller.dart';
import '../repositories/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LocalStorage>(() => LocalStorage());
    Get.lazyPut<HomeRepository>(() => HomeRepository());
  }
}
