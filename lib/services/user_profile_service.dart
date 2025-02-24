import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  final SharedPreferences _prefs;
  static const String _bodyWeightKey = 'body_weight';

  UserProfileService(this._prefs);

  Future<void> saveBodyWeight(int weight) async {
    await _prefs.setInt(_bodyWeightKey, weight);
  }

  int? getBodyWeight() {
    return _prefs.getInt(_bodyWeightKey);
  }
}
