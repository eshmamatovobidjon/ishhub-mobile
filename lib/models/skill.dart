class Skill {
  final String id;
  final String slug;
  final String category;
  final String name;
  final String nameUz;
  final String nameRu;
  final String nameEn;

  const Skill({
    required this.id,
    required this.slug,
    required this.category,
    required this.name,
    required this.nameUz,
    required this.nameRu,
    required this.nameEn,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'] as String,
        slug: json['slug'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        name: json['name'] as String? ?? json['name_en'] as String? ?? '',
        nameUz: json['name_uz'] as String? ?? '',
        nameRu: json['name_ru'] as String? ?? '',
        nameEn: json['name_en'] as String? ?? '',
      );
}

class UserSkill {
  final String id;
  final Skill skill;
  final int selfRatedLevel;
  final bool verified;

  const UserSkill({
    required this.id,
    required this.skill,
    required this.selfRatedLevel,
    required this.verified,
  });

  factory UserSkill.fromJson(Map<String, dynamic> json) => UserSkill(
        id: json['id'] as String,
        skill: Skill.fromJson(json['skill'] as Map<String, dynamic>),
        selfRatedLevel: json['self_rated_level'] as int? ?? 2,
        verified: json['verified'] as bool? ?? false,
      );
}
