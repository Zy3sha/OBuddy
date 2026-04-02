import '../models/skill_quest.dart';

/// Life skill quest definitions
const allSkillQuests = [
  SkillQuest(
    id: 'brush_teeth',
    title: 'Brush teeth',
    icon: '🪥',
    identityReward: 'Building consistency',
  ),
  SkillQuest(
    id: 'tidy_toys',
    title: 'Tidy toys',
    icon: '🧸',
    identityReward: 'Learning responsibility',
  ),
  SkillQuest(
    id: 'get_dressed',
    title: 'Get dressed',
    icon: '👕',
    identityReward: 'Growing independence',
  ),
  SkillQuest(
    id: 'wash_hands',
    title: 'Wash hands',
    icon: '🧼',
    identityReward: 'Healthy habits',
  ),
  SkillQuest(
    id: 'help_at_home',
    title: 'Help at home',
    icon: '🏠',
    identityReward: 'Caring & contributing',
  ),
  SkillQuest(
    id: 'put_on_shoes',
    title: 'Put on shoes',
    icon: '👟',
    identityReward: 'Growing independence',
  ),
  SkillQuest(
    id: 'set_table',
    title: 'Help set the table',
    icon: '🍽️',
    identityReward: 'Being part of the family',
  ),
  SkillQuest(
    id: 'say_please_thanks',
    title: 'Say please & thank you',
    icon: '💛',
    identityReward: 'Practising kindness',
  ),
];

/// Skill stage descriptions
const skillStages = {
  'not_started': 'Not started yet',
  'learning': 'Just beginning',
  'practicing': 'Getting better',
  'independent': 'Can do it alone',
};
