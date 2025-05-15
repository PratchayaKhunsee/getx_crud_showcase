part of '../home_view.dart';

/// ไดอะล็อกสร้างรายการ CRUD
class CrudCreatingDialog extends StatefulWidget {
  const CrudCreatingDialog({super.key});

  @override
  State<StatefulWidget> createState() => CrudCreatingDialogState();
}

/// [State] ของ [CrudCreatingDialog]
class CrudCreatingDialogState extends State<CrudCreatingDialog> {
  HomeController get controller => Get.find<HomeController>();

  @override
  void initState() {
    controller.initCrudCreatingDialog();
    super.initState();
  }

  @override
  void dispose() {
    controller.disposeCrudCreatingDialog();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
        canPop: controller.getPopStateOfCrudCreatingDialog(),
        child: AlertDialog(
          title: const Text('Create'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.getTextEditingControllerOfCrudCreatingDialog(),
                focusNode: controller.getFocusNodeOfCrudCreatingDialog(),
                enabled: controller.getPopStateOfCrudCreatingDialog(),
              ),
              Text(controller.getErrorMessageOfCrudCreatingDialog(), maxLines: 1, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: controller.getPopStateOfCrudCreatingDialog() ? () => Get.until((route) => route.isFirst) : null,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: controller.getPopStateOfCrudCreatingDialog() ? () => _onCreateConfirmButtonPressed() : null,
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
            ),
          ],
        )));
  }

  void _onCreateConfirmButtonPressed() => controller.createItem();
}
