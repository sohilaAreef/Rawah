import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
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
    AchievementsScreen(),
    SelectedValuesScreen(),
    Center(child: Text('الرئيسية')),
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
      bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60,
          color: Colors.white,
          backgroundColor: AppColors.accent,
          items: <Widget>[
            Icon(Icons.emoji_events,
                size: 30,
                color: _selectedIndex == 0 ? AppColors.accent : Colors.grey),

              Icon(Icons.format_quote,
              size: 30,
              color: _selectedIndex == 1 ? AppColors.accent : Colors.grey,),

              Icon(Icons.home, size: 30, color: _selectedIndex == 2 ? AppColors.accent : Colors.grey,),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          } ),
          );
  }
}
