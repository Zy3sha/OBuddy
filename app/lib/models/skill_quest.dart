class SkillQuest {
  final String id;
  final String title;
  final String icon;
  final String identityReward;
  final String status; // not_started, learning, practicing, independent

  const SkillQuest({
    required this.id,
    required this.title,
    required this.icon,
    required this.identityReward,
    this.status = 'not_started',
  });
}
