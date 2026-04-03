import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'widgets/bottom_nav.dart';
import 'screens/home_screen.dart';
import 'screens/paths_screen.dart';
import 'screens/today_screen.dart';
import 'screens/quick_help_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/guidance_result_screen.dart';
import 'screens/food_today_screen.dart';
import 'screens/life_skills_screen.dart';
import 'screens/temperament_quiz_screen.dart';
import 'models/child_profile.dart';
import 'models/family_profile.dart';
import 'models/path_progress.dart';
import 'models/today_item.dart';
import 'data/scenarios.dart';

class OBuddyApp extends StatelessWidget {
  const OBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBuddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppRoot(),
    );
  }
}

/// Root widget — routes to onboarding or main app.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _onboardingComplete = false;
  FamilyProfile? _family;
  List<ChildProfile> _children = [];
  int _activeChildIndex = 0;

  @override
  void initState() {
    super.initState();
    // TODO: Check StorageService + Firebase for existing data & migration
    // For demo, start with onboarding complete + demo child
    _loadDemoData();
  }

  void _loadDemoData() {
    _onboardingComplete = true;
    _children = [
      ChildProfile(
        id: 'demo_child',
        name: 'Oliver',
        dob: DateTime(2024, 1, 15),
        temperament: const TemperamentProfile(
          primaryType: 'strong-willed',
          secondaryType: 'independent',
          traits: {
            'persistence': 85,
            'sensitivity': 40,
            'independence': 72,
            'caution': 25,
            'adaptability': 35,
          },
        ),
        rhythm: RhythmState(
          currentPhase: 'boundary-testing',
          confidence: 'high',
          explanation:
              'Oliver has shown increased pushback and limit-testing recently. '
              'This is normal — he\'s checking the walls are still there.',
          detectedAt: DateTime.now(),
        ),
        quizCompleted: true,
      ),
    ];
    _family = FamilyProfile(
      id: 'demo_family',
      primaryUserId: 'demo_user',
      primaryUserName: 'Parent',
      childIds: ['demo_child'],
      activeChildId: 'demo_child',
      createdAt: DateTime.now(),
    );
  }

  void _completeOnboarding(OnboardingOutput output) {
    setState(() {
      _children = output.children;
      _activeChildIndex = 0;
      _family = FamilyProfile(
        id: 'family_${DateTime.now().millisecondsSinceEpoch}',
        primaryUserId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        childIds: output.children.map((c) => c.id).toList(),
        activeChildId: output.children.isNotEmpty ? output.children.first.id : null,
        partners: output.partner != null ? [output.partner!] : [],
        migratedFromOBubba: output.migratedFromOBubba,
        createdAt: DateTime.now(),
      );
      _onboardingComplete = true;
    });
  }

  void _switchChild(int index) {
    if (index >= 0 && index < _children.length) {
      setState(() => _activeChildIndex = index);
    }
  }

  void _updateChild(ChildProfile updated) {
    setState(() {
      _children[_activeChildIndex] = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_onboardingComplete) {
      return OnboardingScreen(onComplete: _completeOnboarding);
    }

    return AppShell(
      children: _children,
      activeChildIndex: _activeChildIndex,
      family: _family!,
      onSwitchChild: _switchChild,
      onUpdateChild: _updateChild,
    );
  }
}

/// Main app shell with bottom nav and multi-child support.
class AppShell extends StatefulWidget {
  final List<ChildProfile> children;
  final int activeChildIndex;
  final FamilyProfile family;
  final ValueChanged<int> onSwitchChild;
  final ValueChanged<ChildProfile> onUpdateChild;

  const AppShell({
    super.key,
    required this.children,
    required this.activeChildIndex,
    required this.family,
    required this.onSwitchChild,
    required this.onUpdateChild,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentTab = 0;

  ChildProfile get _child => widget.children[widget.activeChildIndex];

  final _pathProgress = [
    const PathProgress(pathId: 'potty', status: 'active', currentStage: 2, totalStages: 5, todayGoal: 'Try sitting on potty after breakfast'),
    const PathProgress(pathId: 'food', status: 'active', currentStage: 3, totalStages: 5, todayGoal: 'Place broccoli on the plate'),
    const PathProgress(pathId: 'feelings', status: 'active', currentStage: 1, totalStages: 5, todayGoal: 'Name one feeling today'),
    const PathProgress(pathId: 'skills', status: 'active', currentStage: 1, totalStages: 5, todayGoal: 'Try brushing teeth with help'),
    const PathProgress(pathId: 'routine', status: 'active', currentStage: 2, totalStages: 5, todayGoal: 'Follow the bedtime sequence'),
  ];

  final _todayItems = const [
    TodayItem(id: '1', title: 'Nursery drop-off', period: TodayPeriod.morning, time: '9:00', assignedTo: 'You'),
    TodayItem(id: '2', title: 'Pack spare clothes', period: TodayPeriod.morning, isCompleted: true),
    TodayItem(id: '3', title: 'Pickup', period: TodayPeriod.afternoon, time: '3:30', assignedTo: 'Mike'),
    TodayItem(id: '4', title: 'Potty practice after snack', period: TodayPeriod.afternoon, nudge: 'Keep it calm — no pressure'),
    TodayItem(id: '5', title: 'Bath night', period: TodayPeriod.evening),
    TodayItem(id: '6', title: 'Early bedtime recommended', period: TodayPeriod.evening, nudge: 'Nursery days can be tiring'),
  ];

  void _navigateToGuidance(String behaviourType) {
    final response = findScenario(behaviourType);
    if (response == null) return;
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => GuidanceResultScreen(response: response),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ));
  }

  void _navigateToFood() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const FoodTodayScreen(),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ));
  }

  void _navigateToLifeSkills() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const LifeSkillsScreen(),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ));
  }

  void _navigateToQuiz() {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => TemperamentQuizScreen(
        childName: _child.name,
        onComplete: (profile) {
          widget.onUpdateChild(_child.copyWith(
            temperament: profile,
            quizCompleted: true,
          ));
          Navigator.of(context).pop();
        },
        onSkip: () => Navigator.of(context).pop(),
        existingTraitScores: _child.migratedFromOBubba ? _child.temperament?.traits : null,
      ),
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
    ));
  }

  void _showChildSwitcher() {
    if (widget.children.length < 2) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Switch child', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              ...widget.children.asMap().entries.map((entry) {
                final i = entry.key;
                final c = entry.value;
                final isActive = i == widget.activeChildIndex;
                return ListTile(
                  onTap: () { widget.onSwitchChild(i); Navigator.pop(ctx); },
                  leading: CircleAvatar(
                    backgroundColor: isActive ? AppColors.primarySage : AppColors.accentSand,
                    child: Text(c.name[0].toUpperCase(), style: TextStyle(color: isActive ? Colors.white : AppColors.primaryDark, fontWeight: FontWeight.w600)),
                  ),
                  title: Text(c.name),
                  subtitle: Text(c.ageLabel),
                  trailing: isActive ? const Icon(Icons.check_circle, color: AppColors.primarySage) : null,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildScreen(),
      ),
      bottomNavigationBar: OBuddyBottomNav(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_currentTab) {
      case 0:
        return HomeScreen(
          key: const ValueKey('home'),
          child: _child,
          activePaths: _pathProgress,
          onQuickHelp: () => setState(() => _currentTab = 3),
          onFoodToday: _navigateToFood,
          onLifeSkills: _navigateToLifeSkills,
        );
      case 1:
        return PathsScreen(key: const ValueKey('paths'), pathProgress: _pathProgress);
      case 2:
        return TodayScreen(
          key: const ValueKey('today'),
          items: _todayItems,
          smartNudge: 'Today may feel harder after nursery. You might want an earlier bedtime.',
        );
      case 3:
        return QuickHelpScreen(key: const ValueKey('help'), onCategoryTap: _navigateToGuidance);
      case 4:
        return ProfileScreen(key: const ValueKey('profile'), child: _child, pathProgress: _pathProgress);
      default:
        return const SizedBox.shrink();
    }
  }
}
