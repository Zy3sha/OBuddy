class BehaviourIncident {
  final String id;
  final DateTime timestamp;
  final String type; // tantrum, refusing, hitting, not_listening, etc.
  final String? context;
  final bool resolved;

  const BehaviourIncident({
    required this.id,
    required this.timestamp,
    required this.type,
    this.context,
    this.resolved = false,
  });
}
