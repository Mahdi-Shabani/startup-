class AppUser {
  final String fullName;
  final String email;
  final String university;

  const AppUser({
    required this.fullName,
    required this.email,
    required this.university,
  });
}

/// سشن ساده‌ی درون‌حافظه‌ای برای نگه‌داشتن کاربر لاگین‌شده
class UserSession {
  AppUser? currentUser;

  UserSession._();

  static final UserSession instance = UserSession._();
}
