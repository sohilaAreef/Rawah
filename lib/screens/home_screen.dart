import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rawah/utils/app_colors.dart';
import '../screens/achievements_screen.dart';
import '../screens/selected_values_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, this.initialIndex = 2}); 

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
    final List<Widget> _screens = [
      const AchievementsScreen(),
      const SelectedValuesScreen(),
      const Center(child: Text('الرئيسية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    ];
 
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        color: Colors.white,
        backgroundColor: AppColors.accent,
        items: <Widget>[
          Icon(
            Icons.emoji_events,
            size: 30,
            color: _selectedIndex == 0 ? AppColors.accent : Colors.grey,
          ),
          Icon(
            Icons.format_quote,
            size: 30,
            color: _selectedIndex == 1 ? AppColors.accent : Colors.grey,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 2 ? AppColors.accent : Colors.grey,
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
