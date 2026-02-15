import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';
import 'setting.dart';

// ── Shared Dark Background ─────────────────────────────────────......
class DarkBackground extends StatelessWidget {
  const DarkBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

// ── Shared Glass Card ──────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlassCard({super.key, required this.child, this.padding, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        color: AppColors.surface.withOpacity(0.85),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ── Categories Screen ──────────────────────────────────────────
class PageScreen extends StatelessWidget {
  const PageScreen({super.key});

  static const Map<String, int> categories = {
    'General Knowledge': 9,
    'Books': 10,
    'Film': 11,
    'Science & Nature': 17,
    'Computers': 18,
    'Mathematics': 19,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Art': 25,
  };

  IconData _categoryIcon(String title) {
    switch (title) {
      case 'Books':
        return Icons.menu_book;
      case 'Film':
        return Icons.movie_filter;
      case 'Science & Nature':
        return Icons.biotech;
      case 'Computers':
        return Icons.computer;
      case 'Mathematics':
        return Icons.calculate;
      case 'Sports':
        return Icons.sports_soccer;
      case 'Geography':
        return Icons.public;
      case 'History':
        return Icons.history_edu;
      case 'Art':
        return Icons.color_lens;
      default:
        return Icons.lightbulb;
    }
  }

  Color _categoryColor(int index) {
    const colors = [
      Color(0xFF14B8A6), // Teal
      Color(0xFFF59E0B), // Amber
      Color(0xFF8B5CF6), // Violet
      Color(0xFF22C55E), // Green
      Color(0xFFEC4899), // Pink
      Color(0xFF3B82F6), // Blue
      Color(0xFFEF4444), // Red
      Color(0xFF06B6D4), // Cyan
      Color(0xFFF97316), // Orange
      Color(0xFFA855F7), // Purple
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final categoryTitles = categories.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Ready to Quiz?',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined,
                              color: AppColors.textSecondary),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsPage()),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Text(
                    'PICK A CATEGORY',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categories Grid
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryTitles.length > 9
                                ? 9
                                : categoryTitles.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.88,
                            ),
                            itemBuilder: (context, index) {
                              String title = categoryTitles[index];
                              return _buildCategoryCard(
                                  context, title, categories[title]!, index);
                            },
                          ),
                          if (categoryTitles.length > 9) ...[
                            const SizedBox(height: 12),
                            Center(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final double itemWidth =
                                      (constraints.maxWidth - 24) / 3;
                                  return SizedBox(
                                    width: itemWidth,
                                    child: _buildCategoryCard(
                                      context,
                                      categoryTitles[9],
                                      categories[categoryTitles[9]]!,
                                      9,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, int id, int index) {
    final color = _categoryColor(index);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DifficultyScreen(
              categoryName: title,
              categoryId: id,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _categoryIcon(title),
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Difficulty Screen ──────────────────────────────────────────
class DifficultyScreen extends StatelessWidget {
  final String categoryName;
  final int categoryId;

  const DifficultyScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: AppColors.textPrimary, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Select Difficulty',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      categoryName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                      children: [
                        _DifficultyCard(
                          title: 'Easy',
                          icon: Icons.trending_up,
                          color: const Color(0xFF22C55E),
                          onTap: () => _startQuiz(context, 'easy'),
                        ),
                        _DifficultyCard(
                          title: 'Medium',
                          icon: Icons.trending_neutral,
                          color: const Color(0xFFF59E0B),
                          onTap: () => _startQuiz(context, 'medium'),
                        ),
                        _DifficultyCard(
                          title: 'Hard',
                          icon: Icons.trending_down,
                          color: const Color(0xFFEF4444),
                          onTap: () => _startQuiz(context, 'hard'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizLoader(
          categoryName: categoryName,
          categoryId: categoryId,
          difficulty: difficulty,
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quiz Loader ────────────────────────────────────────────────
class QuizLoader extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final String difficulty;
  const QuizLoader({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.difficulty,
  });
  @override
  State<QuizLoader> createState() => _QuizLoaderState();
}

class _QuizLoaderState extends State<QuizLoader> {
  bool loading = true;
  String error = '';
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=10&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=multiple';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      if (data['response_code'] == 0) {
        setState(() {
          questions = data['results'];
          loading = false;
        });
      } else {
        throw Exception("No questions found for this difficulty.");
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: AppColors.textPrimary, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.categoryName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.difficulty.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loading
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 48,
                                height: 48,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Loading questions...',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : error.isNotEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.error.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 56,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Something went wrong",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Text(
                                      error,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF14B8A6),
                                          Color(0xFF0D9488)
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          loading = true;
                                          error = '';
                                        });
                                        loadQuestions();
                                      },
                                      icon: const Icon(Icons.refresh,
                                          size: 20, color: Colors.white),
                                      label: Text(
                                        "Try Again",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : QuizPage(
                                questions: questions,
                                categoryName: widget.categoryName,
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quiz Page ──────────────────────────────────────────────────
class QuizPage extends StatefulWidget {
  final List<dynamic> questions;
  final String categoryName;
  const QuizPage(
      {super.key, required this.questions, required this.categoryName});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final HtmlUnescape unescape = HtmlUnescape();

  int currentQuestion = 0;
  int correctAnswers = 0;
  bool answered = false;
  List<String> currentAnswers = [];

  @override
  void initState() {
    super.initState();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    var q = widget.questions[currentQuestion];
    currentAnswers = List<String>.from(q['incorrect_answers']);
    currentAnswers.add(q['correct_answer']);
    currentAnswers.shuffle();
  }

  void checkAnswer(String selectedAnswer) {
    if (answered) return;
    setState(() {
      answered = true;
      if (selectedAnswer ==
          widget.questions[currentQuestion]['correct_answer']) {
        correctAnswers++;
        showSnack("Correct! ✅", AppColors.success);
      } else {
        showSnack("Incorrect! ❌", AppColors.error);
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        if (currentQuestion + 1 < widget.questions.length) {
          currentQuestion++;
          answered = false;
          _prepareQuestion();
        } else {
          saveScoreToHive(
              widget.categoryName, correctAnswers, widget.questions.length);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ScorePage(
                score: correctAnswers,
                total: widget.questions.length,
              ),
            ),
          );
        }
      });
    });
  }

  void showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
      ),
    );
  }

  Future<void> saveScoreToHive(String category, int score, int total) async {
    var box = await Hive.openBox('quiz_scores');
    List<dynamic> scores = box.get('scores', defaultValue: []);
    scores.add({
      'category': category,
      'score': score,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });
    await box.put('scores', scores);
  }

  @override
  Widget build(BuildContext context) {
    var q = widget.questions[currentQuestion];
    double progress = (currentQuestion + 1) / widget.questions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Question ${currentQuestion + 1} of ${widget.questions.length}",
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Score: $correctAnswers",
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceLight.withOpacity(0.4),
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 28),

          // Question Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              unescape.convert(q['question']),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Answers
          Expanded(
            child: ListView.separated(
              itemCount: currentAnswers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                String ans = currentAnswers[index];
                bool isCorrect = ans == q['correct_answer'];

                Color borderColor = AppColors.surfaceLight.withOpacity(0.4);
                Color bgColor = AppColors.surface;
                Color textColor = AppColors.textPrimary;
                IconData? trailingIcon;

                if (answered) {
                  if (isCorrect) {
                    borderColor = AppColors.success;
                    bgColor = AppColors.success.withOpacity(0.1);
                    textColor = AppColors.success;
                    trailingIcon = Icons.check_circle;
                  } else {
                    borderColor = AppColors.error.withOpacity(0.3);
                    bgColor = AppColors.surface;
                    textColor = AppColors.textSecondary.withOpacity(0.5);
                  }
                }

                return AnimatedCard(
                  child: GestureDetector(
                    onTap: answered ? null : () => checkAnswer(ans),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1.5),
                        boxShadow: [
                          if (!answered)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: answered && isCorrect
                                  ? AppColors.success.withOpacity(0.2)
                                  : AppColors.surfaceLight.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: GoogleFonts.poppins(
                                  color: answered && isCorrect
                                      ? AppColors.success
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              unescape.convert(ans),
                              style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (trailingIcon != null)
                            Icon(trailingIcon,
                                color: AppColors.success, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Score Page ──────────────────────────────────────────────────
class ScorePage extends StatelessWidget {
  final int score;
  final int total;
  const ScorePage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    double percentage = (score / total) * 100;
    String message = "Great Job!";
    IconData icon = Icons.emoji_events_rounded;
    Color iconColor = AppColors.accent;

    if (percentage < 50) {
      message = "Keep Practicing!";
      icon = Icons.psychology_rounded;
      iconColor = AppColors.primary;
    } else if (percentage == 100) {
      message = "Perfect Score!";
      icon = Icons.auto_awesome_rounded;
      iconColor = AppColors.accent;
    }

    return Scaffold(
      body: Stack(
        children: [
          const DarkBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Trophy / Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                        border: Border.all(
                          color: iconColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(icon, size: 72, color: iconColor),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "You scored $score out of $total questions",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Score Card
                  GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
                          ).createShader(bounds),
                          child: Text(
                            "${percentage.toInt()}%",
                            style: GoogleFonts.poppins(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "ACCURACY",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Home Button
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(
                          context, (route) => route.isFirst),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Back to Home",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated Card Wrapper ──────────────────────────────────────
class AnimatedCard extends StatelessWidget {
  final Widget child;
  const AnimatedCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.95, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, double value, _) {
        return Transform.scale(
            scale: value,
            child: Material(color: Colors.transparent, child: child));
      },
    );
  }
}

