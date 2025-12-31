import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/startup_job.dart';

class JobApplySheet extends StatefulWidget {
  final StartupJob job;

  const JobApplySheet({super.key, required this.job});

  @override
  State<JobApplySheet> createState() => _JobApplySheetState();
}

class _JobApplySheetState extends State<JobApplySheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();

  bool _resumeSelected = false; // ماک برای رزومه
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _githubCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // ماک
    setState(() => _isSubmitting = false);

    if (!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'درخواست همکاری برای "${widget.job.title}" با موفقیت (ماک) ارسال شد.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SafeArea(
                top: false,
                child: ScrollConfiguration(
                  behavior: const _NoGlowScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Text(
                          'ارسال درخواست همکاری',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.job.title,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _textField(
                                controller: _nameCtrl,
                                label: 'نام و نام خانوادگی',
                                icon: Icons.person_outline,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'نام را وارد کنید';
                                  }
                                  if (v.trim().length < 3) {
                                    return 'نام باید حداقل ۳ کاراکتر باشد';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              _textField(
                                controller: _emailCtrl,
                                label: 'ایمیل',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'ایمیل را وارد کنید';
                                  }
                                  final emailRegex =
                                      RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(v.trim())) {
                                    return 'ایمیل معتبر نیست';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              _textField(
                                controller: _phoneCtrl,
                                label: 'شماره موبایل',
                                icon: Icons.phone_iphone,
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'شماره موبایل را وارد کنید';
                                  }
                                  if (v.trim().length < 10) {
                                    return 'شماره موبایل معتبر نیست';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              _textField(
                                controller: _githubCtrl,
                                label: 'لینک گیت‌هاب / لینکدین (اختیاری)',
                                icon: Icons.link_outlined,
                                keyboardType: TextInputType.url,
                              ),
                              const SizedBox(height: 10),
                              _multilineField(
                                controller: _aboutCtrl,
                                label: 'کمی درباره خودت و تجربیاتت بنویس',
                              ),
                              const SizedBox(height: 14),
                              _buildResumeSelector(),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.cyanAccent.withOpacity(0.9),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.black),
                                          ),
                                        )
                                      : const Text(
                                          'ارسال درخواست',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رزومه',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // اینجا فقط ماک است؛ بدون پکیج فایل‌پیکر
                setState(() {
                  _resumeSelected = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'در نسخه نمایشی، انتخاب فایل رزومه فقط به صورت نمادین انجام می‌شود.',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.12),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              icon: const Icon(Icons.upload_file_outlined, size: 18),
              label: const Text(
                'انتخاب فایل رزومه (PDF/DOC)',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            if (_resumeSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.lightGreenAccent,
                size: 20,
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _resumeSelected
              ? 'یک فایل رزومه (ماک) انتخاب شد.'
              : 'در نسخه واقعی می‌توان این دکمه را به فایل‌پیکر سیستم متصل کرد.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.right,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
        alignLabelWithHint: true,
        filled: true,
        fillColor: Colors.white.withOpacity(0.10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white, width: 1.2),
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
