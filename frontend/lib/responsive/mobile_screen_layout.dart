import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../screens/camera_module/camera_screen.dart';
import '../screens/chat_screen.dart';
import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  final TabController? tabController;
  const MobileScreenLayout({super.key, this.tabController});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: TabBarView(
          controller: widget.tabController,
          children: [
            const CameraScreen(),
            Scaffold(
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: onPageChanged,
                children: homeScreenItems,
              ),
              bottomNavigationBar: CupertinoTabBar(
                  backgroundColor: mobileBackgroundColor,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home,
                            color: _page == 0 ? primaryColor : secondaryColor),
                        label: '',
                        backgroundColor: primaryColor),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search,
                            color: _page == 1 ? primaryColor : secondaryColor),
                        label: '',
                        backgroundColor: primaryColor),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outlined,
                            color: _page == 2 ? primaryColor : secondaryColor),
                        label: '',
                        backgroundColor: primaryColor),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.play_circle_outline_sharp,
                            color: _page == 3 ? primaryColor : secondaryColor),
                        label: '',
                        backgroundColor: primaryColor),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person,
                            color: _page == 4 ? primaryColor : secondaryColor),
                        label: '',
                        backgroundColor: primaryColor),
                  ],
                  onTap: navigationTapped),
            ),
            const ChatScreen(),
          ],
        ),
      ),
    );
  }
}
