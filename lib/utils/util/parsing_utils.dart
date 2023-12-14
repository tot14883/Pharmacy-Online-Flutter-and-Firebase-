class ParsingUtils {
  static double parseDouble(String number) {
    return double.tryParse(number) ?? 0.0;
  }

  static int parseInt(dynamic number) {
    if (number is int) return number;
    if (number is String) return int.tryParse(number) ?? 0;

    return 0;
  }
}
