import 'package:example/widgets/example_item.dart';
import 'package:example/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:paginated_listview/paginated_listview.dart';

class PaginatedExample extends StatelessWidget {
  const PaginatedExample({Key? key}) : super(key: key);

  List<String> _generateList(int page, {int length = 10}) {
    if (page > 5) {
      return [];
    }

    return List.generate(length, (i) => 'Page: $page | Item: ${i + 1}');
  }

  Future<List<String>> _onFetch(int p) async {
    await Future.delayed(const Duration(seconds: 2));
    return _generateList(p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Paginated Listview'),
        centerTitle: true,
      ),
      body: PaginatedListView<String>(
        onFetch: (page) async => _onFetch(page),
        initialData: _generateList(1, length: 30),
        itemBuilder: (m) => ExampleItem(message: m),
        separator: const Divider(),
        onLoadStart: () => LoadingOverlay.of(context).show(),
        onLoadEnd: () => LoadingOverlay.of(context).hide(),
      ),
    );
  }
}
