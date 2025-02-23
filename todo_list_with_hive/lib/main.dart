import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_with_hive/ui/screens/todos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory docDir = await getApplicationCacheDirectory();
  Hive.init(docDir.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const TodosScreen(),
    );
  }
}
