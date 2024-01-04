import 'package:flutter/material.dart';
import 'package:live_video_commerce/ui/page/live/live_section_page.dart';
import 'package:live_video_commerce/ui/page/user/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  final List<Widget> _pages = const [
    LiveSectionPage(),
    UserPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _pageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.satellite_alt_rounded),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: '我的',
          ),
        ],
        onDestinationSelected: (int index) {
          _pageIndex = index % _pages.length;
          setState(() {});
        },
      ),
    );
  }
}