import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/crud_model.dart';
import '../repositories/home_repository.dart';

part 'mixins/crud_model_list_mixin.dart';
part 'mixins/crud_creating_dialog_mixin.dart';
part 'mixins/crud_updating_dialog_mixin.dart';
part 'mixins/crud_deleting_dialog_mixin.dart';

class HomeController extends GetxController with CrudModelListMixin, CrudCreatingDialogMixin, CrudUpdatingDialogMixin, CrudDeletingDialogMixin {
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
  Future<void> createItem() async {
    final created = CrudModel(_cTxtCtrl.text);
    final text = created.toString();

    if (text.isEmpty) {
      _cErrMsg.value = 'Data is empty';
      _cPopState.value = true;
      return;
    } else if (text.length > 24) {
      _cErrMsg.value = 'Data can only be no more than 24 characters';
      _cPopState.value = true;
      return;
    } else if (RegExp('[^0-9A-Za-z ]').hasMatch(text)) {
      _cErrMsg.value = 'Data can only be A-Z, a-z, 0-9 and space.';
      _cPopState.value = true;
      return;
    }

    final list = [..._models, created];
    final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());

    if (!success) {
      _cErrMsg.value = 'Error, try again';
      _cPopState.value = true;
      return;
    }

    _models.value = list;
    Get.until((route) => route.isFirst);
  }

  /// อ่าน
  CrudModel<String> readItem(int index) => _models[index];

  /// แก้ไข
  Future<void> updateItem(int index) async {
    final data = _uTxtCtrl.text;
    if (index >= 0 && index < _models.length && _models[index].data != data) {
      final text = data;

      if (text.isEmpty) {
        _uErrMsg.value = 'Data is empty';
        _uPopState.value = true;
        return;
      } else if (text.length > 24) {
        _uErrMsg.value = 'Data can only be no more than 24 characters';
        _uPopState.value = true;
        return;
      } else if (RegExp('[^0-9A-Za-z ]').hasMatch(text)) {
        _uErrMsg.value = 'Data can only be A-Z, a-z, 0-9 and space.';
        _uPopState.value = true;
        return;
      }

      final target = _models[index];
      final updated = target.copyWith(data);
      final list = _models.toList()
        ..removeAt(index)
        ..insert(index, updated);

      final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());

      if (!success) {
        _uErrMsg.value = 'Error, try again';
        _uPopState.value = true;
        return;
      }

      _models.value = list;
      _removeTargetExpansionTiles(target);
      Get.until((route) => route.isFirst);
    } else {
      throw RangeError('Out of range: $index');
    }
  }

  /// ลบ
  Future<void> deleteItem(int index) async {
    if (index >= 0 && index < _models.length) {
      final list = _models.toList();
      final deleted = list.removeAt(index);

      final success = await Get.find<HomeRepository>().write(list.map((e) => e.toString()).toList());
      if (!success) {
        _dErrMsg.value = 'Error, try again';
        _dPopState.value = true;
        return;
      }

      _models.value = list;
      _removeTargetExpansionTiles(deleted);
      Get.until((route) => route.isFirst);
    } else {
      throw RangeError('Out of range: $index');
    }
  }

  int getLength() => _models.length;
}
