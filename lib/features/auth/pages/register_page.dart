import 'dart:ui';
import 'package:flutter/material.dart';

import 'login_page.dart';
import '../models/app_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _universityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700)); // ماک

    if (!mounted) return;

    // ساخت کاربر و ذخیره در سشن
    final user = AppUser(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      university: _universityController.text.trim(),
    );
    UserSession.instance.currentUser = user;

    setState(() => _isLoading = false);

    // رفتن به Home و حذف صفحه ثبت‌نام از استک
    Navigator.of(context).pushReplacementNamed('/home');
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _buildGlassCard(context),
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
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: _blurCircle(180, Colors.purpleAccent.withOpacity(0.35)),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: _blurCircle(220, Colors.cyanAccent.withOpacity(0.35)),
          ),
          Positioned(
            top: 120,
            right: -60,
            child: _blurCircle(160, Colors.blueAccent.withOpacity(0.25)),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.white.withOpacity(0.12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                      decoration: _inputDecoration(
                          'نام و نام خانوادگی', Icons.person_outline),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'لطفاً نام خود را وارد کنید';
                        }
                        if (value.trim().length < 3) {
                          return 'نام باید حداقل ۳ کاراکتر باشد';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          _inputDecoration('ایمیل', Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'ایمیل را وارد کنید';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'ایمیل معتبر نیست';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _universityController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                      decoration: _inputDecoration(
                          'دانشگاه (اختیاری)', Icons.school_outlined),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                      obscureText: _obscurePassword,
                      decoration:
                          _inputDecoration('رمز عبور', Icons.lock_outline)
                              .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'رمز عبور را وارد کنید';
                        }
                        if (value.length < 6) {
                          return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.22),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'ثبت نام',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildFooterText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.code_rounded,
          size: 48,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        const Text(
          'خوش اومدی!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'برای شروع، حساب کاربری‌ات رو بساز\nو دنیای مسابقات و استارتاپ‌ها رو دنبال کن.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.white.withOpacity(0.25),
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'قبلاً ثبت‌نام کرده‌ای؟',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              child: const Text(
                'ورود به حساب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
