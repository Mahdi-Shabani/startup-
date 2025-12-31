import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/competition.dart';
import 'competition_register_sheet.dart';

class CompetitionsListPage extends StatefulWidget {
  const CompetitionsListPage({super.key});

  @override
  State<CompetitionsListPage> createState() => _CompetitionsListPageState();
}

class _CompetitionsListPageState extends State<CompetitionsListPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = [
    'همه',
    'حضوری',
    'آنلاین',
    'دانشجویی',
    'هکاتون',
  ];

  int _selectedFilterIndex = 0;
  String _searchQuery = '';

  final List<Competition> _competitions = const [
    Competition(
      title: 'مسابقه الگوریتم دانشگاه شریف',
      organizer: 'دانشگاه صنعتی شریف',
      date: '۲۰ فروردین ۱۴۰۴',
      deadline: '۱۵ فروردین ۱۴۰۴',
      mode: 'حضوری',
      level: 'دانشجویی',
      tag: 'الگوریتم',
      accentColor: Color(0xFF4FC3F7),
    ),
    Competition(
      title: 'هکاتون هوش مصنوعی',
      organizer: 'مرکز نوآوری AI Labs',
      date: '۵ اردیبهشت ۱۴۰۴',
      deadline: '۲۸ فروردین ۱۴۰۴',
      mode: 'آنلاین',
      level: 'عمومی',
      tag: 'هکاتون',
      accentColor: Color(0xFFBA68C8),
    ),
    Competition(
      title: 'چالش توسعه اپلیکیشن موبایل',
      organizer: 'شتاب‌دهنده استارتاپ‌فکتوری',
      date: '۱۵ اردیبهشت ۱۴۰۴',
      deadline: '۱۰ اردیبهشت ۱۴۰۴',
      mode: 'آنلاین',
      level: 'دانشجویی',
      tag: 'Flutter',
      accentColor: Color(0xFFFFB74D),
    ),
    Competition(
      title: 'مسابقه برنامه‌نویسی وب',
      organizer: 'باشگاه برنامه‌نویسان',
      date: '۳۰ اردیبهشت ۱۴۰۴',
      deadline: '۲۵ اردیبهشت ۱۴۰۴',
      mode: 'آنلاین',
      level: 'عمومی',
      tag: 'Web',
      accentColor: Color(0xFF81C784),
    ),
    Competition(
      title: 'مسابقه امنیت و CTF',
      organizer: 'گروه امنیت سایبری CERT',
      date: '۱۰ خرداد ۱۴۰۴',
      deadline: '۵ خرداد ۱۴۰۴',
      mode: 'آنلاین',
      level: 'دانشجویی',
      tag: 'امنیت',
      accentColor: Color(0xFFFF8A65),
    ),
    Competition(
      title: 'Data Science Challenge',
      organizer: 'مرکز داده و هوش تجاری',
      date: '۲۵ خرداد ۱۴۰۴',
      deadline: '۲۰ خرداد ۱۴۰۴',
      mode: 'حضوری',
      level: 'عمومی',
      tag: 'داده',
      accentColor: Color(0xFF9575CD),
    ),
  ];

  List<Competition> get _filteredCompetitions {
    return _competitions.where((c) {
      final filter = _filters[_selectedFilterIndex];
      bool matchesFilter = true;

      if (filter == 'حضوری') {
        matchesFilter = c.mode == 'حضوری';
      } else if (filter == 'آنلاین') {
        matchesFilter = c.mode == 'آنلاین';
      } else if (filter == 'دانشجویی') {
        matchesFilter = c.level == 'دانشجویی';
      } else if (filter == 'هکاتون') {
        matchesFilter = c.tag == 'هکاتون';
      }

      final q = _searchQuery.trim();
      final matchesSearch = q.isEmpty ||
          c.title.contains(q) ||
          c.organizer.contains(q) ||
          c.tag.contains(q);

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
    final items = _filteredCompetitions;
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
            title: Row(
              children: const [
                Icon(Icons.rocket_launch_outlined, size: 22),
                SizedBox(width: 8),
                Text(
                  'مسابقات برنامه‌نویسی',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
                                      'مسابقه‌ای با این فیلتر پیدا نشد.',
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
                                      final comp = items[index];
                                      return _buildCompetitionCard(
                                          comp, isSmall);
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
        hintText: 'جست‌وجوی مسابقه، دانشگاه یا موضوع...',
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

  /// فیلترها در یک ردیف هستند و اگر جا کم باشد، از بغل اسکرول می‌شوند.
  Widget _buildFilters(bool isSmall) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true, // برای شروع از سمت راست (هماهنگ با RTL)
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

  Widget _buildCompetitionCard(Competition comp, bool isSmall) {
    final titleSize = isSmall ? 13.0 : 14.0;
    final subTitleSize = isSmall ? 11.0 : 12.0;
    final metaSize = isSmall ? 10.0 : 11.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: InkWell(
          onTap: () => _showRegisterBottomSheet(comp),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: comp.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comp.title,
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
                        comp.organizer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: subTitleSize,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event,
                                size: 14,
                                color: Colors.white.withOpacity(0.85),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                comp.date,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: metaSize,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: Colors.white.withOpacity(0.85),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'مهلت: ${comp.deadline}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: metaSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _chip(
                      text: comp.mode,
                      color: comp.accentColor.withOpacity(0.3),
                      small: isSmall,
                    ),
                    const SizedBox(height: 6),
                    _chip(
                      text: comp.level,
                      small: true,
                      color: Colors.white.withOpacity(0.24),
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
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color ?? Colors.white.withOpacity(0.20),
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

  void _showRegisterBottomSheet(Competition competition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => CompetitionRegisterSheet(competition: competition),
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
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
