import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/skill.dart';
import 'repositories.dart';

final skillsCatalogProvider = FutureProvider.autoDispose<List<Skill>>((ref) {
  return ref.watch(skillsRepositoryProvider).list();
});

final mySkillsProvider = FutureProvider.autoDispose<List<UserSkill>>((ref) {
  return ref.watch(skillsRepositoryProvider).mine();
});
