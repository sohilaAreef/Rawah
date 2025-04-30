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

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  // نحتفظ باليوم الحالي في _selectedDate
  DateTime _selectedDate = DateTime.now();
  final List<Entry> _entries = [];
  DateTime? _highlightedDate;

  Future? _bottomSheetFuture;
  Timer? _highlightTimer;

  late TabController _tabController;
  late ScrollController _scrollController;
  final int numberOfCards = 30;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCurrentDay();
    });
  }

  // دالة لتحريك قائمة الأيام بحيث يكون اليوم الحالي (الموجود في _selectedDate) في المنتصف
  void _centerCurrentDay() {
    if (!_scrollController.hasClients) return;
    int currentDay = _selectedDate.day; // اليوم الحالي
    int currentIndex = currentDay - 1; // نفترض أن اليوم 1 بالفهرس 0
    double itemWidth = 88;
    double screenWidth = MediaQuery.of(context).size.width;
    double offset = currentIndex * itemWidth - (screenWidth / 2) + (itemWidth / 2);
    if (offset < 0) offset = 0;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // عند الضغط على يوم، لا نقوم بتغيير _selectedDate (اليوم الحالي) بل نستخدم التاريخ المضغوط للـ BottomSheet
  void _onDayPressed(DateTime date) {
    if (_bottomSheetFuture != null) return;

    setState(() {
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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEntryBottomSheet(
          selectedDate: date, // إرسال التاريخ المضغوط للـ BottomSheet
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
    _scrollController.dispose();
    super.dispose();
  }

  // بناء قائمة الأيام بحيث يتم عرض جميع الأيام المُختارة
  Widget _buildDaysList() {
    int totalDaysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    int currentDay = _selectedDate.day;
    int startDay = currentDay - (numberOfCards ~/ 2);
    if (startDay < 1) startDay = 1;
    if (startDay + numberOfCards - 1 > totalDaysInMonth) {
      startDay = totalDaysInMonth - numberOfCards + 1;
      if (startDay < 1) startDay = 1;
    }
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: numberOfCards,
      itemBuilder: (context, index) {
        final int day = startDay + index;
        final bool isToday = (day == _selectedDate.day) &&
            (_selectedDate.month == DateTime.now().month) &&
            (_selectedDate.year == DateTime.now().year);
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
                _centerCurrentDay();
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
    );
  }

  // بناء قائمة الإدخالات (الإنجازات أو الامتنان)
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
    return ListView.builder(
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
                child: _buildDaysList(),
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
                _buildEntryList(
                    _entries.where((entry) => entry.type == EntryType.achievement).toList()),
                _buildEntryList(
                    _entries.where((entry) => entry.type == EntryType.gratitude).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}