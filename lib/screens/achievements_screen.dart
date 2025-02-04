import 'dart:async';
import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../widgets/add_entry_bottom_sheet.dart';
import '../utils/app_colors.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  final List<Entry> _entries = [];
  DateTime? _highlightedDate;

  Future? _bottomSheetFuture;
  Timer? _highlightTimer;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _onDayPressed(DateTime date) {
    if (_bottomSheetFuture != null) return;

    setState(() {
      _selectedDate = date;
      _highlightedDate = date;
    });
    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _highlightedDate = null;
        });
      }
    });

    _bottomSheetFuture = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(211, 233, 222, 245),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEntryBottomSheet(
          selectedDate: _selectedDate,
          onEntryAdded: (entry) {
            if (mounted) {
              setState(() {
                _entries.add(entry);
              });
            }
          },
        ),
      ),
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _bottomSheetFuture = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AppBar(
              centerTitle: false, 
              title: const Align(
                alignment: Alignment.centerRight, 
                child: Text(
                  'الإنجازات و الامتنان',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              backgroundColor: AppColors.accent,
              elevation: 2,
              iconTheme: const IconThemeData(color: AppColors.secondary),
            ),
            Positioned(
              bottom: -60,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final int day = index + 1;
                    final bool isToday = (now.day == day) &&
                        (now.month == _selectedDate.month) &&
                        (now.year == _selectedDate.year);

                    final bool isHighlighted = _highlightedDate != null &&
                        (_highlightedDate!.day == day) &&
                        (_highlightedDate!.month == _selectedDate.month) &&
                        (_highlightedDate!.year == _selectedDate.year);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            _onDayPressed(DateTime(_selectedDate.year, _selectedDate.month, day));
                          },
                          splashColor: Colors.black.withOpacity(0.5), 
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                opacity: isHighlighted ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  width: 90, 
                                  height: 130, 
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: isToday ? AppColors.accent : AppColors.lightGray,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isToday
                                      ? Border.all(color: AppColors.secondary, width: 2)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  day.toString(),
                                  style: TextStyle(
                                    fontSize: isToday ? 18 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: isToday ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50), 
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.accent,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.accent,
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'الإنجازات'),
              Tab(text: 'الامتنان'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEntryList(_entries),
                _buildEntryList(_entries.where((entry) => entry.type == EntryType.achievement).toList()),
                _buildEntryList(_entries.where((entry) => entry.type == EntryType.gratitude).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryList(List<Entry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'ليس هناك إضافات بعد\nاختر يوماً لإضافة إنجاز أو امتنان',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      );
    }
    return  ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              title: Text(
                entry.text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.type == EntryType.achievement ? 'إنجاز' : 'امتنان',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'تم',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              trailing: Text(
                '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
  
