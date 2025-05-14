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
  /// ตัวควบคุม [ExpansionTile]
  final Map<CrudModel<String>, ExpansionTileController> _expansionTileControllers = {};

  /// ต้องมี widget key สำหรับ [ExpansionTile] ด้วย เนื่องจากเวลาลบรายการ มีบั๊คที่ทำให้รายการถถัดไปจากรายการที่ลบ
  /// จะแสดง UI เปิดแท็บอยู่ ต้องระบุ key ให้สอดคล้องกับรายการ CRUD
  final _expansionTileKeys = <CrudModel<String>, GlobalKey>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _expansionTileControllers.clear();
    _expansionTileKeys.clear();
    super.dispose();
  }

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
          final expansionTileController = _expansionTileControllers[d] ??= ExpansionTileController();

          return ExpansionTile(
            key: _expansionTileKeys[d] ??= GlobalKey(),
            controller: expansionTileController,
            onExpansionChanged: (expanded) {
              if (expanded) {
                for (final c in _expansionTileControllers.values) {
                  if (c != expansionTileController) {
                    c.collapse();
                  }
                }
              }
            },
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
                            builder: (context) => CrudUpdatingDialog(
                              index: index,
                              onUpdate: () {
                                _removeExpansionTilesWhenUpdated(d);
                              },
                            ),
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
                          builder: (context) => CrudDeletingDialog(
                            index: index,
                            onDelete: () {
                              _removeExpansionTilesWhenUpdated(d);
                            },
                          ),
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

  /// จะต้องลบ [_expansionTileKeys] และ [_expansionTileControllers]  ประจำรายการ [model] ก่อน
  /// เพื่อป้องกันการเรียกใช้ซ้ำหลังจากที่รายการไม่ได้ใช้งานแล้ว
  void _removeExpansionTilesWhenUpdated(CrudModel<String> model) {
    _expansionTileKeys.remove(model);
    _expansionTileControllers.remove(model);
  }
}
