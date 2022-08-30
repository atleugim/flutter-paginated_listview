import 'package:example/widgets/loading_overlay.dart';
import 'package:example/widgets/paginated_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paginated Listview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingOverlay(
        child: PaginatedExample(),
      ),
    );
  }
}
