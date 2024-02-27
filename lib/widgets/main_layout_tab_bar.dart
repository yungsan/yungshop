import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nguyen_manh_dung/widgets/text.dart';
import 'package:nguyen_manh_dung/screens/home.dart';

class MainLayoutTabBar extends StatefulWidget {
  const MainLayoutTabBar({super.key});

  @override
  State<MainLayoutTabBar> createState() => _MainLayoutTabBarState();
}

class _MainLayoutTabBarState extends State<MainLayoutTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Widget> _activeIcons = const [
    CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Icon(Iconsax.home_25, size: 30, color: Color(0xff1f2029)),
    ),
    CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Icon(Iconsax.shopping_bag5, size: 30),
    ),
    CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Icon(Iconsax.heart5, size: 30),
    ),
    CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Icon(Iconsax.message5, size: 30),
    ),
    CircleAvatar(
      backgroundColor: Colors.white,
      radius: 100,
      child: Icon(Icons.person, size: 30),
    )
  ];

  final List<Widget> _inActiveIcons = const [
    Icon(
      Iconsax.home_24,
      color: Colors.grey,
    ),
    Icon(
      Iconsax.shopping_bag,
      color: Colors.grey,
    ),
    Icon(
      Iconsax.heart,
      color: Colors.grey,
    ),
    Icon(
      Iconsax.message,
      color: Colors.grey,
    ),
    Icon(
      Icons.person_outline,
      color: Colors.grey,
    ),
  ];

  List<Widget> _createTabList() {
    List<Widget> tabList = [];
    for (var i = 0; i < _tabController.length; i++) {
      tabList.add(Tab(
        icon: i == _selectedTabIndex ? _activeIcons[i] : _inActiveIcons[i],
      ));
    }
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).colorScheme.onBackground,
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            labelPadding: const EdgeInsets.all(0),
            onTap: (int index) {},
            tabs: _createTabList(),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        const HomePage(),
        Center(child: MyText(text: '${_tabController.index}')),
        Center(child: MyText(text: '${_tabController.index}')),
        Center(child: MyText(text: '${_tabController.index}')),
        Center(child: MyText(text: '${_tabController.index}')),
      ]),
    );
  }
}
