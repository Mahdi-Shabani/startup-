class StartupExperience {
  final String id;
  final String projectName;
  final String startupName;
  final String developerName;
  final String role;
  final String city;
  final int startYear;
  final int? endYear;
  final String techStack; // مثلاً: Flutter, Firebase, REST API
  final String summary; // خلاصه تجربه
  final List<String> keyLessons; // نکات و توصیه‌ها

  const StartupExperience({
    required this.id,
    required this.projectName,
    required this.startupName,
    required this.developerName,
    required this.role,
    required this.city,
    required this.startYear,
    this.endYear,
    required this.techStack,
    required this.summary,
    required this.keyLessons,
  });
}
