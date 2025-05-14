import 'package:get/get.dart';

import '../../../middleware/local_storage.dart';

class HomeRepository {
  HomeRepository._instantiate();

  factory HomeRepository() => HomeRepository._instantiate();

  /// อ่านข้อมูลจาก [LocalStorage]
  Future<List<String>> read() async {
    final data = await Get.find<LocalStorage>().get('crud_list');
    return data != null && data.isNotEmpty ? data.split(String.fromCharCode(0)) : [];
  }

  /// บันทึกข้อมูลลง [LocalStorage]
  Future<bool> write(List<String> items) async => await Get.find<LocalStorage>().set('crud_list', items.join(String.fromCharCode(0)));
}
