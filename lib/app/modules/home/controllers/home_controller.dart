import 'package:get/get.dart';

import '../models/crud_model.dart';
import '../repositories/home_repository.dart';

class HomeController extends GetxController {
  final RxBool _isReady = false.obs;
  final RxList<CrudModel<String>> _models = <CrudModel<String>>[].obs;

  /// ถ้าพร้อมแล้ว จะเป็น true
  bool get isReady => _isReady.value;

  @override
  void onInit() {
    super.onInit();
    _loadModelsOnInit();
  }

  /// โหลดข้อมูลเริ่มต้น
  void _loadModelsOnInit() async {
    final data = await Get.find<HomeRepository>().read();
    for (final item in data) {
      _models.add(CrudModel(item));
    }

    _isReady.value = true;
  }

  /// สร้าง
  Future<CrudSubmissionResponse> createItem(String data) async {
    final created = CrudModel(data);
    final text = created.toString();

    if (text.isEmpty) {
      throw CrudSubmissionErrorResponseException('Data is empty');
    } else if (text.length > 24) {
      throw CrudSubmissionErrorResponseException('Data can only be no more than 24 characters');
    } else if (RegExp('[^0-9A-Za-z ]').hasMatch(text)) {
      throw CrudSubmissionErrorResponseException('Data can only be A-Z, a-z, 0-9 and space.');
    }

    final list = [..._models, created];
    final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());

    if (!success) {
      return CrudSubmissionResponse(success: false, data: null);
    }

    _models.value = list;
    return CrudSubmissionResponse(success: true, data: null);
  }

  /// อ่าน
  CrudModel<String> readItem(int index) => _models[index];

  /// แก้ไข
  Future<CrudSubmissionResponse> updateItem(int index, String data) async {
    if (index >= 0 && index < _models.length && _models[index].data != data) {
      final text = data.toString();

      if (text.isEmpty) {
        throw CrudSubmissionErrorResponseException('Data is empty');
      } else if (text.length > 24) {
        throw CrudSubmissionErrorResponseException('Data can only be no more than 24 characters');
      } else if (RegExp('[^0-9A-Za-z ]').hasMatch(text)) {
        throw CrudSubmissionErrorResponseException('Data can only be A-Z, a-z, 0-9 and space.');
      }

      final list = _models.toList()
        ..removeAt(index)
        ..insert(index, _models[index].copyWith(data));

      final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());

      if (!success) {
        return CrudSubmissionResponse(success: false, data: null);
      }

      _models.value = list;
      return CrudSubmissionResponse(success: true, data: null);
    }

    throw RangeError('Out of range: $index');
  }

  /// ลบ
  Future<CrudSubmissionResponse> deleteItem(int index) async {
    if (index >= 0 && index < _models.length) {
      final list = _models.toList()..removeAt(index);

      final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());
      if (!success) {
        return CrudSubmissionResponse(success: false, data: null);
      }

      _models.value = list;
      return CrudSubmissionResponse(success: true, data: null);
    }

    throw RangeError('Out of range: $index');
  }

  int getLength() => _models.length;
}
