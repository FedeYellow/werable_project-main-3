
class NutritionEvaluator {
  // Conclusion based on various growth indicators.
  static String Conclusion({
    required String waStatus,
    required String haStatus,
    required String whStatus,
    required String muacStatus,
  }) {
    final hasMuac = !muacStatus.startsWith('No data');

    if (waStatus == 'Low' && haStatus == 'Low' && whStatus == 'Low' || (hasMuac && muacStatus.contains('Severe'))) {
      return 'These parameters suggest the child is experiencing severe acute malnutrition with possible chronic stunting.';
    }

    if (waStatus == 'Low' && (haStatus == 'Normal' || haStatus == 'High') || (hasMuac && muacStatus.contains('Moderate'))) {
      return 'These parameters suggest the child is experiencing moderate acute malnutrition without evidence of chronic growth delay.';
    }

    if (waStatus == 'Normal' && haStatus == 'Low' && whStatus == 'Normal') {
      return 'Low height for age with normal weight for height. Further evaluation is advised to rule out chronic malnutrition.';
    }

    if (waStatus == 'Normal' && haStatus == 'Low' && whStatus == 'High') {
      return 'Short stature with high weight for height suggests risk of overweight.';
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low') {
      return 'Normal growth parameters by age, but relatively low weight for height suggests recent or ongoing weight loss.';
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low') {
      return 'Normal growth parameters by age, but low weight for height indicates risk of malnutrition.';
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low' && (hasMuac && muacStatus.contains('Risk'))) {
      return 'Normal growth parameters by age, but low weight for height and MUAC indicate risk of acute malnutrition.';
    }

    if (waStatus == 'High' && whStatus == 'High' && (haStatus == 'Low' || haStatus == 'Normal')) {
      return 'Elevated weight for age and weight for height may indicate overweight.';
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'High') {
      return 'Elevated parameters suggest a large but proportionate growth pattern. Monitor for excess weight gain to prevent overweight.';
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'Normal') {
      return 'Although weight and height for age are high, the child shows a healthy growth pattern with no evidence of overweight.';
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'Low') {
      return 'These parameters suggests possible recent nutritional deficit.';
    }

    return 'Growth parameters within normal ranges.';
  }
   

  // Recommendations based on the child’s nutritional profile.
  static String Recommendations({
    required String waStatus,
    required String haStatus,
    required String whStatus,
    required String muacStatus,
  }) {
    final hasMuac = !muacStatus.startsWith('No data');

    if (waStatus == 'Low' && haStatus == 'Low' && whStatus == 'Low' || (hasMuac && muacStatus.contains('Severe'))) {
      return [
        '• Immediate referral to a therapeutic feeding program.',
        '• Initiate therapeutic feeding (e.g., F-75/F-100 or ready-to-use therapeutic foods).',
        '• Daily monitoring of weight, MUAC, and hydration status.',
        '• Evaluate for possible infections or other complications.'
      ].join('\n');
    }

    if (waStatus == 'Low' && (haStatus == 'Normal' || haStatus == 'High') || (hasMuac && muacStatus.contains('Moderate'))) {
      return [
        '• Provide fortified supplementary foods.',
        '• Feed every 3–4 hours with small frequent meals.',
        '• Weekly monitoring of weight and MUAC.',
        '• Educate caregivers on balanced child nutrition.'
      ].join('\n');
    }

    if (waStatus == 'Normal' && haStatus == 'Low' && whStatus == 'Normal') {
      return [
        '• Investigate possible causes of stunting (e.g., recurrent infections, poor diet).',
        '• Provide diverse, micronutrient-rich foods.',
        '• Promote hygiene and sanitation to reduce infections.',
        '• Schedule routine growth monitoring.'
      ].join('\n');
    }

    if (waStatus == 'Normal' && haStatus == 'Low' && whStatus == 'High') {
      return [
        '• Review dietary intake to reduce energy-dense, low-nutrient foods.',
        '• Encourage active play and daily movement.',
        '• Schedule regular weight monitoring.',
        '• Counsel caregivers on portion sizes appropriate for age.'
      ].join('\n');
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low') {
      return [
        '• Investigate recent illnesses or feeding difficulties.',
        '• Increase energy-dense and protein-rich foods.',
        '• Monitor growth every 2 weeks.',
        '• Provide feeding support to caregivers.'
      ].join('\n');
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low') {
      return [
        '• Provide nutrition counseling to improve dietary intake.',
        '• Increase meal frequency with diverse foods.',
        '• Monitor growth monthly.',
        '• Screen for parasites or infections.'
      ].join('\n');
    }

    if (waStatus == 'Normal' && haStatus == 'Normal' && whStatus == 'Low' && (hasMuac && muacStatus.contains('Risk'))) {
      return [
        '• Start targeted supplementary feeding.',
        '• Increase meal frequency and energy density.',
        '• Weekly monitoring of weight and MUAC.',
        '• Educate caregivers on recognizing danger signs.'
      ].join('\n');
    }

    if (waStatus == 'High' && whStatus == 'High' && (haStatus == 'Low' || haStatus == 'Normal')) {
      return [
        '• Reduce consumption of sugary snacks and beverages.',
        '• Encourage at least 60 minutes of active play daily.',
        '• Increase intake of vegetables and fruits.',
        '• Schedule weight checks every month.'
      ].join('\n');
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'High') {
      return [
        '• Maintain a balanced, age-appropriate diet.',
        '• Encourage daily active play.',
        '• Monitor growth every 3–6 months.',
        '• Advise caregivers to limit ultra-processed foods.'
      ].join('\n');
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'Normal') {
      return [
        '• Maintain balanced nutrition with adequate variety.',
        '• Continue daily active play.',
        '• Monitor growth routinely (every 3–6 months).',
        '• Reassure caregivers about proportional growth.'
      ].join('\n');
    }

    if (waStatus == 'High' && haStatus == 'High' && whStatus == 'Low') {
      return [
        '• Investigate recent illness or poor food intake.',
        '• Support recovery with high-quality proteins and energy-rich foods.',
        '• Monitor growth every 2 weeks.',
        '• Reinforce caregiver feeding practices.'
      ].join('\n');
    }

    return [
      '• Maintain a balanced diet with varied foods.',
      '• Promote active play every day (60 minutes).',
      '• Growth monitoring every 3–6 months.',
    ].join('\n');
  
  }
}
