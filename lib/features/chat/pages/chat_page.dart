import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/features/chat/models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingData = true;
  String? _loadError;

  List<_CompetitionRecord> _competitions = [];
  List<_StartupGuide> _guides = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final competitionsJsonStr =
          await rootBundle.loadString('assets/chat/competitions_history.json');
      final competitionsList = jsonDecode(competitionsJsonStr) as List<dynamic>;
      _competitions = competitionsList
          .map(
            (e) => _CompetitionRecord.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      final guidesJsonStr =
          await rootBundle.loadString('assets/chat/startup_guides.json');
      final guidesList = jsonDecode(guidesJsonStr) as List<dynamic>;
      _guides = guidesList
          .map(
            (e) => _StartupGuide.fromJson(e as Map<String, dynamic>),
          )
          .toList();

      setState(() {
        _isLoadingData = false;
        _loadError = null;
      });
    } catch (e) {
      setState(() {
        _isLoadingData = false;
        _loadError = 'خطا در بارگذاری دیتای مسابقات';
      });
    }
  }

  void _addWelcomeMessage() {
    const welcomeText =
        'سلام، من «تالا» هستم؛ دستیار هوشمند مسابقات برنامه‌نویسی و استارتاپی.\n'
        'می‌تونی از من درباره شرایط مسابقات، قهرمان‌ها، اسپانسرها و محل برگزاری رویدادها بپرسی.\n'
        'مثلاً بپرس:\n'
        '• شرایط مسابقات موبایل ۱۴۰۱ چطوری بود؟\n'
        '• قهرمان هکاتون فینتک ۱۴۰۲ کی بود؟\n'
        '• چطور در مسابقات استارتاپی ثبت‌نام کنم؟';

    setState(() {
      _messages.add(
        ChatMessage(
          text: welcomeText,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottomAfterBuild();
  }

  void _scrollToBottomAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend() async {
    final rawText = _inputController.text.trim();
    if (rawText.isEmpty) return;

    final userMessage = ChatMessage(
      text: rawText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _inputController.clear();
    });
    _scrollToBottomAfterBuild();

    await Future.delayed(const Duration(milliseconds: 400));

    final botReplyText = _generateBotReply(rawText);

    final botMessage = ChatMessage(
      text: botReplyText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });
    _scrollToBottomAfterBuild();
  }

  String _generateBotReply(String input) {
    if (_isLoadingData) {
      return 'در حال بارگذاری اطلاعات مسابقات هستم؛ چند ثانیه دیگر دوباره سؤالت را بپرس.';
    }
    if (_loadError != null) {
      return 'متاسفانه در بارگذاری دیتای مسابقات مشکلی پیش آمد. بعداً دوباره تلاش کن.';
    }

    final normalized = _normalize(input);

    // تشخیص اینکه سؤال داخل حوزه مسابقات/استارتاپ هست یا نه
    final domainKeywords = <String>[
      'مسابقه',
      'مسابقات',
      'هکاتون',
      'استارتاپ',
      'استارتاپی',
      'برنامه نویسی',
      'برنامه‌نویسی',
      'موبایل',
      'وب',
      'فینتک',
      'هوش مصنوعی',
      'چالش',
      'رویداد',
    ];

    final guideDomainKeywords = <String>[
      'راهنما',
      'کمک',
      'ثبت نام',
      'ثبتنام',
      'چطور ثبت',
      'چگونه ثبت',
      'نحوه ثبت',
      'آمادگی',
      'چطور استفاده',
      'این اپ',
      'اپلیکیشن',
    ];

    final bool hasDomainKeyword =
        domainKeywords.any((k) => normalized.contains(_normalize(k)));
    final bool hasGuideKeyword =
        guideDomainKeywords.any((k) => normalized.contains(_normalize(k)));

    if (!hasDomainKeyword && !hasGuideKeyword) {
      return 'من روی مسابقات برنامه‌نویسی، هکاتون‌ها و استارتاپ‌ها تمرکز دارم و '
          'درباره موضوعات دیگر اطلاعاتی ندارم.\n'
          'می‌تونی از من درباره شرایط مسابقات، قهرمان‌ها، اسپانسرها و نحوه شرکت در رویدادها بپرسی.';
    }

    // سعی می‌کنیم از دیتای مسابقات جواب بدهیم
    final competitionAnswer = _tryAnswerFromCompetitions(normalized);
    if (competitionAnswer != null) {
      return competitionAnswer;
    }

    // اگر مسابقه مشخص پیدا نشد، از راهنماها کمک بگیریم
    final guideAnswer = _tryAnswerFromGuides(normalized);
    if (guideAnswer != null) {
      return guideAnswer;
    }

    // جواب عمومی داخل حوزه
    return 'در دیتای من جواب دقیقی برای این سؤال پیدا نکردم، اما می‌تونی درباره این موارد بپرسی:\n'
        '- شرایط شرکت در مسابقات استارتاپی\n'
        '- قهرمان‌ها و برنده‌های دوره‌های قبل\n'
        '- اسپانسرها و محل برگزاری رویدادها\n'
        '- راهنمای ثبت‌نام و آمادگی برای هکاتون‌ها';
  }

  String? _tryAnswerFromCompetitions(String normalizedInput) {
    if (_competitions.isEmpty) return null;

    final year = _extractYear(normalizedInput);
    final tokens = normalizedInput.split(' ');

    _CompetitionRecord? bestComp;
    int bestScore = 0;

    for (final comp in _competitions) {
      int score = 0;

      if (year != null && comp.year == year) {
        score += 8;
      }

      final keywords = <String>[
        ...comp.keywords,
        comp.category,
        comp.topic,
        comp.title,
        comp.shortName,
        comp.city,
      ];

      score += _countKeywordMatches(normalizedInput, tokens, keywords);

      if (score > bestScore) {
        bestScore = score;
        bestComp = comp;
      } else if (score == bestScore &&
          score > 0 &&
          bestComp != null &&
          comp.year > bestComp.year) {
        // در صورت تساوی، رویداد جدیدتر انتخاب می‌شود
        bestComp = comp;
      }
    }

    if (bestComp == null || bestScore == 0) {
      return null;
    }

    final comp = bestComp;

    final bool askConditions = _containsAny(normalizedInput, [
      'شرایط',
      'قوانین',
      'ثبت نام',
      'ثبتنام',
      'نحوه شرکت',
      'چطور شرکت',
      'چجوری شرکت',
      'نحوه ثبت'
    ]);

    final bool askWinner = _containsAny(normalizedInput, [
      'قهرمان',
      'برنده',
      'اول شد',
      'نفر اول',
      'برنده ها',
      'برنده‌ها',
      'کی برد',
      'کی قهرمان شد'
    ]);

    final bool askSponsor =
        _containsAny(normalizedInput, ['اسپانسر', 'حامی', 'حامی مالی']);

    final bool askPlace = _containsAny(normalizedInput,
        ['کجا', 'محل', 'لوکیشن', 'شهر', 'کجا برگزار', 'کجا بود']);

    final bool askTime = _containsAny(normalizedInput,
        ['تاریخ', 'زمان', 'چه تاریخی', 'چه موقع', 'کی بود', 'چه روزی']);

    final bool hasSpecific =
        askConditions || askWinner || askSponsor || askPlace || askTime;

    final buffer = StringBuffer();

    buffer.writeln(comp.title);
    buffer.writeln('سال برگزاری: ${comp.year}');
    buffer.writeln('موضوع: ${comp.topic}.');

    if (!hasSpecific || askPlace || askTime) {
      buffer.writeln('');
      buffer.writeln('محل برگزاری: ${comp.place} (${comp.city}).');
      buffer.writeln('تاریخ برگزاری: ${comp.dateRange}.');
    }

    if (!hasSpecific || askSponsor) {
      buffer.writeln('');
      buffer.writeln('اسپانسر اصلی رویداد: ${comp.sponsor}.');
    }

    if (!hasSpecific || askConditions) {
      if (comp.conditions.isNotEmpty) {
        buffer.writeln('');
        buffer.writeln('برخی از شرایط اصلی شرکت در این مسابقه:');
        for (final c in comp.conditions) {
          buffer.writeln('- $c');
        }
      }
    }

    if (!hasSpecific || askWinner) {
      if (comp.winners.isNotEmpty) {
        final champ = comp.winners.first;
        buffer.writeln('');
        buffer.writeln(
            'قهرمان این دوره: تیم «${champ.teamName}» از ${champ.university}.');
        buffer.writeln('ایده تیم: ${champ.idea}.');

        if (comp.winners.length > 1) {
          buffer.writeln('');
          buffer.writeln('سایر تیم‌های برتر:');
          for (final w in comp.winners.skip(1)) {
            buffer.writeln(
                '- تیم «${w.teamName}» (رتبه ${w.position}) از ${w.university}');
          }
        }
      }
    }

    return buffer.toString().trim();
  }

  String? _tryAnswerFromGuides(String normalizedInput) {
    if (_guides.isEmpty) return null;

    final tokens = normalizedInput.split(' ');

    _StartupGuide? bestGuide;
    int bestScore = 0;

    for (final guide in _guides) {
      final score =
          _countKeywordMatches(normalizedInput, tokens, guide.keywords);
      if (score > bestScore) {
        bestScore = score;
        bestGuide = guide;
      }
    }

    if (bestGuide != null && bestScore > 0) {
      return bestGuide!.answer;
    }

    if (_containsAny(normalizedInput, ['راهنما', 'کمک', 'کمکم کن'])) {
      return 'من می‌تونم درباره این موارد راهنماییت کنم:\n'
          '- نحوه ثبت‌نام در مسابقات و هکاتون‌های استارتاپی\n'
          '- نکات آمادگی قبل از هکاتون\n'
          '- معیارهای داوری و انتخاب برنده‌ها\n'
          '- آشنایی با خود اپ «استارتاپ برنامه‌نویس»\n'
          'کافیه سؤال‌ات رو به زبان ساده بپرسی؛ مثلاً: «چطور در مسابقات استارتاپی ثبت‌نام کنم؟»';
    }

    return null;
  }

  int _countKeywordMatches(
    String normalizedInput,
    List<String> tokens,
    List<String> keywords,
  ) {
    int score = 0;

    for (final rawKeyword in keywords) {
      final k = _normalize(rawKeyword);
      if (k.isEmpty) continue;

      // اگر خود عبارت کامل پیدا شد، امتیاز بیشتری بده
      if (normalizedInput.contains(k)) {
        score += 3;
        continue;
      }

      // در غیر این صورت، روی کلمات مشترک حساب کن
      for (final token in tokens) {
        if (token.length < 3) continue;
        if (k.contains(token)) {
          score += 1;
        }
      }
    }

    return score;
  }

  int? _extractYear(String text) {
    final match = RegExp(r'(13[0-9]{2}|14[0-9]{2})').firstMatch(text);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  bool _containsAny(String text, List<String> patterns) {
    for (final p in patterns) {
      if (text.contains(_normalize(p))) return true;
    }
    return false;
  }

  String _normalize(String value) {
    var text = value.trim().toLowerCase();
    text = _replacePersianDigits(text);
    text = text.replaceAll('ي', 'ی').replaceAll('ك', 'ک');
    text = text.replaceAll('‌', ' '); // حذف نیم‌فاصله
    text = text.replaceAll(RegExp(r'[^\u0600-\u06FF0-9a-zA-Z\s]'), ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text;
  }

  String _replacePersianDigits(String input) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    var output = input;
    for (var i = 0; i < persian.length; i++) {
      output = output.replaceAll(persian[i], english[i]);
    }
    return output;
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // ---------------------- UI ----------------------

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
            'تالا - چت هوشمند',
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
              child: _buildChatBody(),
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

  Widget _buildChatBody() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildChatHeader(),
                      Divider(
                        height: 1,
                        color: Colors.white.withOpacity(0.25),
                      ),
                      Expanded(
                        child: _messages.isEmpty
                            ? Center(
                                child: Text(
                                  'سوالت درباره مسابقات استارتاپی را اینجا بنویس...',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding:
                                    const EdgeInsets.fromLTRB(12, 8, 12, 12),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  final msg = _messages[index];
                                  return _buildMessageBubble(msg);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
          child: _buildInputBar(),
        ),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تالا - دستیار مسابقات استارتاپی',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _loadError != null
                      ? _loadError!
                      : _isLoadingData
                          ? 'در حال بارگذاری اطلاعات رویدادها...'
                          : 'هر سوالی درباره مسابقات، هکاتون‌ها و استارتاپ‌ها داری بپرس.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.isUser;

    final bubbleColor = isUser
        ? Colors.black.withOpacity(0.35)
        : Colors.white.withOpacity(0.18);

    final borderColor = isUser
        ? Colors.white.withOpacity(0.12)
        : Colors.white.withOpacity(0.45);

    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    final crossAxis =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: crossAxis,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(0.45),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  minLines: 1,
                  maxLines: 4,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'سوالت درباره مسابقات استارتاپی را بنویس...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12.5,
                    ),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  size: 20,
                ),
                color: Colors.white,
                onPressed: _handleSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ مدل‌های داخلی برای دیتای چت‌بات ------------------

class _CompetitionRecord {
  final String id;
  final String title;
  final String shortName;
  final int year;
  final String category;
  final String topic;
  final String level;
  final String city;
  final String place;
  final String organizer;
  final String sponsor;
  final String dateRange;
  final String description;
  final List<String> conditions;
  final List<String> prizes;
  final List<_CompetitionWinner> winners;
  final List<String> keywords;

  _CompetitionRecord({
    required this.id,
    required this.title,
    required this.shortName,
    required this.year,
    required this.category,
    required this.topic,
    required this.level,
    required this.city,
    required this.place,
    required this.organizer,
    required this.sponsor,
    required this.dateRange,
    required this.description,
    required this.conditions,
    required this.prizes,
    required this.winners,
    required this.keywords,
  });

  factory _CompetitionRecord.fromJson(Map<String, dynamic> json) {
    return _CompetitionRecord(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      shortName: json['shortName'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      level: json['level'] as String? ?? '',
      city: json['city'] as String? ?? '',
      place: json['place'] as String? ?? '',
      organizer: json['organizer'] as String? ?? '',
      sponsor: json['sponsor'] as String? ?? '',
      dateRange: json['dateRange'] as String? ?? '',
      description: json['description'] as String? ?? '',
      conditions: (json['conditions'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      prizes: (json['prizes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      winners: (json['winners'] as List<dynamic>? ?? const [])
          .map(
            (e) => _CompetitionWinner.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      keywords: (json['keywords'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class _CompetitionWinner {
  final int position;
  final String teamName;
  final List<String> members;
  final String university;
  final String idea;

  _CompetitionWinner({
    required this.position,
    required this.teamName,
    required this.members,
    required this.university,
    required this.idea,
  });

  factory _CompetitionWinner.fromJson(Map<String, dynamic> json) {
    return _CompetitionWinner(
      position: json['position'] as int? ?? 0,
      teamName: json['teamName'] as String? ?? '',
      members: (json['members'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      university: json['university'] as String? ?? '',
      idea: json['idea'] as String? ?? '',
    );
  }
}

class _StartupGuide {
  final String id;
  final String title;
  final List<String> keywords;
  final String answer;

  _StartupGuide({
    required this.id,
    required this.title,
    required this.keywords,
    required this.answer,
  });

  factory _StartupGuide.fromJson(Map<String, dynamic> json) {
    return _StartupGuide(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      keywords: (json['keywords'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      answer: json['answer'] as String? ?? '',
    );
  }
}
