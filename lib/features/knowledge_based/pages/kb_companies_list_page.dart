import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/kb_companies_mock.dart';
import '../models/kb_company.dart';
import 'kb_company_detail_page.dart';

class KbCompaniesListPage extends StatefulWidget {
  /// اگر null باشد، یعنی همه استان‌ها
  final String? province;

  const KbCompaniesListPage({super.key, this.province});

  @override
  State<KbCompaniesListPage> createState() => _KbCompaniesListPageState();
}

class _KbCompaniesListPageState extends State<KbCompaniesListPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _onlyHiring = false;
  String _searchQuery = '';

  List<KbCompany> get _filteredCompanies {
    return kbCompaniesMock.where((c) {
      // فیلتر استان
      bool matchesProvince = true;
      if (widget.province != null) {
        matchesProvince = c.province == widget.province;
      }

      // فیلتر «در حال جذب نیرو»
      bool matchesHiring = !_onlyHiring || c.isHiring;

      // فیلتر جست‌وجو
      final q = _searchQuery.trim();
      final matchesSearch = q.isEmpty ||
          c.name.contains(q) ||
          c.city.contains(q) ||
          c.province.contains(q) ||
          c.domains.any((d) => d.contains(q));

      return matchesProvince && matchesHiring && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companies = _filteredCompanies;
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    final titleProvince =
        widget.province == null ? 'همه استان‌ها' : widget.province!;

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
            title: Text(
              'شرکت‌های دانش‌بنیان – $titleProvince',
              style: const TextStyle(
                fontSize: 16,
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
                          _buildFilters(),
                          const SizedBox(height: 16),
                          Expanded(
                            child: companies.isEmpty
                                ? Center(
                                    child: Text(
                                      'در حال حاضر شرکت دانش‌بنیانی برای این استان ثبت نشده است.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: companies.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final company = companies[index];
                                      return _buildCompanyCard(
                                          company, isSmall);
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
        hintText: 'جست‌وجوی نام شرکت، شهر یا حوزه فعالیت...',
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

  Widget _buildFilters() {
    return Row(
      children: [
        FilterChip(
          label: const Text(
            'فقط در حال جذب نیرو',
            style: TextStyle(fontSize: 12),
          ),
          selected: _onlyHiring,
          labelStyle: TextStyle(
            color: _onlyHiring ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          selectedColor: Colors.white,
          backgroundColor: Colors.white.withOpacity(0.15),
          onSelected: (val) {
            setState(() {
              _onlyHiring = val;
            });
          },
          checkmarkColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildCompanyCard(KbCompany company, bool isSmall) {
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
                builder: (_) => KbCompanyDetailPage(company: company),
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
                // نام و شهر/حوزه
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company.name,
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
                            '${company.city}، ${company.province}',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _chip(
                          text: company.domains.join('، '),
                          small: true,
                        ),
                        const SizedBox(height: 4),
                        if (company.isHiring)
                          _chip(
                            text: 'در حال جذب نیرو',
                            small: true,
                            highlight: true,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // توضیح کوتاه
                Text(
                  company.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                // تگ‌ها
                Wrap(
                  spacing: 6,
                  runSpacing: -2,
                  children: [
                    if (company.isRemoteFriendly)
                      _chip(
                        text: 'امکان همکاری ریموت',
                        small: true,
                      ),
                    ...company.tags
                        .map((t) => _chip(text: t, small: true))
                        .toList(),
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
    bool highlight = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: highlight
            ? Colors.lightGreenAccent.withOpacity(0.85)
            : Colors.white.withOpacity(0.22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: highlight ? Colors.black : Colors.white,
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
