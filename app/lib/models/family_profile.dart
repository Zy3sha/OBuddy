/// Family profile model — supports multi-child and partner sync.
///
/// Firebase structure:
///   obuddy_families/{uid}
///     → children/{childId}
///     → partners/{partnerId}
class FamilyProfile {
  final String id;
  final String primaryUserId;
  final String? primaryUserName;
  final List<PartnerProfile> partners;
  final List<String> childIds;
  final String? activeChildId;
  final bool migratedFromOBubba;
  final DateTime createdAt;

  const FamilyProfile({
    required this.id,
    required this.primaryUserId,
    this.primaryUserName,
    this.partners = const [],
    this.childIds = const [],
    this.activeChildId,
    this.migratedFromOBubba = false,
    required this.createdAt,
  });

  FamilyProfile copyWith({
    String? primaryUserName,
    List<PartnerProfile>? partners,
    List<String>? childIds,
    String? activeChildId,
    bool? migratedFromOBubba,
  }) {
    return FamilyProfile(
      id: id,
      primaryUserId: primaryUserId,
      primaryUserName: primaryUserName ?? this.primaryUserName,
      partners: partners ?? this.partners,
      childIds: childIds ?? this.childIds,
      activeChildId: activeChildId ?? this.activeChildId,
      migratedFromOBubba: migratedFromOBubba ?? this.migratedFromOBubba,
      createdAt: createdAt,
    );
  }
}

/// A partner (co-parent, nanny, grandparent) linked to the family.
class PartnerProfile {
  final String id;
  final String name;
  final String role; // 'co-parent', 'grandparent', 'nanny', 'other'
  final String? email;
  final String status; // 'invited', 'active', 'removed'
  final DateTime invitedAt;

  const PartnerProfile({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.status = 'invited',
    required this.invitedAt,
  });
}
