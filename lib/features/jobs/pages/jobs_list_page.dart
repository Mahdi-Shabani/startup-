import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/startup_job.dart';
import 'job_detail_page.dart';

class JobsListPage extends StatefulWidget {
  const JobsListPage({super.key});

  @override
  State<JobsListPage> createState() => _JobsListPageState();
}

class _JobsListPageState extends State<JobsListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'همه',
    'موبایل',
    'وب',
    'پردازش تصویر / AI',
  ];

  int _selectedFilterIndex = 0;
  String _searchQuery = '';

  // دیتای ماک موقعیت‌های استارتاپی
  final List<StartupJob> _jobs = const [
    StartupJob(
      id: '1',
      title: 'هم‌تیمی پردازش تصویر (Python)',
      startupName: 'NeuroVision Lab',
      shortDescription:
          'پروژه پردازش تصویر MRI/EEG برای تحلیل فعالیت مغز؛ نیاز به هم‌تیمی فنی برای توسعه بک‌اند و مدل‌های AI.',
      description:
          'NeuroVision یک تیم تحقیقاتی/استارتاپی کوچک است که روی تحلیل داده‌های مغزی (EEG / MRI) کار می‌کند. '
          'در حال ساخت یک پلتفرم تحلیلی هستیم که پزشک‌ها و محقق‌ها بتوانند از طریق وب، داده‌های خام را آپلود و تحلیل کنند.\n\n'
          'در این مرحله به دنبال هم‌تیمی‌هایی هستیم که روی این بخش‌ها کمک کنند:\n'
          '- توسعه بک‌اند (Python / FastAPI یا Django)\n'
          '- توسعه و بهبود مدل‌های پردازش تصویر و سیگنال\n'
          '- طراحی پایگاه داده و سرویس‌های API\n\n'
          'الان در فاز MVP هستیم و به‌صورت ریموت کار می‌کنیم. در صورت جذب سرمایه، امکان سهام و تبدیل همکاری به تمام‌وقت وجود دارد.',
      domain: 'پردازش تصویر / AI',
      location: 'تهران / ریموت',
      isRemote: true,
      commitment: 'پاره‌وقت / پروژه‌ای',
      level: 'مید / جونیور با انگیزه',
      rolesNeeded: [
        'بک‌اند Python',
        'پردازش تصویر',
        'یادگیری ماشین',
      ],
      skills: [
        'Python',
        'NumPy / Pandas',
        'PyTorch یا TensorFlow',
        'FastAPI یا Django',
        'PostgreSQL / MongoDB',
      ],
      contactEmail: 'join@neurovisionlab.com',
    ),
    StartupJob(
      id: '2',
      title: 'برنامه‌نویس Flutter (هم‌تیمی موبایل)',
      startupName: 'FitBuddy',
      shortDescription:
          'اپلیکیشن ورزشی با تمرکز روی دانشجوها؛ نیاز به Flutter dev برای ساخت MVP اندروید/ iOS.',
      description:
          'FitBuddy یک اپ موبایل برای برنامه‌ریزی تمرین و تغذیه مخصوص دانشجوهاست. '
          'کانسپت UX و طراحی اولیه آماده شده و بک‌اند به‌صورت ساده با Node.js در حال توسعه است.\n\n'
          'دنبال هم‌تیمی Flutter هستیم که در این کارها کمک کند:\n'
          '- پیاده‌سازی UI بر اساس طراحی Figma\n'
          '- مدیریت State ساده (Provider / Riverpod اختیاری)\n'
          '- اتصال به API بک‌اند (Node.js / REST)\n'
          '- مدیریت احراز هویت و پروفایل کاربر\n\n'
          'فعلاً همکاری به‌صورت ریموت و پاره‌وقت است، با امکان سهام در صورت موندن در تیم.',
      domain: 'موبایل',
      location: 'ریموت',
      isRemote: true,
      commitment: 'پاره‌وقت',
      level: 'جونیور / مید',
      rolesNeeded: [
        'Flutter Developer',
      ],
      skills: [
        'Flutter / Dart',
        'REST API',
        'Git',
        'آشنایی با Firebase مزیت است',
      ],
      contactEmail: 'team@fitbuddy.app',
    ),
    StartupJob(
      id: '3',
      title: 'هم‌تیمی فول‌استک (React + Node)',
      startupName: 'CampusMarket',
      shortDescription:
          'مارکت‌پلیس برای خرید و فروش کتاب و وسایل دانشجویی در دانشگاه‌ها؛ نیاز به فول‌استک برای تکمیل نسخه وب.',
      description:
          'CampusMarket یک پلتفرم وب برای خرید و فروش کتاب، جزوه و وسایل دست‌دوم بین دانشجوهاست. '
          'هسته اولیه بک‌اند و دیتابیس پیاده‌سازی شده، اما UI و خیلی از فیچرها هنوز جای کار دارد.\n\n'
          'به‌دنبال هم‌تیمی فول‌استک هستیم که روی این قسمت‌ها کار کند:\n'
          '- توسعه فرانت‌اند با React یا Next.js\n'
          '- توسعه APIها با Node.js (Express / Nest)\n'
          '- بهینه‌سازی جست‌وجو و فیلتر آگهی‌ها\n'
          '- استقرار روی سرور (مثلاً Render / Railway)\n\n'
          'همکاری به‌صورت ریموت و پروژه‌ای است، با امکان سهام در صورت تداوم همکاری.',
      domain: 'وب',
      location: 'ریموت',
      isRemote: true,
      commitment: 'پروژه‌ای',
      level: 'مید',
      rolesNeeded: [
        'Front-end React',
        'Back-end Node.js',
      ],
      skills: [
        'React یا Next.js',
        'Node.js',
        'REST API / JSON',
        'Git',
      ],
      contactEmail: 'hello@campusmarket.io',
    ),
    StartupJob(
      id: '4',
      title: 'هم‌تیمی موبایل برای فین‌تک',
      startupName: 'SplitPay',
      shortDescription:
          'استارتاپ فین‌تک برای تقسیم هزینه‌ها بین دوستان؛ نیاز به Flutter dev برای توسعه اپ پرداخت.',
      description:
          'SplitPay روی ساده‌کردن تقسیم هزینه‌ها بین دوستان تمرکز دارد (خرج رستوران، سفر، پروژه و ...). '
          'طراحی UX آماده است و APIهای بانکی در حال تست هستند.\n\n'
          'نیاز به هم‌تیمی موبایل داریم برای:\n'
          '- پیاده‌سازی صفحات اصلی (ایجاد گروه، ثبت هزینه، تسویه)\n'
          '- اتصال به APIهای پرداخت و کیف پول\n'
          '- مدیریت State و هندل خطاها\n\n'
          'همکاری ابتدا پاره‌وقت است و در صورت رشد، امکان تمام‌وقت شدن و سهام وجود دارد.',
      domain: 'موبایل',
      location: 'تهران (با امکان ریموت)',
      isRemote: true,
      commitment: 'پاره‌وقت / تمام‌وقت بالقوه',
      level: 'مید',
      rolesNeeded: [
        'Flutter Developer',
      ],
      skills: [
        'Flutter',
        'امنیت و احراز هویت ساده',
        'آشنایی با مفاهیم پرداخت آنلاین',
      ],
      contactEmail: 'join@splitpay.app',
    ),
  ];

  List<StartupJob> get _filteredJobs {
    return _jobs.where((job) {
      final filter = _filters[_selectedFilterIndex];
      bool matchesFilter = true;

      if (filter == 'موبایل') {
        matchesFilter = job.domain == 'موبایل';
      } else if (filter == 'وب') {
        matchesFilter = job.domain == 'وب';
      } else if (filter == 'پردازش تصویر / AI') {
        matchesFilter = job.domain == 'پردازش تصویر / AI';
      }

      final q = _searchQuery.trim();
      final matchesSearch = q.isEmpty ||
          job.title.contains(q) ||
          job.startupName.contains(q) ||
          job.domain.contains(q);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredJobs;
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScrollConfiguration(
        behavior: const _NoGlowScrollBehavior(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: const Text(
              'فرصت‌های شغلی استارتاپی',
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(),
                          const SizedBox(height: 12),
                          _buildFilters(isSmall),
                          const SizedBox(height: 16),
                          Expanded(
                            child: items.isEmpty
                                ? Center(
                                    child: Text(
                                      'موقعیتی با این فیلتر پیدا نشد.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final job = items[index];
                                      return _buildJobCard(job, isSmall);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: 'جست‌وجوی عنوان، استارتاپ یا حوزه...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildFilters(bool isSmall) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final selected = index == _selectedFilterIndex;
          final label = _filters[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                  fontSize: isSmall ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: selected,
              backgroundColor: Colors.white.withOpacity(0.15),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              onSelected: (_) {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildJobCard(StartupJob job, bool isSmall) {
    final titleSize = isSmall ? 13.0 : 14.0;
    final subTitleSize = isSmall ? 11.0 : 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => JobDetailPage(job: job),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.16),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان و استارتاپ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.startupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: subTitleSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // تگ‌ها
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _chip(text: job.domain),
                        const SizedBox(height: 4),
                        _chip(
                          text: job.isRemote ? 'ریموت' : job.location,
                          small: true,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // توضیح کوتاه
                Text(
                  job.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                // نقش‌ها و سطح
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: -4,
                        children: job.rolesNeeded
                            .take(2)
                            .map(
                              (r) => _chip(
                                text: r,
                                small: true,
                                light: true,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      text: job.level,
                      small: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required String text,
    bool small = false,
    bool light = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: light
            ? Colors.white.withOpacity(0.18)
            : Colors.white.withOpacity(0.26),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
