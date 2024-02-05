import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_video_commerce/api/api.dart';

import '../../../entity/result.dart';
import '../../../entity/section.dart';
import '../functions_page/search_page.dart';
import 'live_section_detail_page.dart';

class LiveSectionPage extends StatefulWidget{
  const LiveSectionPage({super.key});

  @override
  State<StatefulWidget> createState() => LiveSectionPageState();

}

class LiveSectionPageState extends State<LiveSectionPage> with SingleTickerProviderStateMixin{
  bool _loading = true;

  List<Section> _sections = [];
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  //TODO 搜索
                  Get.to(() => const SearchPage());
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: ElevationOverlay.applySurfaceTint(
                        colorScheme.background, colorScheme.surfaceTint, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Icon
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Icon(
                          Icons.search,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '板块/直播',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14),
                        ),
                      ),
                      Text(
                        '搜索     ',
                        style:
                        TextStyle(color: colorScheme.primary, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        bottom: _loading
            ? null
            : TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: _sections
              .map((section) => Tab(text: section.sectionName))
              .toList(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
    });
    ResultEntity<List<Section>> result = await LiveRoomAPI.getSections();
    if(result.success){
      _sections = result.data!;
    } else {
      _sections = [];
    }
    _tabController = TabController(length: _sections.length, vsync: this);
    _loading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }else if(_sections.isEmpty){
      return const Center(child: Text("暂无数据"));
    }else {
      return TabBarView(
        controller: _tabController,
        children: [
          ..._sections.map((e) => LiveSectionDetailPage(
            section: e,
          ))
        ],
      );
    }
  }

}