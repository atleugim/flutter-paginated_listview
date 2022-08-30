library paginated_listview;

import 'package:flutter/material.dart';

export 'paginated_listview.dart';

class InfiniteListView<T> extends StatefulWidget {
  const InfiniteListView({
    super.key,
    required this.onFetch,
    required this.itemBuilder,
    this.initialData = const [],
    this.shrinkWrap = true,
    this.separator,
    this.padding,
  });

  final Future<List<T>> Function(int) onFetch;
  final Function(T) itemBuilder;
  final List<T> initialData;
  final bool shrinkWrap;
  final Widget? separator;
  final EdgeInsetsGeometry? padding;

  @override
  State<InfiniteListView<T>> createState() => _InfiniteListViewState<T>();
}

class _InfiniteListViewState<T> extends State<InfiniteListView<T>> {
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
      final newItems = await widget.onFetch(_page + 1);
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
    return Builder(
      builder: (context) {
        return ListView.separated(
          controller: _scrollController,
          itemCount: items.length,
          shrinkWrap: true,
          padding: widget.padding,
          itemBuilder: (context, index) {
            final item = items[index];
            return widget.itemBuilder.call(item);
          },
          separatorBuilder: (context, index) {
            return widget.separator ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
