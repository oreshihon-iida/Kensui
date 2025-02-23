class WeightCalculationService {
  /// 総重量を計算する
  /// [bodyWeight] ユーザーの体重 (kg)
  /// [repetitions] 懸垂の回数
  /// 返り値: 総重量 (kg)
  static double calculateTotalWeight(double bodyWeight, int repetitions) {
    return bodyWeight * repetitions;
  }

  /// 1セットあたりの平均重量を計算する
  /// [totalWeight] 総重量 (kg)
  /// [sets] セット数
  /// 返り値: 1セットあたりの平均重量 (kg)
  static double calculateAverageWeightPerSet(double totalWeight, int sets) {
    if (sets <= 0) throw ArgumentError('セット数は1以上である必要があります');
    return totalWeight / sets;
  }
}
