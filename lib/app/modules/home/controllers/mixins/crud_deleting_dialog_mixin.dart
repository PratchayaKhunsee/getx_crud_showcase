part of '../home_controller.dart';

mixin CrudDeletingDialogMixin on GetxController {
  late RxBool _dPopState;
  late RxString _dErrMsg;

  /// เตรียมพร้อมก่อนเริ่มต้นเปิดไดอะล็อกลบ CRUD
  void initCrudDeletingDialog() {
    _dPopState = true.obs;
    _dErrMsg = ''.obs;
  }

  /// เตรียมพร้อมหลังจากปิดไดอะล็อกลบ CRUD
  void disposeCrudDeletingDialog() {
    _dPopState.close();
    _dErrMsg.close();
  }

  bool getPopStateOfCrudDeletingDialog() => _dPopState.value;
  void setPopStateOfCrudDeletingDialog(bool value) => _dPopState.value = value;
  String getErrorMessageOfCrudDeletingDialog() => _dErrMsg.value;
  void setErrorMessageOfCrudDeletingDialog(String value) => _dErrMsg.value = value;
}
