/// Firebase service for OBuddy.
/// Shares the existing obubba-d9ccc Firebase project.
/// All OBuddy data lives under obuddy_* prefixed collections.
class FirebaseService {
  // Firebase config — shared with OBubba
  static const projectId = 'obubba-d9ccc';
  static const apiKey = 'AIzaSyCdHzmheQRbtzP_JI1FuWcZLeW8yVja5-0';

  // Firestore collection paths (prefixed to avoid collision with OBubba)
  static const familiesCollection = 'obuddy_families';
  static const childrenSubcollection = 'children';
  static const partnersSubcollection = 'partners';
  static const pathsSubcollection = 'paths';
  static const dailySubcollection = 'daily';
  static const incidentsSubcollection = 'incidents';
  static const temperamentSubcollection = 'temperament';

  // OBubba collections (for migration detection)
  static const obubbaFamiliesCollection = 'families';
  static const obubbaChildrenSubcollection = 'children';

  /// Get the full path for a child document.
  static String childPath(String uid, String childId) =>
      '$familiesCollection/$uid/$childrenSubcollection/$childId';

  /// Get the full path for a child's path progress.
  static String pathProgressPath(String uid, String childId, String pathId) =>
      '${childPath(uid, childId)}/$pathsSubcollection/$pathId';

  /// Get the full path for a daily entry.
  static String dailyPath(String uid, String childId, String date) =>
      '${childPath(uid, childId)}/$dailySubcollection/$date';

  /// Get the full path for a partner document.
  static String partnerPath(String uid, String partnerId) =>
      '$familiesCollection/$uid/$partnersSubcollection/$partnerId';

  /// Get the full path for a child's temperament history.
  static String temperamentPath(String uid, String childId) =>
      '${childPath(uid, childId)}/$temperamentSubcollection/current';

  /// Check for existing OBubba data (migration detection).
  static String obubbaFamilyPath(String uid) =>
      '$obubbaFamiliesCollection/$uid';
}
