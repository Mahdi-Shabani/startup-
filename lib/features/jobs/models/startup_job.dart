import 'package:flutter/material.dart';

class StartupJob {
  final String id;
  final String title; // عنوان نقش، مثلا «هم‌تیمی بک‌اند (Node.js)»
  final String startupName; // نام استارتاپ
  final String shortDescription; // توضیح کوتاه برای لیست
  final String description; // توضیح کامل
  final String domain; // حوزه: «پردازش تصویر / AI»، «موبایل»، «وب» و...
  final String location; // شهر یا «ریموت»
  final bool isRemote;
  final String commitment; // تمام‌وقت، پاره‌وقت، پروژه‌ای
  final String level; // جونیور، مید، سینیور
  final List<String> rolesNeeded; // مثلا [بک‌اند، پردازش تصویر]
  final List<String> skills; // مهارت‌ها
  final String contactEmail;

  const StartupJob({
    required this.id,
    required this.title,
    required this.startupName,
    required this.shortDescription,
    required this.description,
    required this.domain,
    required this.location,
    required this.isRemote,
    required this.commitment,
    required this.level,
    required this.rolesNeeded,
    required this.skills,
    required this.contactEmail,
  });
}
