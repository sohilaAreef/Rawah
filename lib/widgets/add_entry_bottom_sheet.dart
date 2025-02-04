import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../utils/app_colors.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Function(Entry) onEntryAdded;
  final DateTime selectedDate;

  const AddEntryBottomSheet({
    super.key,
    required this.onEntryAdded,
    required this.selectedDate,
  });

  @override
  _AddEntryBottomSheetState createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  EntryType? _selectedType;
  final TextEditingController _controller = TextEditingController();

  void _addEntry() {
    if (_selectedType != null && _controller.text.trim().isNotEmpty) {
      final entry = Entry(
        type: _selectedType!,
        text: _controller.text.trim(),
        date: widget.selectedDate,
      );
      widget.onEntryAdded(entry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [ 
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'أضف إنجازا أو امتنانا',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)), 
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('انجاز', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                selected: _selectedType == EntryType.achievement,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? EntryType.achievement : null;
                  });
                },
                selectedColor: Color(0xFF6A1B9A), 
                backgroundColor: Color(0xFF9C4D97), 
                labelStyle: TextStyle(
                  color: _selectedType == EntryType.achievement ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              ChoiceChip(
                label: const Text('امتنان', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                selected: _selectedType == EntryType.gratitude,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = selected ? EntryType.gratitude : null;
                  });
                },
                selectedColor: Color(0xFF6A1B9A), 
                backgroundColor: Color(0xFF9C4D97),
                labelStyle: TextStyle(
                  color: _selectedType == EntryType.gratitude ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'اكتب شيئا...',
              filled: true,
              fillColor: AppColors.lightGray, 
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addEntry,
              child: const Text(
                'إضافة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
