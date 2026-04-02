class ChildProfile {
  final String id;
  final String name;
  final DateTime dob;
  final String? photoUrl;
  final TemperamentProfile? temperament;

  const ChildProfile({
    required this.id,
    required this.name,
    required this.dob,
    this.photoUrl,
    this.temperament,
  });

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - dob.year) * 12 + now.month - dob.month;
  }

  String get ageLabel {
    final months = ageInMonths;
    if (months < 24) return '$months months';
    final years = months ~/ 12;
    final remaining = months % 12;
    if (remaining == 0) return '$years years';
    return '$years yr ${remaining}m';
  }
}

class TemperamentProfile {
  final String primaryType;
  final Map<String, double> traits;

  const TemperamentProfile({
    required this.primaryType,
    required this.traits,
  });

  static const types = [
    'strong-willed',
    'sensitive',
    'cautious',
    'independent',
    'routine-loving',
    'curious',
  ];
}
