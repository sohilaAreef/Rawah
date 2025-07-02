import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/models/entry.dart';
import 'package:rawah/services/entry_service.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/utils/app_sounds.dart';
import 'package:rawah/widgets/add_entry_bottom_sheet.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EntryService _entryService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _entryService = Provider.of<EntryService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'الإنجازات والامتنان',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: AppColors.accent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'الإنجازات'),
            Tab(text: 'الامتنان'),
          ],
        ),
      ),
      body: StreamBuilder<List<Entry>>(
        stream: _entryService.getEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد إدخالات بعد',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          final entries = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildEntryList(entries),
              _buildEntryList(
                entries.where((e) => e.type == EntryType.achievement).toList(),
              ),
              _buildEntryList(
                entries.where((e) => e.type == EntryType.gratitude).toList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddEntryDialog(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildEntryList(List<Entry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Dismissible(
          key: Key(entry.id),
          background: Container(color: Colors.red),
          secondaryBackground: Container(color: Colors.blue),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              await _entryService.deleteEntry(entry.id);
              return true;
            } else {
              _showEditEntryDialog(entry);
              return false;
            }
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Card(
              color: Colors.teal[700],
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.yellow, width: 2.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                title: Text(
                  entry.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  _formatDate(entry.date),
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.right,
                ),
                leading: Icon(
                  entry.type == EntryType.achievement
                      ? Icons.emoji_events
                      : Icons.favorite,
                  color: entry.type == EntryType.achievement
                      ? Colors.amber
                      : Colors.red,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddEntryBottomSheet(
        onEntryAdded: (entry) {
          _entryService.addEntry(entry);

          AppSounds.playSubGoalComplete();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'هذا رائع! تمت إضافة ${entry.type == EntryType.achievement ? "إنجاز" : "امتنان"} 💛 جديد بنجاح  ',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              backgroundColor: AppColors.accent,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
            ),
          );
        },
      ),
    );
  }

  void _showEditEntryDialog(Entry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddEntryBottomSheet(
        entry: entry,
        onEntryAdded: (updatedEntry) => _entryService.updateEntry(updatedEntry),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
