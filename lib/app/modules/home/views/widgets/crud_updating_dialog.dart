part of '../home_view.dart';

/// ไดอะล็อกแก้ไขรายการ CRUD
class CrudUpdatingDialog extends StatefulWidget {
  final int index;
  const CrudUpdatingDialog({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => CrudUpdatingDialogState();
}

/// [State] ของ [CrudUpdatingDialog]
class CrudUpdatingDialogState extends State<CrudUpdatingDialog> {
  HomeController get controller => Get.find<HomeController>();

  @override
  void initState() {
    controller.initCrudUpdatingDialog(initialText: controller.readItem(widget.index).data.toString());

    super.initState();
  }

  @override
  void dispose() {
    controller.disposeCrudUpdatingDialog();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: controller.getPopStateOfCrudUpdatingDialog(),
          child: AlertDialog(
            title: const Text('Edit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller.getTextEditingControllerOfCrudUpdatingDialog(),
                  focusNode: controller.getFocusNodeOfCrudUpdatingDialog(),
                  enabled: controller.getPopStateOfCrudUpdatingDialog(),
                ),
                Text(controller.getErrorMessageOfCrudUpdatingDialog(), maxLines: 1, style: const TextStyle(color: Colors.red)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: controller.getPopStateOfCrudUpdatingDialog() ? () => Get.until((route) => route.isFirst) : null,
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: controller.getPopStateOfCrudUpdatingDialog() ? () => _onUpdateConfirmButtonPressed() : null,
                child: const Text('OK', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ));
  }

  void _onUpdateConfirmButtonPressed() => controller.updateItem(widget.index);
}
