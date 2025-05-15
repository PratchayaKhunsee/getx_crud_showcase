part of '../home_controller.dart';

mixin CrudUpdatingDialogMixin on GetxController {
  late FocusNode _uFNode;
  late TextEditingController _uTxtCtrl;
  late RxBool _uPopState;
  late RxString _uErrMsg;
  Object? _uInstanceToken;

  /// เตรียมพร้อมก่อนเริ่มต้นเปิดไดอะล็อกแก้ไข CRUD
  void initCrudUpdatingDialog({required String initialText}) {
    final token = _uInstanceToken = Object();
    final focusNode = _uFNode = FocusNode();
    final txt = _uTxtCtrl = TextEditingController()..addListener(_onCrudUpdatingDialogTextBoxChanged);
    _uPopState = true.obs;
    _uErrMsg = ''.obs;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.context?.mounted == true) focusNode.requestFocus();
      if (token == _uInstanceToken) txt.value = TextEditingValue(text: initialText);
    });
  }

  /// เตรียมพร้อมหลังจากปิดไดอะล็อกแก้ไข CRUD
  void disposeCrudUpdatingDialog() {
    _uFNode.dispose();
    _uTxtCtrl.dispose();
    _uPopState.close();
    _uErrMsg.close();
  }

  bool getPopStateOfCrudUpdatingDialog() => _uPopState.value;
  void setPopStateOfCrudUpdatingDialog(bool value) => _uPopState.value = value;
  String getErrorMessageOfCrudUpdatingDialog() => _uErrMsg.value;
  void setErrorMessageOfCrudUpdatingDialog(String value) => _uErrMsg.value = value;
  TextEditingController getTextEditingControllerOfCrudUpdatingDialog() => _uTxtCtrl;
  FocusNode getFocusNodeOfCrudUpdatingDialog() => _uFNode;

  void _onCrudUpdatingDialogTextBoxChanged() {
    if (_uTxtCtrl.text.isNotEmpty) {
      _uErrMsg.value = '';
    }
  }
}
