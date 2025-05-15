part of '../home_controller.dart';

mixin CrudCreatingDialogMixin on GetxController {
  late FocusNode _cFNode;
  late TextEditingController _cTxtCtrl;
  late RxBool _cPopState;
  late RxString _cErrMsg;

  /// เตรียมพร้อมก่อนเริ่มต้นเปิดไดอะล็อกสร้าง CRUD
  void initCrudCreatingDialog() {
    final focusNode = _cFNode = FocusNode();
    _cTxtCtrl = TextEditingController()..addListener(_onCrudCreatingDialogTextBoxChanged);
    _cPopState = true.obs;
    _cErrMsg = ''.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.context?.mounted == true) focusNode.requestFocus();
    });
  }

  /// เตรียมพร้อมหลังจากปิดไดอะล็อกสร้าง CRUD
  void disposeCrudCreatingDialog() {
    _cFNode.dispose();
    _cTxtCtrl.dispose();
    _cPopState.close();
    _cErrMsg.close();
  }

  bool getPopStateOfCrudCreatingDialog() => _cPopState.value;
  void setPopStateOfCrudCreatingDialog(bool value) => _cPopState.value = value;
  String getErrorMessageOfCrudCreatingDialog() => _cErrMsg.value;
  void setErrorMessageOfCrudCreatingDialog(String value) => _cErrMsg.value = value;
  TextEditingController getTextEditingControllerOfCrudCreatingDialog() => _cTxtCtrl;
  FocusNode getFocusNodeOfCrudCreatingDialog() => _cFNode;

  void _onCrudCreatingDialogTextBoxChanged() {
    if (_cTxtCtrl.text.isNotEmpty) {
      _cErrMsg.value = '';
    }
  }
}
