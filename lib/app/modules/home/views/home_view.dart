import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../models/crud_model.dart';

part 'widgets/crud_creating_floating_button.dart';
part 'widgets/crud_creating_dialog.dart';
part 'widgets/crud_updating_dialog.dart';
part 'widgets/crud_deleting_dialog.dart';
part 'widgets/crud_model_list_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX CRUD Showcase'), backgroundColor: Theme.of(context).colorScheme.inversePrimary, centerTitle: true),
      body: const CrudModelListView(),
      floatingActionButton: const CrudCreatingFloatingButton(),
    );
  }
}
