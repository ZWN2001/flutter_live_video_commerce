import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../utils/store_utils.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _editingController = TextEditingController();
  String lastSearchStr = '';
  List<String> _histories = [];

  // var _tabTexts = ['图书', '资讯', '用户'];
  // late TabController _tabController;

  /// 当前页面状态
  ///
  /// 0：历史页面
  /// 1：搜索页面
  int _status = 0;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: _tabTexts.length, vsync: this);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          autofocus: true,
          style: const TextStyle(fontSize: 18),
          maxLines: 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '请输入关键词',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _onSearch(_editingController.text);
                },
              )),
          onSubmitted: (str) {
            _onSearch(str);
          },
          onChanged: (str) {
            if (str != lastSearchStr || lastSearchStr == '' || str == '') {
              setState(() {
                _status = 0;
              });
            }
          },
        ),
        elevation: 0,
      ),
      body: _buildPage(),
    );
  }

  @override
  void dispose() {
    // _tabController.dispose();
    _editingController.dispose();
    super.dispose();
  }

  void _onSearch(String str) {
    lastSearchStr = str;
    _addToHistory(str);
    _doSearch(str);
  }

  void _loadHistory() {
    _histories =
        jsonDecode(Store.getString('search_history', def: '[]')).cast<String>();
  }

  void _addToHistory(value) async {
    if (value == '') {
      return;
    }
    if (_histories.contains(value)) {
      _histories.remove(value);
      _histories.insert(0, value);
    } else {
      _histories.insert(0, value);
    }
//    if (_histories.length > 20) {
//      _histories = _histories.sublist(0, 20);
//    }
    await Store.set('search_history', jsonEncode(_histories));
    setState(() {});
  }

  void _removeFromHistory(String value) async {
    _histories.remove(value);
    await Store.set('search_history', jsonEncode(_histories));
    setState(() {});
  }

  void _removeAllHistories() async {
    await Store.remove('search_history');
    _loadHistory();
    setState(() {
      _histories.clear();
    });
  }

  void _doSearch(str) {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _editingController.text = str;
      if (str == '') {
        _status = 0;
      } else {
        _status = 1;
      }
    });
  }

  Widget _buildPage() {
    if (_status == 0) {
      return _buildHistoryWidget();
    } else {
      return _buildResultWidget();
    }
  }

  Widget _buildHistoryWidget() {
    // var scheme = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: const Text(
                  '搜索历史',
                  style: TextStyle(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              _histories.isEmpty
                  ? Container()
                  : RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                onPressed: () {
                  _removeAllHistories();
                },
                child: Text(
                  '清除历史记录',
                  style: TextStyle(color: Get.theme.colorScheme.primary),
                ),
              )
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _histories.isEmpty
                ? [
              Text(
                '还没有搜索历史',
                style: TextStyle(color: Get.theme.disabledColor),
              )
            ]
                : _histories
                .map((str) => Chip(
              side: BorderSide.none,
              shape: const StadiumBorder(),
              // backgroundColor: context.colors.primary,
              label: GestureDetector(
                child: Text(
                  str,
                  style: const TextStyle(
                      fontSize: 12,),
                ),
                onTap: () {
                  _addToHistory(str);
                  _onSearch(str);
                },
              ),
              deleteIcon: Icon(
                Icons.cancel_rounded,
                size: 15,
                color: Get.theme.colorScheme.onPrimary,
              ),
              onDeleted: () {
                _removeFromHistory(str);
              },
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultWidget() {
    return Scaffold(
      // appBar: _buildTabBar(),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: <Widget>[
      //     SearchResultPage(
      //       onSearch: LibraryAPI.doSearch,
      //       keyword: _editingController.text,
      //     ),
      //     SearchResultPage(
      //       onSearch: NewsAPI.doSearch,
      //       keyword: _editingController.text,
      //     ),
      //     SearchResultPage(
      //       onSearch: UserAPI.doSearch,
      //       keyword: _editingController.text,
      //     ),
      //   ],
      // ),
      body: Container(),
    );
  }

}

class SearchResultPage extends StatefulWidget {
  final String keyword;
  final Future<List> Function(CancelToken cancelToken, String key,
      {int page, int pageSize}) onSearch;

  const SearchResultPage({super.key, required this.keyword, required this.onSearch});

  @override
  State createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResultPage>
    with AutomaticKeepAliveClientMixin {
  final CancelToken _cancelToken = CancelToken();
  int page = 1;
  bool loading = true;
  List searchResult = [];
  final RefreshController _refreshController = RefreshController();

  final Widget _loadingWidget = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    _doSearch();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return _loadingWidget;
    } else {
      return buildBody();
    }
  }

  Widget buildBody() {
    if (searchResult.isEmpty) {
      return Center(
        child: Text(
          '未搜索到结果',
          style: TextStyle(color: Get.theme.disabledColor),
        ),
      );
    } else {
      return SmartRefresher(
        controller: _refreshController,
        onLoading: () => _doSearch(),
        enablePullUp: true,
        footer: const ClassicFooter(
          idleText: '上拉加载更多',
          loadingText: '正在加载...',
          noDataText: '没有更多数据了',
          canLoadingText: '释放加载更多',
        ),
        enablePullDown: false,
        child: ListView.builder(
          itemBuilder: (context, index) {
            // if (searchResult[0].runtimeType == SearchBook) {
            //   return InkWell(
            //     child: BookItemCard(Book.fromSearchBook(searchResult[index])),
            //     onTap: () {
            //       Get.to(() => BookInfoPage(searchResult[index]));
            //     },
            //   );
            // } else if (searchResult[0].runtimeType == News) {
            //   return NewsItemCard(searchResult[index]);
            // } else {
              return Container();
            // }
          },
          itemCount: searchResult.length,
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _doSearch() async {
    List list =
    await widget.onSearch(_cancelToken, widget.keyword, page: page++);
    if (list.isEmpty) {
      _refreshController.loadNoData();
    } else {
      searchResult.addAll(list);
      _refreshController.loadComplete();
    }
    if (mounted) {
      loading = false;
      setState(() {});
    }
  }
}
