import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/startups/models/startup_experience.dart';

class StartupsPage extends StatefulWidget {
  const StartupsPage({super.key});

  @override
  State<StartupsPage> createState() => _StartupsPageState();
}

class _StartupsPageState extends State<StartupsPage> {
  late List<StartupExperience> _experiences;

  @override
  void initState() {
    super.initState();
    _experiences = List.of(_mockExperiences);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'تجربه‌های استارتاپی برنامه‌نویس‌ها',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: _buildBody(),
            ),
          ],
        ),
        floatingActionButton: _buildFab(),
      ),
    );
  }

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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          _buildIntroCard(),
          const SizedBox(height: 12),
          Expanded(
            child: _experiences.isEmpty
                ? Center(
                    child: Text(
                      'هنوز هیچ تجربه‌ای ثبت نشده.\nاولین نفری باش که تجربه استارتاپی‌ات را ثبت می‌کنی!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _experiences.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final exp = _experiences[index];
                      return _buildExperienceCard(exp);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.16),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.22),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'استارتاپ‌ها و تجربه‌ها',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اینجا برنامه‌نویس‌ها می‌تونن از تجربه‌شون در پروژه‌های استارتاپی، تکنولوژی‌هایی که استفاده کردن و چالش‌هایی که داشتن بنویسن.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceCard(StartupExperience exp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => _showExperienceDetails(exp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان پروژه و استارتاپ
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exp.projectName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exp.startupName,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${exp.city}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatYears(exp),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // نام توسعه‌دهنده و نقش
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${exp.developerName} • ${exp.role}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // تکنولوژی‌ها
                  _buildTechChips(exp.techStack),

                  const SizedBox(height: 8),

                  // خلاصه کوتاه
                  Text(
                    exp.summary,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 11.5,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'مشاهده جزئیات تجربه',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTechChips(String techStack) {
    final technologies = techStack
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (technologies.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: -2,
      children: technologies.map((tech) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            tech,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatYears(StartupExperience exp) {
    if (exp.endYear == null || exp.endYear == exp.startYear) {
      return 'شروع: ${exp.startYear}';
    }
    return '${exp.startYear} تا ${exp.endYear}';
  }

  // ------------------ جزئیات تجربه در باتم‌شیت ------------------

  void _showExperienceDetails(StartupExperience exp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                exp.projectName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        Text(
                          exp.startupName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${exp.developerName} • ${exp.role} • ${exp.city}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatYears(exp),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTechChips(exp.techStack),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Text(
                                'خلاصه تجربه',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                exp.summary,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.97),
                                  fontSize: 12,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 14),
                              if (exp.keyLessons.isNotEmpty) ...[
                                Text(
                                  'مهم‌ترین نکات و درس‌ها',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...exp.keyLessons.map(
                                  (l) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• ',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 12,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            l,
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.95),
                                              fontSize: 12,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ------------------ افزودن تجربه جدید (ماک) ------------------

  Widget _buildFab() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.white.withOpacity(0.2),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'افزودن تجربه استارتاپی (ماک)',
        style: TextStyle(fontSize: 11.5),
      ),
      onPressed: _showAddExperienceSheet,
    );
  }

  void _showAddExperienceSheet() {
    final projectController = TextEditingController();
    final startupController = TextEditingController();
    final devNameController = TextEditingController();
    final roleController = TextEditingController(text: 'توسعه‌دهنده');
    final techController =
        TextEditingController(text: 'Flutter, REST API, Firebase');
    final summaryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const Text(
                          'ثبت تجربه استارتاپی (ماک)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'این فرم صرفاً برای تست UI است و فعلاً جایی ذخیره دائمی نمی‌شود. '
                          'بعداً می‌توانی آن را به بک‌اند وصل کنی.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: projectController,
                          label: 'نام پروژه / اپلیکیشن',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: startupController,
                          label: 'نام استارتاپ / تیم (اختیاری)',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: devNameController,
                          label: 'نام شما (برنامه‌نویس)',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: roleController,
                          label: 'نقش شما در تیم (مثلاً توسعه‌دهنده Flutter)',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: techController,
                          label: 'تکنولوژی‌ها (با کاما جدا کن)',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: summaryController,
                          label: 'خلاصه تجربه، چالش‌ها و نکات مهم',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 18),
                            label: const Text(
                              'ثبت در لیست (فقط در همین اجرا)',
                              style: TextStyle(fontSize: 11.5),
                            ),
                            onPressed: () {
                              if (projectController.text.trim().isEmpty ||
                                  devNameController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'حداقل نام پروژه و نام برنامه‌نویس را وارد کن.'),
                                  ),
                                );
                                return;
                              }

                              final nowYear = DateTime.now().year;

                              final exp = StartupExperience(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                projectName: projectController.text.trim(),
                                startupName:
                                    startupController.text.trim().isEmpty
                                        ? 'استارتاپ شخصی'
                                        : startupController.text.trim(),
                                developerName: devNameController.text.trim(),
                                role: roleController.text.trim().isEmpty
                                    ? 'توسعه‌دهنده'
                                    : roleController.text.trim(),
                                city: 'نامشخص',
                                startYear: nowYear,
                                endYear: null,
                                techStack: techController.text.trim(),
                                summary: summaryController.text.trim(),
                                keyLessons: const [],
                              );

                              setState(() {
                                _experiences.insert(0, exp);
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12.5,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 11.5,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.4,
          ),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.14),
      ),
    );
  }
}

// ------------------ دیتای ماک ------------------

const List<StartupExperience> _mockExperiences = [
  StartupExperience(
    id: 'exp_wallet_plus',
    projectName: 'کیف‌پول‌پلاس - اپ مدیریت مالی شخصی',
    startupName: 'تیم برنده مسابقات موبایل ۱۴۰۱',
    developerName: 'آرش محمدی',
    role: 'توسعه‌دهنده Flutter و لید فنی',
    city: 'تهران',
    startYear: 1400,
    endYear: 1402,
    techStack: 'Flutter, Firebase, REST API, Bloc, Firebase Crashlytics',
    summary:
        'بعد از شرکت در مسابقات موبایل ۱۴۰۱، نسخه اولیه کیف‌پول‌پلاس را تبدیل کردیم به یک محصول واقعی. '
        'چالش اصلی ما مدیریت تراکنش‌ها به صورت آفلاین و آنلاین بود، طوری که کاربر حتی بدون اینترنت هم بتواند هزینه‌ها '
        'و درآمدهایش را ثبت کند و بعداً با سرور سینک شود. برای تجربه کاربری، سعی کردیم روند ثبت تراکنش با کمترین تعداد کلیک انجام شود.',
    keyLessons: [
      'از همان اول، ساختار دیتابیس و مدل‌ها را با در نظر گرفتن توسعه آینده طراحی کن.',
      'به‌جای اضافه کردن صدتا فیچر، روی ۲–۳ فیچر اصلی که واقعاً مشکل کاربر را حل می‌کند تمرکز کن.',
      'Crashlytics و لاگ‌گیری درست، در پیدا کردن باگ‌های واقعی کاربران خیلی کمک می‌کند.',
    ],
  ),
  StartupExperience(
    id: 'exp_taxify',
    projectName: 'Taxify - محاسبه‌گر خودکار مالیات کسب‌وکارهای آنلاین',
    startupName: 'تیم دوم هکاتون فینتک ۱۴۰۲',
    developerName: 'یاسمن مرادی',
    role: 'Backend Developer (Node.js)',
    city: 'شیراز',
    startYear: 1401,
    endYear: null,
    techStack: 'Node.js, NestJS, PostgreSQL, Docker, RabbitMQ',
    summary:
        'در هکاتون فینتک ۱۴۰۲ روی سرویس محاسبه خودکار مالیات برای فروشگاه‌های آنلاین کار کردیم. '
        'بزرگ‌ترین چالش ما، پیاده‌سازی قوانین پیچیده مالیاتی به‌صورت ماژولار بود که بعداً بتوانیم قوانین جدید را بدون خراب کردن سیستم قبلی اضافه کنیم. '
        'برای این کار یک لایه Rule Engine ساده طراحی کردیم که هر قانون مثل یک ماژول جداگانه به آن اضافه می‌شود.',
    keyLessons: [
      'طراحی ماژولار برای قوانین تجاری (Business Rules) در پروژه‌های فینتک حیاتی است.',
      'از روز اول لاگ‌گذاری و مانیتورینگ را جدی بگیرید؛ مخصوصاً در کار با پول و محاسبات مالی.',
      'داشتن یک داکیومنتیشن ساده ولی دقیق، در هکاتون‌هایی که زمان کم است، تیم را نجات می‌دهد.',
    ],
  ),
  StartupExperience(
    id: 'exp_fitness_app',
    projectName: 'FitLife - اپ پیگیری عادت‌های سلامتی',
    startupName: 'استارتاپ شخصی دو نفره',
    developerName: 'نگار احمدی',
    role: 'Mobile Developer (Flutter)',
    city: 'اصفهان',
    startYear: 1399,
    endYear: 1401,
    techStack: 'Flutter, Provider, SQLite, Local Notifications',
    summary:
        'FitLife را به‌عنوان یک پروژه شخصی برای یادگیری Flutter شروع کردیم، اما کم‌کم متوجه شدیم که کاربران واقعاً از آن استفاده می‌کنند. '
        'تمرکز اصلی ما روی ساختن یک تجربه ساده برای ثبت عادت‌ها و ارسال نوتیفیکیشن‌های به‌موقع بود. '
        'یکی از اشتباهات اولیه این بود که بدون تست کاربری، چندین صفحه پیچیده برای گزارش‌ها طراحی کردیم که تقریباً کسی از آن استفاده نمی‌کرد.',
    keyLessons: [
      'قبل از این‌که وقت زیادی روی صفحات پیچیده بگذاری، نسخه ساده را به چند کاربر واقعی بده و فیدبک بگیر.',
      'برای پروژه‌های شخصی هم از هم‌اول معماری و State Management تمیز انتخاب کن؛ چون پروژه‌ها معمولاً بزرگ‌تر از چیزی می‌شوند که فکر می‌کنی.',
      'نوتیفیکیشن‌ها اگر بیش از حد باشند، کاربر را خسته می‌کنند. بهتر است قابل تنظیم و هوشمند باشند.',
    ],
  ),
];
