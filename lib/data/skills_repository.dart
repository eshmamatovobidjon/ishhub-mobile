import '../models/skill.dart';
import '../services/api_client.dart';

class SkillsRepository {
  SkillsRepository(this._api);
  final ApiClient _api;

  Future<List<Skill>> list({String? category}) async {
    final r = await _api.get<List<dynamic>>(
      '/skills/',
      query: {if (category != null) 'category': category},
    );
    return (r.data ?? const [])
        .map((e) => Skill.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<UserSkill>> mine() async {
    final r = await _api.get<List<dynamic>>('/users/me/skills/');
    return (r.data ?? const [])
        .map((e) => UserSkill.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}
