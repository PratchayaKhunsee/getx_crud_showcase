part of '../home_view.dart';

/// ไดอะล็อกแก้ไขรายการ CRUD
class CrudDeletingDialog extends StatefulWidget {
  final int index;
  const CrudDeletingDialog({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => CrudDeletingDialogState();
}

/// [State] ของ [CrudDeletingDialog]
class CrudDeletingDialogState extends State<CrudDeletingDialog> {
  HomeController get controller => Get.find<HomeController>();

  @override
  void initState() {
    controller.initCrudDeletingDialog();
    super.initState();
  }

  @override
  void dispose() {
    controller.disposeCrudDeletingDialog();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
        canPop: controller.getPopStateOfCrudDeletingDialog(),
        child: AlertDialog(
          title: const Text('Delete?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure to delete this item?'),
              Text(controller.getErrorMessageOfCrudDeletingDialog(), maxLines: 1, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: controller.getPopStateOfCrudDeletingDialog() ? () => Get.until((route) => route.isFirst) : null,
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: controller.getPopStateOfCrudDeletingDialog() ? () => _onDeleteConfirmButtonPressed() : null,
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        )));
  }

  void _onDeleteConfirmButtonPressed() => controller.deleteItem(widget.index);
}
