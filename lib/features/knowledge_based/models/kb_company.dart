import 'package:flutter/material.dart';

class KbCompany {
  final String id;
  final String name;
  final String province;
  final String city;
  final List<String> domains; // حوزه‌ها: AI، فین‌تک و ...
  final String shortDescription;
  final String description;
  final bool isHiring; // در حال جذب نیرو؟
  final List<String> openRoles; // نقش‌های موردنیاز
  final bool isRemoteFriendly;
  final String website;
  final String email;
  final List<String> tags;

  const KbCompany({
    required this.id,
    required this.name,
    required this.province,
    required this.city,
    required this.domains,
    required this.shortDescription,
    required this.description,
    required this.isHiring,
    required this.openRoles,
    required this.isRemoteFriendly,
    required this.website,
    required this.email,
    required this.tags,
  });
}
