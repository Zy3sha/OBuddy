import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../data/onboarding_data.dart';
import '../models/child_profile.dart';
import '../models/family_profile.dart';
import 'temperament_quiz_screen.dart';

/// Full onboarding flow.
///
/// Handles both fresh users and OBubba migrants.
/// Steps: Welcome → (Migration?) → Child info → Quiz intro → Partner → Done.
class OnboardingScreen extends StatefulWidget {
  final MigrationResult? migration;
  final ValueChanged<OnboardingOutput> onComplete;

  const OnboardingScreen({
    super.key,
    this.migration,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingOutput {
  final List<ChildProfile> children;
  final Map<String, TemperamentProfile> temperaments; // childId → profile
  final PartnerProfile? partner;
  final bool migratedFromOBubba;

  const OnboardingOutput({
    required this.children,
    this.temperaments = const {},
    this.partner,
    this.migratedFromOBubba = false,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<OnboardingStep> _steps;
  int _currentStep = 0;

  // Child entry state
  final _nameController = TextEditingController();
  DateTime? _selectedDob;
  final List<_ChildEntry> _children = [];
  bool _addingAnother = false;

  // Partner state
  final _partnerNameController = TextEditingController();
  final _partnerEmailController = TextEditingController();
  String _partnerRole = 'Co-parent';

  // Quiz results per child
  final Map<String, TemperamentProfile> _quizResults = {};
  int _quizChildIndex = 0;

  bool get _isMigrant => widget.migration?.hasData ?? false;

  @override
  void initState() {
    super.initState();
    _steps = buildOnboardingFlow(isMigrant: _isMigrant);

    // Pre-populate children from migration
    if (_isMigrant && widget.migration != null) {
      for (final mc in widget.migration!.children) {
        _children.add(_ChildEntry(
          name: mc.name,
          dob: mc.dob,
          migratedId: mc.id,
        ));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _partnerNameController.dispose();
    _partnerEmailController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _finish() {
    final children = _children.map((c) {
      final profile = ChildProfile(
        id: c.migratedId ?? 'child_${DateTime.now().millisecondsSinceEpoch}_${c.name.toLowerCase()}',
        name: c.name,
        dob: c.dob,
        temperament: _quizResults[c.name],
        quizCompleted: _quizResults.containsKey(c.name),
        migratedFromOBubba: c.migratedId != null,
      );
      return profile;
    }).toList();

    PartnerProfile? partner;
    if (_partnerNameController.text.isNotEmpty) {
      partner = PartnerProfile(
        id: 'partner_${DateTime.now().millisecondsSinceEpoch}',
        name: _partnerNameController.text.trim(),
        role: _partnerRole.toLowerCase().replaceAll('-', '_'),
        email: _partnerEmailController.text.isNotEmpty
            ? _partnerEmailController.text.trim()
            : null,
        invitedAt: DateTime.now(),
      );
    }

    widget.onComplete(OnboardingOutput(
      children: children,
      temperaments: _quizResults,
      partner: partner,
      migratedFromOBubba: _isMigrant,
    ));
  }

  void _saveCurrentChild() {
    if (_nameController.text.trim().isNotEmpty && _selectedDob != null) {
      _children.add(_ChildEntry(
        name: _nameController.text.trim(),
        dob: _selectedDob!,
      ));
      _nameController.clear();
      _selectedDob = null;
    }
  }

  void _startQuizForChild(int index) {
    _quizChildIndex = index;
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => TemperamentQuizScreen(
          childName: _children[index].name,
          onComplete: (result) {
            setState(() {
              _quizResults[_children[index].name] = result;
            });
            Navigator.of(context).pop();
            // If more children need the quiz, show for next; else advance
            if (index + 1 < _children.length) {
              _startQuizForChild(index + 1);
            } else {
              _next(); // move past quiz intro step
            }
          },
          onSkip: () {
            Navigator.of(context).pop();
            _next();
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          AppTheme.spacingLg,
          topPadding + AppTheme.spacingXl,
          AppTheme.spacingLg,
          bottomPadding + AppTheme.spacingMd,
        ),
        child: Column(
          children: [
            // Progress dots
            _ProgressDots(
              total: _steps.length,
              current: _currentStep,
            ),
            const SizedBox(height: AppTheme.spacingXl),
            Expanded(child: _buildStep()),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    final step = _steps[_currentStep];
    switch (step) {
      case OnboardingStep.welcome:
        return _buildWelcome();
      case OnboardingStep.migrationDetected:
        return _buildMigration();
      case OnboardingStep.childName:
        return _buildChildName();
      case OnboardingStep.childDob:
        return _buildChildDob();
      case OnboardingStep.addAnotherChild:
        return _buildAddAnother();
      case OnboardingStep.quizIntro:
        return _buildQuizIntro();
      case OnboardingStep.partnerInvite:
        return _buildPartnerInvite();
      case OnboardingStep.allDone:
        return _buildAllDone();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Welcome ──
  Widget _buildWelcome() {
    return _StepLayout(
      emoji: '🌿',
      title: _isMigrant ? OnboardingCopy.migrantTitle : OnboardingCopy.freshTitle,
      subtitle: _isMigrant ? OnboardingCopy.migrantSubtitle : OnboardingCopy.freshSubtitle,
      detail: _isMigrant ? OnboardingCopy.migrantDetail : null,
      ctaLabel: _isMigrant ? OnboardingCopy.migrantCta : OnboardingCopy.freshCta,
      onCta: _next,
    );
  }

  // ── Migration detected ──
  Widget _buildMigration() {
    final m = widget.migration!;
    return _StepLayout(
      emoji: '🏡',
      title: OnboardingCopy.migrationTitle,
      subtitle: null,
      ctaLabel: OnboardingCopy.migrationCta,
      onCta: _next,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(OnboardingCopy.migrationChildren, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          ...m.children.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.accentSand,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          c.name[0].toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(c.name, style: AppTextStyles.subheading)),
                      if (c.incidentCount > 0)
                        Text(
                          '${c.incidentCount} memories',
                          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.route_rounded, label: '${m.pathCount} ${OnboardingCopy.migrationPaths}'),
          const SizedBox(height: 6),
          _InfoRow(icon: Icons.history_rounded, label: '${m.incidentCount} ${OnboardingCopy.migrationIncidents}'),
        ],
      ),
    );
  }

  // ── Child name ──
  Widget _buildChildName() {
    return _StepLayout(
      emoji: '👶',
      title: OnboardingCopy.childNameTitle,
      subtitle: OnboardingCopy.childNameHelper,
      ctaLabel: 'Continue',
      ctaEnabled: _nameController.text.trim().isNotEmpty,
      onCta: _next,
      child: TextField(
        controller: _nameController,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        style: AppTextStyles.heading,
        decoration: InputDecoration(
          hintText: OnboardingCopy.childNameHint,
          hintStyle: AppTextStyles.heading.copyWith(color: AppColors.textMuted.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // ── Child DOB ──
  Widget _buildChildDob() {
    return _StepLayout(
      emoji: '🎂',
      title: OnboardingCopy.childDobTitle,
      subtitle: OnboardingCopy.childDobHelper,
      ctaLabel: 'Continue',
      ctaEnabled: _selectedDob != null,
      onCta: () {
        _saveCurrentChild();
        _next();
      },
      child: GestureDetector(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(now.year - 2, now.month, now.day),
            firstDate: DateTime(now.year - 6),
            lastDate: now,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primarySage,
                    onPrimary: Colors.white,
                    surface: AppColors.card,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) setState(() => _selectedDob = picked);
        },
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: _selectedDob != null ? AppColors.primarySage : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                _selectedDob != null
                    ? '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}'
                    : 'Tap to select date',
                style: AppTextStyles.body.copyWith(
                  color: _selectedDob != null ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add another child ──
  Widget _buildAddAnother() {
    return _StepLayout(
      emoji: '👦👧',
      title: OnboardingCopy.addAnotherTitle,
      subtitle: OnboardingCopy.addAnotherSubtitle,
      ctaLabel: OnboardingCopy.addAnotherSkip,
      onCta: _next,
      child: Column(
        children: [
          // Show existing children
          ..._children.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(c.name[0].toUpperCase(),
                            style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Text(c.name, style: AppTextStyles.bodyMedium),
                      const Spacer(),
                      const Icon(Icons.check_circle_rounded, color: AppColors.primarySage, size: 18),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 12),
          if (!_addingAnother)
            OutlinedButton.icon(
              onPressed: () => setState(() => _addingAnother = true),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(OnboardingCopy.addAnotherCta),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primarySage,
                side: const BorderSide(color: AppColors.primarySage),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            )
          else
            _InlineChildForm(
              nameController: _nameController,
              selectedDob: _selectedDob,
              onDobTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(now.year - 2),
                  firstDate: DateTime(now.year - 6),
                  lastDate: now,
                );
                if (picked != null) setState(() => _selectedDob = picked);
              },
              onSave: () {
                _saveCurrentChild();
                setState(() => _addingAnother = false);
              },
            ),
        ],
      ),
    );
  }

  // ── Quiz intro ──
  Widget _buildQuizIntro() {
    return _StepLayout(
      emoji: '🧩',
      title: OnboardingCopy.quizIntroTitle,
      subtitle: OnboardingCopy.quizIntroSubtitle,
      detail: _isMigrant ? OnboardingCopy.quizIntroMigrantNote : OnboardingCopy.quizIntroDetail,
      ctaLabel: OnboardingCopy.quizIntroCta,
      onCta: () {
        if (_children.isNotEmpty) {
          _startQuizForChild(0);
        } else {
          _next();
        }
      },
      skipLabel: OnboardingCopy.quizIntroSkip,
      onSkip: _next,
    );
  }

  // ── Partner invite ──
  Widget _buildPartnerInvite() {
    return _StepLayout(
      emoji: '🤝',
      title: OnboardingCopy.partnerTitle,
      subtitle: OnboardingCopy.partnerSubtitle,
      ctaLabel: OnboardingCopy.partnerCta,
      ctaEnabled: _partnerNameController.text.trim().isNotEmpty,
      onCta: _next,
      skipLabel: OnboardingCopy.partnerSkip,
      onSkip: _next,
      child: Column(
        children: [
          TextField(
            controller: _partnerNameController,
            textCapitalization: TextCapitalization.words,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Their name',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted.withOpacity(0.4)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _partnerEmailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Email (optional)',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted.withOpacity(0.4)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          // Role selector
          Wrap(
            spacing: 8,
            children: OnboardingCopy.partnerRoles.map((role) {
              final selected = _partnerRole == role;
              return ChoiceChip(
                label: Text(role),
                selected: selected,
                onSelected: (_) => setState(() => _partnerRole = role),
                selectedColor: AppColors.primarySage.withOpacity(0.15),
                labelStyle: AppTextStyles.caption.copyWith(
                  color: selected ? AppColors.primaryDark : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                side: BorderSide(
                  color: selected ? AppColors.primarySage : AppColors.cardBorder,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── All done ──
  Widget _buildAllDone() {
    return _StepLayout(
      emoji: '🌿',
      title: OnboardingCopy.doneTitle,
      subtitle: OnboardingCopy.doneSubtitle,
      ctaLabel: OnboardingCopy.doneCta,
      onCta: _finish,
      child: Column(
        children: [
          ..._children.map((c) {
            final temp = _quizResults[c.name];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accentSand,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(c.name[0].toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: AppTextStyles.bodyMedium),
                          if (temp != null)
                            Text(
                              '${temp.primaryType.replaceAll('-', ' ')}${temp.secondaryType != null ? ' + ${temp.secondaryType!.replaceAll('-', ' ')}' : ''}',
                              style: AppTextStyles.small.copyWith(color: AppColors.primarySage),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      temp != null ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      color: temp != null ? AppColors.primarySage : AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared layout widget for onboarding steps
// ─────────────────────────────────────────────────────────────

class _StepLayout extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final String? detail;
  final String ctaLabel;
  final VoidCallback onCta;
  final bool ctaEnabled;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final Widget? child;

  const _StepLayout({
    required this.emoji,
    required this.title,
    this.subtitle,
    this.detail,
    required this.ctaLabel,
    required this.onCta,
    this.ctaEnabled = true,
    this.skipLabel,
    this.onSkip,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 16),
        Text(title, style: AppTextStyles.display),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: AppTextStyles.body.copyWith(color: AppColors.textMuted)),
        ],
        if (detail != null) ...[
          const SizedBox(height: 12),
          Text(detail!, style: AppTextStyles.small.copyWith(color: AppColors.textMuted)),
        ],
        const SizedBox(height: 24),
        if (child != null) Expanded(child: SingleChildScrollView(child: child!))
        else const Spacer(),
        // CTA
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: ctaEnabled ? onCta : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySage,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primarySage.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            child: Text(ctaLabel),
          ),
        ),
        if (skipLabel != null && onSkip != null) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
              child: Text(skipLabel!),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────────────────────

class _ProgressDots extends StatelessWidget {
  final int total;
  final int current;
  const _ProgressDots({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i <= current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == current ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.primarySage : AppColors.primarySage.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primarySage),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.small.copyWith(color: AppColors.textMuted)),
      ],
    );
  }
}

class _InlineChildForm extends StatelessWidget {
  final TextEditingController nameController;
  final DateTime? selectedDob;
  final VoidCallback onDobTap;
  final VoidCallback onSave;

  const _InlineChildForm({
    required this.nameController,
    required this.selectedDob,
    required this.onDobTap,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Child\'s name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onDobTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                selectedDob != null
                    ? '${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}'
                    : 'Date of birth',
                style: AppTextStyles.body.copyWith(
                  color: selectedDob != null ? AppColors.textPrimary : AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: nameController.text.trim().isNotEmpty && selectedDob != null ? onSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarySage,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add child'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildEntry {
  final String name;
  final DateTime dob;
  final String? migratedId;
  _ChildEntry({required this.name, required this.dob, this.migratedId});
}
