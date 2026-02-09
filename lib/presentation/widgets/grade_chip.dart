import 'package:flutter/material.dart';

class GradeChip extends StatelessWidget {
  const GradeChip({super.key, required this.value, this.size = 32});

  final int value;
  final double size;

  Color get _color {
    switch (value) {
      case 5:
        return const Color(0xFF22C55E);
      case 4:
        return const Color(0xFF3B82F6);
      case 3:
        return const Color(0xFFFACC15);
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '$value',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
