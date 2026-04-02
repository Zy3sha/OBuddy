import '../models/food_entry.dart';

/// Common foods organised by category for the Food Explorer path.
const commonFoods = {
  'Vegetables': ['Broccoli', 'Carrots', 'Peas', 'Sweet potato', 'Cucumber', 'Corn', 'Peppers', 'Tomato'],
  'Fruits': ['Banana', 'Apple', 'Strawberry', 'Blueberry', 'Mango', 'Grapes', 'Orange', 'Watermelon'],
  'Proteins': ['Chicken', 'Fish', 'Eggs', 'Beans', 'Lentils', 'Tofu', 'Cheese', 'Yoghurt'],
  'Grains': ['Pasta', 'Rice', 'Bread', 'Oats', 'Cereal', 'Couscous', 'Noodles', 'Crackers'],
};

/// Exposure stage labels and descriptions
const exposureStageInfo = {
  ExposureStage.seen: ExposureStageInfo(
    label: 'Seen',
    icon: '👀',
    description: 'Food is on the table or plate. No pressure to interact.',
    encouragement: 'Just being near it is progress.',
  ),
  ExposureStage.touched: ExposureStageInfo(
    label: 'Touched',
    icon: '🤚',
    description: 'Child touched, poked, or picked it up.',
    encouragement: 'Hands-on is a big step forward.',
  ),
  ExposureStage.smelled: ExposureStageInfo(
    label: 'Smelled',
    icon: '👃',
    description: 'Child brought it close enough to smell.',
    encouragement: 'Getting curious is how comfort builds.',
  ),
  ExposureStage.tasted: ExposureStageInfo(
    label: 'Tasted',
    icon: '👅',
    description: 'Child licked, nibbled, or took a small bite.',
    encouragement: 'A taste is a triumph. No need to finish it.',
  ),
  ExposureStage.eating: ExposureStageInfo(
    label: 'Eating',
    icon: '😋',
    description: 'Child eats this food willingly.',
    encouragement: 'This is now a comfortable food.',
  ),
};

/// Food explorer scripts (using the Blended Response Model)
const foodScripts = {
  'new_food_introduction':
      'This is visiting our plate today. You don\'t have to eat it — just let it sit there.',
  'touch_encouragement':
      'You touched it! That was brave. Your hands are getting to know this food.',
  'refusal_response':
      'That\'s okay. It can stay on the plate. Maybe next time it\'ll feel more familiar.',
  'pressure_reminder':
      'No pressure. Exposure builds confidence. Every time they see it, it becomes less strange.',
};

class ExposureStageInfo {
  final String label;
  final String icon;
  final String description;
  final String encouragement;

  const ExposureStageInfo({
    required this.label,
    required this.icon,
    required this.description,
    required this.encouragement,
  });
}
