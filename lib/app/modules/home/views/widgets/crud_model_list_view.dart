part of '../home_view.dart';

/// วิดเจ็ตแสดงไอเท็มรายการ CRUD จากตัวแปร [crudModelListProvider]
class CrudModelListView extends StatefulWidget {
  const CrudModelListView({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CrudModelListViewState();
}

class CrudModelListViewState extends State<CrudModelListView> {
  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isReady) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.getLength() == 0) {
        return const Center(child: Text('No items'));
      }

      return ListView.builder(
        itemCount: controller.getLength(),
        itemBuilder: (context, index) {
          final d = controller.readItem(index);
          final expansionTileController = controller.getExpansionTileController(d);

          return ExpansionTile(
            key: controller.getExpansionTileKey(d),
            controller: expansionTileController,
            onExpansionChanged: (_) => controller.collapseOtherExpansionTiles(expansionTileController),
            title: Text(d.data),
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        label: const Text('Edit'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => CrudUpdatingDialog(index: index),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete'),
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => CrudDeletingDialog(index: index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
