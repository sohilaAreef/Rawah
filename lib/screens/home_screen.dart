import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/value_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import '../screens/achievements_screen.dart';
import '../screens/selected_values_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AchievementsScreen(), // شاشة الإنجازات
    ValuesScreen(), // شاشة القيم المختارة
    Center(child: Text('الرئيسية')), // الشاشة الرئيسية
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ValueProvider valueProvider = Provider.of<ValueProvider>(context);

    return Scaffold(
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10, left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_events,
                        color: _selectedIndex == 0
                            ? AppColors.accent
                            : Colors.grey), // أيقونة الإنجازات 🏆
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    icon: Icon(Icons.format_quote,
                        color: _selectedIndex == 1
                            ? AppColors.accent
                            : Colors.grey), // أيقونة القيم ❤️
                    onPressed: () => _onItemTapped(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        shape: CircleBorder(),
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        child: Icon(Icons.home, color: Colors.white), // أيقونة الصفحة الرئيسية 🏠
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
