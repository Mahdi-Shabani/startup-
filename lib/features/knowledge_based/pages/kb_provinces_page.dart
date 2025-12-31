import 'dart:ui';

import 'package:flutter/material.dart';

import '../data/kb_companies_mock.dart';
import 'kb_companies_list_page.dart';

class KbProvincesPage extends StatefulWidget {
  const KbProvincesPage({super.key});

  @override
  State<KbProvincesPage> createState() => _KbProvincesPageState();
}

class _KbProvincesPageState extends State<KbProvincesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<String> get _filteredProvinces {
    final q = _searchQuery.trim();
    if (q.isEmpty) return iranProvinces;
    return iranProvinces.where((p) => p.contains(q)).toList();
  }

  int _countForProvince(String province) {
    return kbCompaniesMock.where((c) => c.province == province).length;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'شرکت‌های دانش‌بنیان',
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
                          _buildAllIranButton(),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _buildProvincesGrid(),
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

  // ------------------ پس‌زمینه ------------------

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

  // ------------------ سرچ ------------------

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
        hintText: 'جست‌وجوی استان...',
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

  // ------------------ دکمه همه ایران ------------------

  Widget _buildAllIranButton() {
    final total = kbCompaniesMock.length;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const KbCompaniesListPage(province: null),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.16),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.public,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'مشاهده همه شرکت‌های دانش‌بنیان ثبت‌شده',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.22),
                  ),
                  child: Text(
                    '$total شرکت',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------ گرید استان‌ها (۳ تایی در هر ردیف) ------------------

  Widget _buildProvincesGrid() {
    final provinces = _filteredProvinces;

    // محاسبه نسبت عرض/ارتفاع سلول‌ها بر اساس عرض صفحه
    final size = MediaQuery.of(context).size;
    const outerHorizontalPadding = 16 * 2; // همون پدینگ صفحه
    const crossAxisSpacing = 10.0;
    const crossAxisCount = 3;

    final availableWidth = size.width -
        outerHorizontalPadding -
        crossAxisSpacing * (crossAxisCount - 1);
    final cellWidth = availableWidth / crossAxisCount;
    final cellHeight = cellWidth * 1.1; // کمی بلندتر از مربع
    final aspectRatio = cellWidth / cellHeight;

    // بر اساس عرض سلول، فونت‌ها رو تنظیم می‌کنیم
    final provinceFontSize = cellWidth < 80 ? 11.0 : 13.0;
    final countFontSize = cellWidth < 80 ? 10.0 : 11.0;
    final iconSize = cellWidth < 80 ? 18.0 : 20.0;

    return GridView.builder(
      itemCount: provinces.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: 10,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) {
        final province = provinces[index];
        final count = _countForProvince(province);

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => KbCompaniesListPage(province: province),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_city,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    const Spacer(),
                    Text(
                      province,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: provinceFontSize,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      count == 0
                          ? 'بدون شرکت ثبت‌شده'
                          : '$count شرکت دانش‌بنیان',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: countFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ------------------ اسکرول بدون هاشور ------------------

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
