/// The core data model for the Blended Response Model.
/// Every parenting guidance output uses this structure:
///   1. Calm Boundary → 2. Emotional Validation → 3. Guided Action
class GuidanceResponse {
  final String behaviourType;
  final String whyHappening;
  final String calmBoundary;
  final String emotionalValidation;
  final String guidedAction;
  final String sampleScript;
  final String whatToAvoid;

  const GuidanceResponse({
    required this.behaviourType,
    required this.whyHappening,
    required this.calmBoundary,
    required this.emotionalValidation,
    required this.guidedAction,
    required this.sampleScript,
    required this.whatToAvoid,
  });
}
