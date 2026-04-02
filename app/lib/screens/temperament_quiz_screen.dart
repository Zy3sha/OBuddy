import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../data/temperament_system.dart';
import '../engines/profile_engine.dart';
import '../models/child_profile.dart';

/// Onboarding temperament quiz screen.
/// 10 scenario-based questions, under 2 minutes.
class TemperamentQuizScreen extends StatefulWidget {
  final String childName;
  final ValueChanged<TemperamentProfile> onComplete;

  const TemperamentQuizScreen({
    super.key,
    required this.childName,
    required this.onComplete,
  });

  @override
  State<TemperamentQuizScreen> createState() => _TemperamentQuizScreenState();
}

class _TemperamentQuizScreenState extends State<TemperamentQuizScreen> {
  int _currentQuestion = 0;
  final _answers = <Map<String, double>>[];
  int? _selectedOption;

  List<TemperamentQuizQuestion> get _questions => allQuizQuestions;
  TemperamentQuizQuestion get _question => _questions[_currentQuestion];
  bool get _isLastQuestion => _currentQuestion == _questions.length - 1;
  double get _progress => (_currentQuestion + 1) / _questions.length;

  void _selectOption(int index) {
    setState(() => _selectedOption = index);
  }

  void _next() {
    if (_selectedOption == null) return;

    _answers.add(_question.options[_selectedOption!].scores);

    if (_isLastQuestion) {
      final profile = ProfileEngine.scoreQuiz(_answers);
      widget.onComplete(profile);
      return;
    }

    setState(() {
      _currentQuestion++;
      _selectedOption = null;
    });
  }

  void _back() {
    if (_currentQuestion == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _answers.removeLast();
      _currentQuestion--;
      _selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppTheme.spacingMd,
          topPadding + AppTheme.spacingMd,
          AppTheme.spacingMd,
          bottomPadding + AppTheme.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              children: [
                GestureDetector(
                  onTap: _back,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Understanding ${widget.childName}',
                    style: AppTextStyles.subheading,
                  ),
                ),
                Text(
                  '${_currentQuestion + 1}/${_questions.length}',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Progress bar ──
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.primarySage.withOpacity(0.10),
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primarySage),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Question ──
            Text(
              _question.scenario,
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // ── Options ──
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _question.options.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppTheme.spacingSm),
                itemBuilder: (context, index) {
                  final option = _question.options[index];
                  final isSelected = _selectedOption == index;

                  return GlassCard(
                    onTap: () => _selectOption(index),
                    color: isSelected
                        ? AppColors.primarySage.withOpacity(0.08)
                        : null,
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primarySage
                                  : AppColors.cardBorder,
                              width: isSelected ? 2 : 1.5,
                            ),
                            color: isSelected
                                ? AppColors.primarySage
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option.label,
                            style: AppTextStyles.body.copyWith(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textBody,
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Continue button ──
            const SizedBox(height: AppTheme.spacingMd),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedOption != null ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySage,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primarySage.withOpacity(0.3),
                  disabledForegroundColor: Colors.white54,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusButton),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isLastQuestion ? 'See results' : 'Continue',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
