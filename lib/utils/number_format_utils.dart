String formatNumberWithCommas(String input) {
  List<String> parts = input.split('.');
  String integerPart = parts[0];
  String decimalPart = parts.length > 1 ? ".${parts[1]}" : "";

  int length = integerPart.length;
  int commaCount = (length - 1) ~/ 3;

  String result = "";

  for (int i = 0; i < length; i++) {
    result += integerPart[i];
    if ((length - i - 1) % 3 == 0 && commaCount > 0) {
      result += ",";
      commaCount--;
    }
  }
  return result + decimalPart;
}