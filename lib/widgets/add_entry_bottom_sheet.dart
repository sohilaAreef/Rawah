import 'package:flutter/material.dart';
import 'package:rawah/models/entry.dart';
import 'package:rawah/utils/app_colors.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Function(Entry) onAddEntry;
  final DateTime selectedDate;
  const AddEntryBottomSheet({
    super.key,
     required this.onAddEntry,
     required this.selectedDate
     });

  @override
  State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  EntryType? _selectedType;
  final TextEditingController _controller = TextEditingController();

void _addEntry(){
  if(_selectedType == null || _controller.text.trim().isEmpty){
    final entry = Entry(
    type: _selectedType!,
    title: _controller.text.trim(),
    date: widget.selectedDate,
  );
  widget.onAddEntry(entry);
  Navigator.pop(context);
  }
}

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         const Text(
          'Add Entry',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChoiceChip(
                label: const Text('الإنجازات')
                , selected: _selectedType == EntryType.achievement,
                onSelected: (selected){
                  setState((){
                  _selectedType = selected? EntryType.achievement : null;
                } );
               },
               selectedColor: AppColors.primary,
               labelStyle: TextStyle(
                color: _selectedType == EntryType.achievement ? Colors.black: Colors.grey
               ),
               ),
               ChoiceChip(
                label: const Text('الامتنان')
                , selected: _selectedType == EntryType.gratitude,
                onSelected: (selected){
                  setState((){
                  _selectedType = selected? EntryType.gratitude : null;
                } );
               },
               selectedColor: AppColors.LightPurple,
               labelStyle: TextStyle(
                color: _selectedType == EntryType.gratitude ? Colors.black: Colors.grey
               ),
               ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'اكتب شيئا...',
              filled: true,
              fillColor: AppColors.LightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)
              )
            ),
            maxLines: 10,
          ),
          const SizedBox(height: 16,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black
            ),
            onPressed: _addEntry,
             child: Text('إضافة'))
        ],
      ),
    );
  }
}