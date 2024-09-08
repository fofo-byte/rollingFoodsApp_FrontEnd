enum Foodtype {
  FAST_FOOD,
  MEXICAN,
  ITALIAN,
  CHINESE,
  JAPANESE,
  INDIAN,
  MEDITERRANEAN,
  AMERICAN,
  FRENCH,
  SPANISH,
  GREEK,
  GERMAN,
  KOREAN,
  THAI,
  VIETNAMESE,
  TURKISH,
}

String foodTypeToJson(Foodtype foodType) {
  return foodType.toString().split('.').last;
}

Foodtype foodTypeFromJson(String foodType) {
  return Foodtype.values
      .firstWhere((element) => element.toString().split('.').last == foodType);
}
