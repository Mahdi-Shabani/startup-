import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

// مدل/سشن کاربر برای نمایش پروفایل
import 'package:flutter_application_1/features/auth/models/app_user.dart';
import 'package:flutter_application_1/features/auth/pages/register_page.dart';

// سایر صفحات
import 'package:flutter_application_1/features/competitions/pages/competitions_list_page.dart';
import 'package:flutter_application_1/features/chat/pages/chat_page.dart';
import 'package:flutter_application_1/features/startups/pages/startups_page.dart';
import 'package:flutter_application_1/features/jobs/pages/jobs_list_page.dart';
import 'package:flutter_application_1/features/knowledge_based/pages/kb_provinces_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 0 = خانه، 1 = پروفایل، 2 = درباره
  int _tabIndex = 0;

  // اسلایدر بالا
  final PageController _pageController = PageController();
  final List<_BannerItem> _banners = const [
    _BannerItem(imageAsset: 'assets/images/banner1.jpg'),
    _BannerItem(imageAsset: 'assets/images/banner2.jpg'),
    _BannerItem(imageAsset: 'assets/images/banner3.jpg'),
  ];
  int _currentBanner = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_pageController.hasClients) return;
      final nextPage = (_currentBanner + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentBanner = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true, // ← این خط را اضافه کن
          title: const Text(
            'استارتاپ برنامه‌نویس',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ],
        ),
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: _buildBody(),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: bottomPadding > 0 ? bottomPadding - 4 : 8),
          child: _buildBottomBar(),
        ),
      ),
    );
  }

  // ------------------ بدنه‌ی تب‌ها ------------------

  Widget _buildBody() {
    switch (_tabIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildProfileContent();
      case 2:
        return _buildAboutContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildCoverCarousel(),
          const SizedBox(height: 20),
          _buildFeatureGrid(),
        ],
      ),
    );
  }

  // پروفایل کاربر (نمایش اطلاعات ثبت‌نام‌شده)
  Widget _buildProfileContent() {
    final user = UserSession.instance.currentUser;

    if (user == null) {
      // هنوز اطلاعات پروفایل نداریم
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 12),
              Text(
                'هنوز اطلاعات پروفایل ثبت نشده است.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'برای ساخت پروفایل، ابتدا از بخش ثبت‌نام، حساب کاربری بساز.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.22),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'رفتن به ثبت‌نام',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // اگر کاربر وجود دارد:
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withOpacity(0.16),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                if (user.university.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.university,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'خلاصه پروفایل',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'این اطلاعات از فرم ثبت‌نام خوانده شده است. '
                    'در نسخه نهایی می‌توان بخش ویرایش پروفایل، مهارت‌ها و رزومه را هم به این صفحه اضافه کرد.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withOpacity(0.16),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Text(
              'این اپلیکیشن برای معرفی مسابقات برنامه‌نویسی، شرکت‌های دانش‌بنیان، '
              'فرصت‌های شغلی و فضای اشتراک‌گذاری پروژه‌های برنامه‌نویس‌ها طراحی شده است.\n\n'
              'این متن فعلاً به صورت ماک است و می‌توانی بعداً توضیحات کامل‌تر و لوگو و لینک‌ها را این‌جا قرار بدهی.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: 13,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ بک‌گراند و اسلایدر ------------------

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF63E5C5),
            Color(0xFF14366F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildCoverCarousel() {
    return SizedBox(
      height: 190,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBanner = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      item.imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_banners.length, (index) {
        final isActive = index == _currentBanner;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 18 : 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isActive ? 0.9 : 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  // ------------------ باتم‌بار ------------------

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF14366F),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navPill(icon: Icons.info_outline, tabIndex: 2),
            _navPill(icon: Icons.person, tabIndex: 1),
            _navPill(icon: Icons.home, tabIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _navPill({required IconData icon, required int tabIndex}) {
    final bool isActive = _tabIndex == tabIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabIndex = tabIndex;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 78,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00A4FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A4FF).withOpacity(0.6),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
          size: 22,
        ),
      ),
    );
  }

  // ------------------ آیکون‌های فیچرها ------------------

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _featureCircle(
                label: 'فرصت‌های شغلی',
                asset: 'assets/images/job-offer.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const JobsListPage(),
                    ),
                  );
                },
              ),
              _featureCircle(
                label: 'شرکت‌های\nدانش‌بنیان',
                asset: 'assets/images/company.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const KbProvincesPage(),
                    ),
                  );
                },
              ),
              _featureCircle(
                label: 'مسابقات',
                asset: 'assets/images/rocket.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CompetitionsListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _featureCircle(
                label: 'تالا (چت\nهوشمند)',
                asset: 'assets/images/start-up.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChatPage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 24),
              _featureCircle(
                label: 'استارتاپ‌ها',
                asset: 'assets/images/startup.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StartupsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureCircle({
    required String label,
    required String asset,
    VoidCallback? onTap,
  }) {
    const double circleSize = 72;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(circleSize / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.45),
                      width: 1.2,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 80,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerItem {
  final String imageAsset;

  const _BannerItem({required this.imageAsset});
}
