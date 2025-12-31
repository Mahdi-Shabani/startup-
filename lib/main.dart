import 'package:flutter/material.dart';

// صفحات اصلی
import 'features/home/pages/home_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/competitions/pages/competitions_list_page.dart';
import 'features/jobs/pages/jobs_list_page.dart';
import 'features/knowledge_based/pages/kb_provinces_page.dart';
import 'features/chat/pages/chat_page.dart';
import 'features/startups/pages/startups_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto', //     فونت  تغییر کنه
      ),

      // تعیین صفحه شروع
      initialRoute: '/login', // اگر خواستی مستقیم بره هوم: '/home'

      routes: {
        '/home': (_) => const HomePage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/competitions': (_) => const CompetitionsListPage(),
        '/jobs': (_) => const JobsListPage(),
        '/kb': (_) => const KbProvincesPage(),
        '/chat': (_) => const ChatPage(),
        '/startups': (_) => const StartupsPage(),
      },
    );
  }
}
