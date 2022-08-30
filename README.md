# paginated_listview

![Pub Version](https://img.shields.io/pub/v/paginated_listview?color=light-green)

A simple ListView to handle pagination to your API queries or whatever you want to do :)

## Usage with Flutter Apps

```Dart
class ExampleItem extends StatelessWidget {
  const ExampleItem({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}


class PaginatedExample extends StatelessWidget {
  const PaginatedExample({Key? key}) : super(key: key);

  List<String> _generateList(int page, {int length = 10}) {
    if (page > 5) {
      return [];
    }

    return List.generate(length, (i) => 'Page: $page | Item: ${i + 1}');
  }

  Future<List<String>> _onFetch(int p) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate fetching
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
```

## The parameters

```Dart
/// [T] defines the type of data of the list
const PaginatedListView<T>()


/// Run the request with the current page as a parameter
final Future<List<T>> Function(int) onFetch;

/// The Widget to be built in the list view
/// this function return an item of type [T] to receive in your own [Widgets]
final Function(T) itemBuilder;

/// Optional, Initial list of data to be shown, default is []
final List<T> initialData;

/// Optional, should shirdWrap the list?
final bool shrinkWrap;

/// Optional, the [Widget] to be built as separator
final Widget? separator;

/// Optional, so you can handle when fetching start
final void Function()? onLoadStart;

/// Optional, so you can handle when fetching end
final void Function()? onLoadEnd;

/// Optional, set padding of the listview
final EdgeInsetsGeometry? padding;

/// Optional, set scroll physics of the listview
final ScrollPhysics? physics;
```
