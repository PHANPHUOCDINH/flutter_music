import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../source.dart';

typedef Future<List<T>> DataRequester<T>(int limit, int offset);
typedef Future<List<T>> InitRequester<T>(int limit);
typedef Widget ItemBuilder<T>(
  List<T> data,
  BuildContext context,
  int index,
);

class WidgetLoadMore<T> extends StatefulWidget {
  WidgetLoadMore({
    Key key,
    @required this.itemBuilder,
    @required this.dataRequester,
    @required this.initRequester,
    this.header,
    this.styleError,
    this.colorRefresh,
    this.isSingleWrap = false,
    this.widgetError,
    this.axis,
    this.spaceBetweenWidget,
    this.padding,
    this.limit,
    this.autoLoadMore = false,
    this.loadMore,
  })  : assert(itemBuilder != null),
        assert(dataRequester != null),
        assert(initRequester != null),
        super(key: key);

  final Widget header;
  final Widget loadMore;
  final TextStyle styleError;
  final ItemBuilder itemBuilder;
  final DataRequester dataRequester;
  final InitRequester initRequester;
  final Color colorRefresh;
  final Widget widgetError;
  final bool isSingleWrap;
  final double spaceBetweenWidget;
  final EdgeInsets padding;
  final Axis axis;
  final int limit;
  final bool autoLoadMore;

  @override
  State createState() => new WidgetLoadMoreState<T>();
}

class WidgetLoadMoreState<T> extends State<WidgetLoadMore> {
  ScrollController _controller = new ScrollController();
  Color _colorRefresh;
  Axis _axis;

  List<Widget> _children = [];
  List<T> _dataList;

  bool _isRequest = false;
  bool _isEmpty = false;

  @override
  void initState() {
    super.initState();
    this._onRefresh();

    _axis = widget.axis ?? Axis.horizontal;
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          widget.autoLoadMore) _loadMore();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _colorRefresh = widget.colorRefresh ?? Theme.of(context).primaryColor;
    _children = _dataList
        ?.map(
          (e) => widget.itemBuilder(
            _dataList,
            context,
            _dataList.indexOf(e),
          ),
        )
        ?.toList();

    return this._dataList == null
        ? _loadingProcess()
        : RefreshIndicator(
            color: _colorRefresh,
            onRefresh: _onRefresh,
            child: this._dataList.length > 0
                ? !widget.isSingleWrap
                    ? ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: _axis,
                        itemCount: _dataList.length + 1,
                        separatorBuilder: (context, index) => Container(
                          height: _axis == Axis.horizontal
                              ? 0
                              : widget.spaceBetweenWidget ?? 10,
                          width: _axis == Axis.horizontal
                              ? widget.spaceBetweenWidget ?? 10
                              : 0,
                        ),
                        itemBuilder: (context, index) {
                          if (index == _dataList.length) {
                            return opacityProcess(_isRequest);
                          } else {
                            return widget.itemBuilder(
                                _dataList, context, index);
                          }
                        },
                        controller: _controller,
                        padding: widget.padding ?? EdgeInsets.all(0),
                      )
                    : SingleChildScrollView(
                        controller: _controller,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: _axis,
                        padding: widget.padding ?? EdgeInsets.zero,
                        child: Column(
                          children: [
                            Wrap(
                              children: <Widget>[
                                        widget.header ?? SizedBox(),
                                      ] +
                                      _children ??
                                  <Widget>[] +
                                      <Widget>[
                                        opacityProcess(_isRequest),
                                      ],
                            ),
                            if (widget.loadMore != null && !_isEmpty)
                              _isRequest
                                  ? WidgetCircleProgress()
                                  : GestureDetector(
                                      onTap: _loadMore,
                                      child: widget.loadMore,
                                    ),
                          ],
                        ),
                      )
                : Stack(
                    children: [
                      SingleChildScrollView(scrollDirection: _axis),
                      Center(
                        child: widget.widgetError ??
                            Text(
                              "Không có dữ liệu",
                              style:
                                  widget.styleError ?? AppStyles.DEFAULT_MEDIUM,
                            ),
                      ),
                    ],
                  ),
          );
  }

  Widget _loadingProcess() {
    return WidgetShimmer(
      child: SingleChildScrollView(
        controller: _controller,
        padding: widget.padding ?? EdgeInsets.zero,
        child: Wrap(
          children: List.generate(
            2,
            (index) => widget.itemBuilder(
              List.generate(2, (index) => null),
              context,
              index,
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    if (mounted) this.setState(() => this._dataList = null);
    List initDataList = await widget.initRequester(widget.limit);
    if (mounted) this.setState(() => this._dataList = initDataList);
    return;
  }

  _loadMore() async {
    if (mounted) {
      this.setState(() => _isRequest = true);
      int currentSize = 0;

      if (_dataList != null) currentSize = _dataList.length;
      List<T> newDataList =
          await widget.dataRequester(widget.limit, currentSize);

      if (newDataList != null && newDataList.length > 0) {
        if (_dataList == null) _dataList = [];
        _dataList.addAll(newDataList);
      } else {
        _isEmpty = true;
      }

      if (mounted) this.setState(() => _isRequest = false);
    }
  }

  Widget opacityProcess(isRequest) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: Opacity(
          opacity: isRequest ? 1.0 : 0.0,
          child: WidgetCircleProgress(),
        ),
      ),
    );
  }
}
