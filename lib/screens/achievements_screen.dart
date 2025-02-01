import 'package:flutter/material.dart';
import 'package:rawah/models/entry.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/add_entry_bottom_sheet.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<Entry> _entries = [];

  void _onDayPressed(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

     showModalBottomSheet(
      context: context,
      builder: (context) => AddEntryBottomSheet(
        selectedDate: _selectedDate,
        onAddEntry: (entry) {
          setState(() {
            _entries.add(entry);
          });
        },
      ),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' الإنجازات و الامتنان',
        style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primary,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30,
              itemBuilder: (context, index) {
                final day = index + 1;
                return GestureDetector(
                  onTap: () => _onDayPressed(
                    DateTime(DateTime.now().year, DateTime.now().month, day),
                  ),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.LightGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    ),
                  
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text(entry.type == EntryType.achievement? 'الإنجازات': 'الامتنان'),
                  trailing: Text(
                    '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                  ),
                );
              },
            ),)
        ],
      )
    );
  }
}