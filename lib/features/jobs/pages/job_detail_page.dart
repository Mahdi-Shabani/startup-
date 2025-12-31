import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/startup_job.dart';
import 'job_apply_sheet.dart';

class JobDetailPage extends StatelessWidget {
  final StartupJob job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true, // ← اضافه شد تا گرادیان تا پشت bottomBar هم بره
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            job.startupName,
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
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                    child: _buildContent(context),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => JobApplySheet(job: job),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withOpacity(0.9),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'ارسال درخواست همکاری و رزومه',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
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

  Widget _buildContent(BuildContext context) {
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
              // عنوان و استارتاپ
              Text(
                job.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                job.startupName,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(job.domain),
                  _chip(job.isRemote ? 'ریموت' : job.location),
                  _chip(job.commitment),
                  _chip('سطح: ${job.level}'),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: Colors.white.withOpacity(0.25),
              ),
              const SizedBox(height: 8),
              const Text(
                'درباره استارتاپ و پروژه',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                job.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: 13,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Text(
                'نقش‌های موردنیاز',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.rolesNeeded.map((r) => _chip(r)).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'مهارت‌های ترجیحی',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.skills.map((s) => _chip(s, small: true)).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'ایمیل ارتباطی استارتاپ',
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
                    Icons.email_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.contactEmail,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'در فرم پایین می‌تونی همین‌جا درخواست همکاری و رزومه‌ات رو بفرستی.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                ),
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
