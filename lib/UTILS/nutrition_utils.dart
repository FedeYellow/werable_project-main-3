
  // Weight-for-age 
  String classifyWA(double weight, int ageInMonths) {
    if (ageInMonths <= 3) {
      if (weight < 4) return 'Low';
      if (weight <= 6) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 6) {
      if (weight < 6) return 'Low';
      if (weight <= 8) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 9) {
      if (weight < 8) return 'Low';
      if (weight <= 9) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 12) {
      if (weight < 9) return 'Low';
      if (weight <= 10) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 24) {
      if (weight < 10) return 'Low';
      if (weight <= 13) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 36) {
      if (weight < 12) return 'Low';
      if (weight <= 16) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 48) {
      if (weight < 14) return 'Low';
      if (weight <= 18.5) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths < 60) {
      if (weight < 16) return 'Low';
      if (weight <= 21) return 'Normal';
      return 'High';
    } 
    return 'Unknown';
  }

  // Height-for-age
  String classifyHA(double height, int ageInMonths) {
    if (ageInMonths <= 3) {
      if (height < 57) return 'Low';
      if (height <= 62) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 6) {
      if (height < 63) return 'Low';
      if (height <= 68) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 9) {
      if (height < 68) return 'Low';
      if (height <= 73) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 12) {
      if (height < 71) return 'Low';
      if (height <= 77) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 24) {
      if (height < 83) return 'Low';
      if (height <= 90) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 36) {
      if (height < 91) return 'Low';
      if (height <= 99) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths <= 48) {
      if (height < 97) return 'Low';
      if (height <= 107) return 'Normal';
      return 'High';
    } 
    else if (ageInMonths < 60) {
      if (height < 104) return 'Low';
      if (height <= 114) return 'Normal';
      return 'High';
    } 
    return 'Unknown';
  }
  

// Weight-for-height
String classifyWH(double weight, double height) {
  if (height <= 50) {
    if (weight < 3) return 'Low';
    if (weight <= 3.7) return 'Normal';
    return 'High';
  }
  else if (height <= 60) {
    if (weight < 5) return 'Low';
    if (weight <= 6.5) return 'Normal';
    return 'High';
  }
  else if (height <= 70) {
    if (weight < 7.5) return 'Low';
    if (weight <= 9) return 'Normal';
    return 'High';
  }
  else if (height <= 80) {
    if (weight < 9) return 'Low';
    if (weight <= 11) return 'Normal';
    return 'High';
  }
  else if (height <= 90) {
    if (weight < 11.5) return 'Low';
    if (weight <= 14) return 'Normal';
    return 'High';
  }
  else if (height <= 100) {
    if (weight < 13.5) return 'Low';
    if (weight <= 16.5) return 'Normal';
    return 'High';
  }
  else if (height <= 110) {
    if (weight < 16.5) return 'Low';
    if (weight <= 20) return 'Normal';
    return 'High';
  }
  else if (height <= 120) {
    if (weight < 21) return 'Low';
    if (weight <= 25.5) return 'Normal';
    return 'High';
  }
  return 'Unknown';
}

// Mid-Upper Arm Circumference - MUAC
String classifyMUAC(double muac) {
  if (muac < 11.5) return 'Severate acute malnutrition';
  else if (muac < 12.5) return 'Moderate acute malnutrition';
  else if (muac < 13.5) return 'Risk of acute malnutrition';
  return 'Normal nutritional status';
}
