import 'package:flutter/material.dart';

class Competition {
  final String title;
  final String organizer;
  final String date;
  final String deadline;
  final String mode; // حضوری / آنلاین / هیبرید
  final String level; // دانشجویی / عمومی ...
  final String tag; // الگوریتم / هکاتون / ...
  final Color accentColor;

  const Competition({
    required this.title,
    required this.organizer,
    required this.date,
    required this.deadline,
    required this.mode,
    required this.level,
    required this.tag,
    required this.accentColor,
  });
}
