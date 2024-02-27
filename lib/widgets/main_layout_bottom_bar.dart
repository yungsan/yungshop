import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nguyen_manh_dung/screens/cart.dart';
import 'package:nguyen_manh_dung/screens/home.dart';
import 'package:nguyen_manh_dung/screens/message.dart';
import 'package:nguyen_manh_dung/screens/profile.dart';

class MainLayoutBottomBar extends StatefulWidget {
  const MainLayoutBottomBar({super.key});

  @override
  State<MainLayoutBottomBar> createState() => _MainLayoutBottomBarState();
}

class _MainLayoutBottomBarState extends State<MainLayoutBottomBar> {
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

  final List<IconData> _activeIcons = [
    Iconsax.home_25,
    Iconsax.shopping_bag5,
    Iconsax.heart5,
    Iconsax.message5,
    Icons.person,
  ];

  List<BottomNavigationBarItem> bottomBarItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < _inActiveIcons.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: _inActiveIcons[i],
          activeIcon: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.white,
            ),
            child: Icon(_activeIcons[i], size: 30),
          ),
          label: '$i',
        ),
      );
    }
    return items;
  }

  final List<Widget> _pages = const [
    HomePage(),
    Cart(),
    Center(child: Text('Favorite')),
    MessagePage(),
    Profile()
  ];

  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xff1f2029),
                borderRadius: BorderRadius.circular(100),
              ),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: bottomBarItems(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _currentPage,
                iconSize: 25,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                selectedFontSize: 0,
                onTap: (int index) {
                  setState(() => _currentPage = index);
                  _pageController.jumpToPage(index);
                },
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: _pages,
        ));
  }
}
