import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/competition.dart';

class CompetitionRegisterSheet extends StatefulWidget {
  final Competition competition;

  const CompetitionRegisterSheet({super.key, required this.competition});

  @override
  State<CompetitionRegisterSheet> createState() =>
      _CompetitionRegisterSheetState();
}

class _CompetitionRegisterSheetState extends State<CompetitionRegisterSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _universityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _teamNameCtrl = TextEditingController();

  bool _isTeam = false;
  String _level = 'مبتدی';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _universityCtrl.dispose();
    _phoneCtrl.dispose();
    _teamNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // ماک درخواست سرور
    setState(() => _isSubmitting = false);

    if (!mounted) return;

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ثبت‌نام در "${widget.competition.title}" با موفقیت (ماک) انجام شد.',
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
                          'ثبت‌نام در مسابقه',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.competition.title,
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
                                controller: _universityCtrl,
                                label: 'دانشگاه (اختیاری)',
                                icon: Icons.school_outlined,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Switch(
                                          value: _isTeam,
                                          activeColor: Colors.cyanAccent,
                                          onChanged: (v) {
                                            setState(() => _isTeam = v);
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'شرکت تیمی',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _level,
                                      dropdownColor: Colors.black87,
                                      decoration:
                                          _dropdownDecoration('سطح مهارت'),
                                      items: const [
                                        'مبتدی',
                                        'متوسط',
                                        'حرفه‌ای',
                                      ].map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        if (v != null) {
                                          setState(() => _level = v);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_isTeam) ...[
                                const SizedBox(height: 10),
                                _textField(
                                  controller: _teamNameCtrl,
                                  label: 'نام تیم',
                                  icon: Icons.group_outlined,
                                  validator: (v) {
                                    if (!_isTeam) return null;
                                    if (v == null || v.trim().isEmpty) {
                                      return 'نام تیم را وارد کنید';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'با ثبت‌نام، قوانین مسابقه و مقررات برگزارکننده را می‌پذیرم.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                          'ثبت‌نام در مسابقه',
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

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
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
}

// برای حذف هاشور/گلو اسکرول داخل فرم
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

  // برای سازگاری با نسخه‌های قدیمی‌تر
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
