import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The 5 core Paths in OBuddy
class PathDefinition {
  final String id;
  final String title;
  final String icon;
  final String subtitle;
  final Color iconBgColor;
  final int totalStages;
  final List<String> stageNames;

  const PathDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.iconBgColor,
    required this.totalStages,
    required this.stageNames,
  });
}

const allPaths = [
  PathDefinition(
    id: 'potty',
    title: 'Potty Path',
    icon: '🚽',
    subtitle: 'Gentle potty training guidance',
    iconBgColor: AppColors.iconBgSage,
    totalStages: 5,
    stageNames: [
      'Observing readiness',
      'Getting familiar',
      'Practising together',
      'Building confidence',
      'Independent',
    ],
  ),
  PathDefinition(
    id: 'food',
    title: 'Food Explorer',
    icon: '🥦',
    subtitle: 'New foods, zero pressure',
    iconBgColor: AppColors.iconBgAmber,
    totalStages: 5,
    stageNames: [
      'Building comfort',
      'Expanding exposure',
      'Exploring textures',
      'Tasting new things',
      'Confident eater',
    ],
  ),
  PathDefinition(
    id: 'feelings',
    title: 'Big Feelings',
    icon: '🧠',
    subtitle: 'Understanding emotions',
    iconBgColor: AppColors.iconBgLavender,
    totalStages: 5,
    stageNames: [
      'Recognising feelings',
      'Naming emotions',
      'Learning to pause',
      'Expressing safely',
      'Self-regulation',
    ],
  ),
  PathDefinition(
    id: 'skills',
    title: 'Life Skills',
    icon: '🌟',
    subtitle: 'Building independence every day',
    iconBgColor: AppColors.iconBgPeach,
    totalStages: 5,
    stageNames: [
      'Watching & learning',
      'Trying with help',
      'Practising together',
      'Doing with reminders',
      'Independent',
    ],
  ),
  PathDefinition(
    id: 'routine',
    title: 'Routine Path',
    icon: '🌙',
    subtitle: 'Calm, connected days',
    iconBgColor: AppColors.iconBgBlue,
    totalStages: 5,
    stageNames: [
      'Building awareness',
      'Setting rhythm',
      'Practising consistency',
      'Owning the routine',
      'Self-directed',
    ],
  ),
];

/// Find a path definition by id
PathDefinition? findPath(String id) {
  try {
    return allPaths.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}
