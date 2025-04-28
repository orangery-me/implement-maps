import 'dart:math';

extension DoubleExtension on double {
  double roundToDecimalPlace(int decimalPlace) =>
      (this * pow(10, decimalPlace)).round().toDouble() / pow(10, decimalPlace);
}
