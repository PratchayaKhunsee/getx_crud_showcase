import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'GetX CRUD Showcase',
      initialRoute: AppPages.INITIAL,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      getPages: AppPages.routes,
    ),
  );
}
