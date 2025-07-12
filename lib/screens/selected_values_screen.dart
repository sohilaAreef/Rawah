import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/screens/home_screen.dart';
import 'package:rawah/screens/value_details_screen.dart';
import 'package:rawah/screens/value_screen.dart';
import 'package:rawah/utils/app_colors.dart';
import 'package:rawah/widgets/selected_value_card.dart';

class SelectedValuesScreen extends StatelessWidget {
  const SelectedValuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final valueProvider = Provider.of<ValueProvider>(context);
    final selected = valueProvider.selectedValues;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 4)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 4,
          title: const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "🌟 قيمك المختارة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          backgroundColor: AppColors.accent,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              tooltip: 'عن القيم',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text(
                      'ما هي القيم؟',
                      textAlign: TextAlign.right,
                    ),
                    content: const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'القيم هي المبادئ العميقة التي يعتنقها الإنسان وتؤثر في:\n\n'
                        '• سلوكياته (ما يفعله).\n'
                        '• مشاعره (ما يشعر به).',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('حسناً'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.goldenAccent),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ValuesScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.add, size: 20, color: Colors.white),
                    label: const Text(
                      'إضافة قيم جديدة',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ValuesScreen()),
                      );
                    },
                  ),
                  Text(
                    "عدد القيم: ${selected.length}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "✨ اضغط على أي قيمة لعرض تفاصيلها، وراجع نفسك دومًا 🌿",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: valueProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : selected.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 90,
                          color: AppColors.accent.withOpacity(0.25),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'لا توجد قيم حتى الآن!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ValuesScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'ابدأ باختيار قيمك 💫',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: selected.length,
                      itemBuilder: (context, index) {
                        final value = selected[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ValueDetailsScreen(value: value),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SelectedValueCard(
                              value: value,
                              onDelete: () => valueProvider.removeValue(value),
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
