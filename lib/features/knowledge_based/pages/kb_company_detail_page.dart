import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/kb_company.dart';

class KbCompanyDetailPage extends StatelessWidget {
  final KbCompany company;

  const KbCompanyDetailPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            company.name,
            style: const TextStyle(
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildContent() {
    return ClipRRect(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نام و شهر / حوزه
              Text(
                company.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${company.city}، ${company.province}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(company.domains.join('، ')),
                  if (company.isRemoteFriendly) _chip('امکان همکاری ریموت'),
                  ...company.tags.map((t) => _chip(t, small: true)).toList(),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: Colors.white.withOpacity(0.25),
              ),
              const SizedBox(height: 8),
              const Text(
                'درباره شرکت',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                company.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 13,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                'نیاز به هم‌تیمی / موقعیت‌های باز',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              if (!company.isHiring)
                Text(
                  'این شرکت در حال حاضر آگهی جذب نیروی فعالی ثبت نکرده است.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'این شرکت به دنبال هم‌تیمی برای نقش‌های زیر است:',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: company.openRoles.map((r) => _chip(r)).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'برای هماهنگی می‌توانید رزومه خود را به ایمیل شرکت ارسال کنید.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Text(
                'اطلاعات تماس',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.language_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      company.website,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      company.email,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.22),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 11 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
