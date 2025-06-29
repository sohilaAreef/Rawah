import 'package:flutter/material.dart';
import 'package:rawah/screens/chat_screen.dart';
import 'package:rawah/screens/emotions_home_screen.dart';
import 'package:rawah/screens/goal_screen.dart';
import 'package:rawah/screens/main_home_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import '../screens/achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 4});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ChatScreen(),
      const AchievementsScreen(),
      const EmotionsHomeScreen(),
      const GoalsScreen(),
      const MainHomeScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        height:
            kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'الدردشة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: 'الإنجازات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_emotions),
                label: 'المشاعر',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag_circle_outlined),
                label: 'الأهداف',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
