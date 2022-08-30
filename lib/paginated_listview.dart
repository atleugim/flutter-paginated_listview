library paginated_listview;

import 'package:flutter/material.dart';

export 'paginated_listview.dart';

class PaginatedListView<T> extends StatefulWidget {
  /// Creates a paginated listview builder with handling of all items
  /// and when no more items on response
  /// [T] defines the type of data of the list
  const PaginatedListView({
    super.key,
    required this.onFetch,
    required this.itemBuilder,
    this.onLoadStart,
    this.onLoadEnd,
    this.initialData = const [],
    this.shrinkWrap = true,
    this.separator,
    this.padding,
    this.physics,
  });

  /// Run the request with the current page as a parameter
  final Future<List<T>> Function(int) onFetch;

  /// The [Widget] to be built in the list view
  final Function(T) itemBuilder;

  /// Initial [List] of data to be shown
  final List<T> initialData;

  /// Initial [List] of data to be shown
  final bool shrinkWrap;

  /// The [Widget] to be built as separator
  final Widget? separator;
  final void Function()? onLoadStart;
  final void Function()? onLoadEnd;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final _scrollController = ScrollController();

  int _page = 1;
  bool _noMore = false;
  List<T> items = <T>[];

  void _addItems(List<T> newItems) {
    if (newItems.isEmpty) return;
    setState(() {
      items.addAll(newItems);
    });
  }

  void _onFetch() async {
    if (!_noMore) {
      widget.onLoadStart?.call();
      final newItems = await widget.onFetch(_page + 1);
      widget.onLoadEnd?.call();
      setState(() {
        _noMore = newItems.isEmpty;
        _page++;
      });
      _addItems(newItems);
    }
  }

  @override
  void initState() {
    _addItems(widget.initialData);

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        _onFetch();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: items.length,
      shrinkWrap: true,
      padding: widget.padding,
      physics: widget.physics,
      itemBuilder: (context, index) {
        final item = items[index];
        return widget.itemBuilder.call(item);
      },
      separatorBuilder: (context, index) {
        return widget.separator ?? const SizedBox.shrink();
      },
    );
  }
}
