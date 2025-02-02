import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../widgets/add_entry_bottom_sheet.dart';
import '../utils/app_colors.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
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
      isScrollControlled: true, // يسمح للـ bottom sheet بالتكيف مع ارتفاع الكيبورد
      backgroundColor: const Color.fromARGB(211, 233, 222, 245),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        // إضافة Padding للأسفل بناءً على ارتفاع الكيبورد
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddEntryBottomSheet(
          selectedDate: _selectedDate,
          onEntryAdded: (entry) {
            setState(() {
              _entries.add(entry);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AppBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'الإنجازات و الامتنان',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ],
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
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    return GestureDetector(
                      onTap: () => _onDayPressed(
                        DateTime(DateTime.now().year, DateTime.now().month, day),
                      ),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
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
      // إزالة الـ SingleChildScrollView والتعامل مع التمرير باستخدام Expanded و ListView
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _entries.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'ليس هناك إضافات بعد\nاختر يوماً لإضافة إنجاز أو امتنان',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: _entries.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return Container(
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
                                      color: AppColors.accent),
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
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
