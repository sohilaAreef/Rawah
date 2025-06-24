import 'package:flutter/material.dart';
import 'package:rawah/models/entry.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Function(Entry) onEntryAdded;
  final Entry? entry;

  const AddEntryBottomSheet({
    super.key,
    required this.onEntryAdded,
    this.entry,
  });

  @override
  _AddEntryBottomSheetState createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  EntryType? _selectedType;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _selectedType = widget.entry!.type;
      _controller.text = widget.entry!.text;
    }
  }

  void _saveEntry() {
    if (_selectedType != null && _controller.text.isNotEmpty) {
      final entry = Entry(
        id: widget.entry?.id ?? '',
        type: _selectedType!,
        text: _controller.text,
        date: widget.entry?.date ?? DateTime.now(),
        isCompleted: widget.entry?.isCompleted ?? false,
      );
      widget.onEntryAdded(entry);
      Navigator.pop(context);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.teal[800],
          title: const Text(
            'ما الفرق بين الإنجاز والامتنان؟',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHelpCard(
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                  title: 'الإنجاز',
                  description:
                      'هو أي عمل أو هدف قمت بتحقيقه اليوم، مثل:\n- إنهاء مهمة صعبة\n- تحقيق هدف صغير\n- التغلب على تحدي ما\n- إكمال مشروع',
                ),
                const SizedBox(height: 20),
                _buildHelpCard(
                  icon: Icons.favorite,
                  color: Colors.red,
                  title: 'الامتنان',
                  description:
                      'هو تقديرك لشيء إيجابي في حياتك، مثل:\n- شخص ساعدك\n- لحظة جميلة مرت بك\n- نعمة تشعر بالامتنان لها\n- شيء بسيط أسعدك',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.teal[700],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.teal[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with help button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.entry == null ? 'إضافة إدخال جديد' : 'تعديل الإدخال',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 28),
                  color: Colors.white,
                  onPressed: _showHelpDialog,
                  tooltip: 'شرح المصطلحات',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Type selection
            const Text(
              'اختر نوع الإدخال:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildTypeButton(
                  EntryType.achievement,
                  'إنجاز',
                  Icons.emoji_events,
                ),
                const SizedBox(width: 10),
                _buildTypeButton(EntryType.gratitude, 'امتنان', Icons.favorite),
              ],
            ),
            const SizedBox(height: 20),

            // Text input
            const Text(
              'اكتب محتوى الإدخال:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'مثال: أنهيت مشروعي اليوم...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.teal[700],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.teal[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(EntryType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[600] : Colors.teal[700],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.teal[600]!,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _selectedType = type),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.amber : Colors.white70),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.amber : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
