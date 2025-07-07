int calculateAgeInYears(DateTime birthDate) {
  final today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

int calculateAgeInMonths(DateTime birthDate) {
  final today = DateTime.now();
  return (today.year - birthDate.year) * 12 + (today.month - birthDate.month);
}

String formatAge(DateTime birthDate) {
  final years = calculateAgeInYears(birthDate);
  final months = calculateAgeInMonths(birthDate);
  if (years <= 2) {
    return "$months months";
  } else {
    return "$years years";
  }
}
