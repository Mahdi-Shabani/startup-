import '../models/app_user.dart';

class UserSession {
  UserSession._();

  static final UserSession instance = UserSession._();

  AppUser? currentUser;

  bool get isLoggedIn => currentUser != null;

  void logout() {
    currentUser = null;
  }
}
