import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'widgets/bottom_nav.dart';
import 'screens/home_screen.dart';
import 'screens/paths_screen.dart';
import 'screens/today_screen.dart';
import 'screens/quick_help_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/guidance_result_screen.dart';
import 'screens/food_today_screen.dart';
import 'screens/life_skills_screen.dart';
import 'models/child_profile.dart';
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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentTab = 0;

  // ── Demo data (will be replaced with Firebase) ──
  final _child = ChildProfile(
    id: 'demo_child',
    name: 'Oliver',
    dob: DateTime(2024, 1, 15),
    temperament: const TemperamentProfile(
      primaryType: 'strong-willed',
      traits: {
        'persistence': 80,
        'sensitivity': 40,
        'independence': 70,
        'caution': 25,
      },
    ),
  );

  final _pathProgress = [
    const PathProgress(
      pathId: 'potty',
      status: 'active',
      currentStage: 2,
      totalStages: 5,
      todayGoal: 'Try sitting on potty after breakfast',
    ),
    const PathProgress(
      pathId: 'food',
      status: 'active',
      currentStage: 3,
      totalStages: 5,
      todayGoal: 'Place broccoli on the plate',
    ),
    const PathProgress(
      pathId: 'feelings',
      status: 'active',
      currentStage: 1,
      totalStages: 5,
      todayGoal: 'Name one feeling today',
    ),
    const PathProgress(
      pathId: 'skills',
      status: 'active',
      currentStage: 1,
      totalStages: 5,
      todayGoal: 'Try brushing teeth with help',
    ),
    const PathProgress(
      pathId: 'routine',
      status: 'active',
      currentStage: 2,
      totalStages: 5,
      todayGoal: 'Follow the bedtime sequence',
    ),
  ];

  final _todayItems = const [
    TodayItem(
      id: '1',
      title: 'Nursery drop-off',
      period: TodayPeriod.morning,
      time: '9:00',
      assignedTo: 'You',
    ),
    TodayItem(
      id: '2',
      title: 'Pack spare clothes',
      period: TodayPeriod.morning,
      isCompleted: true,
    ),
    TodayItem(
      id: '3',
      title: 'Pickup',
      period: TodayPeriod.afternoon,
      time: '3:30',
      assignedTo: 'Mike',
    ),
    TodayItem(
      id: '4',
      title: 'Potty practice after snack',
      period: TodayPeriod.afternoon,
      nudge: 'Keep it calm — no pressure',
    ),
    TodayItem(
      id: '5',
      title: 'Bath night',
      period: TodayPeriod.evening,
    ),
    TodayItem(
      id: '6',
      title: 'Early bedtime recommended',
      period: TodayPeriod.evening,
      nudge: 'Nursery days can be tiring',
    ),
  ];

  void _navigateToGuidance(String behaviourType) {
    final response = findScenario(behaviourType);
    if (response == null) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => GuidanceResultScreen(response: response),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToFood() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const FoodTodayScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToLifeSkills() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const LifeSkillsScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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
        return PathsScreen(
          key: const ValueKey('paths'),
          pathProgress: _pathProgress,
        );
      case 2:
        return TodayScreen(
          key: const ValueKey('today'),
          items: _todayItems,
          smartNudge: 'Today may feel harder after nursery. You might want an earlier bedtime.',
        );
      case 3:
        return QuickHelpScreen(
          key: const ValueKey('help'),
          onCategoryTap: _navigateToGuidance,
        );
      case 4:
        return ProfileScreen(
          key: const ValueKey('profile'),
          child: _child,
          pathProgress: _pathProgress,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
