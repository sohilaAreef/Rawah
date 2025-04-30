import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawah/logic/value_provider.dart';
import 'package:rawah/models/value_model.dart';
import 'package:rawah/utils/app_colors.dart';

class ValueCard extends StatelessWidget {
  final ValueModel value;
  final double cardHeight;

  const ValueCard({
    super.key, 
    required this.value,
    this.cardHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    final valueProvider = Provider.of<ValueProvider>(context);
    final isSelected = valueProvider.isSelected(value);

    return GestureDetector(
      onTap: () => valueProvider.toggleValue(value),
      child: Container(
        height: cardHeight,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // صورة الخلفية
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(isSelected ? 0.4 : 0.2),
                  BlendMode.darken,
                ),
                child: Image.network(
                  value.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // طبقة التدرج اللوني
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            // حدود بطاقة التحديد
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accent,
                    width: 3,
                  ),
                ),
              ),
            
            // أيقونة التحديد
            if (isSelected)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            
            // نص القيمة
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  value.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}