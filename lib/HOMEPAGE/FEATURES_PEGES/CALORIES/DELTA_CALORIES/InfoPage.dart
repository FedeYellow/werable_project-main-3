import 'package:flutter/material.dart';

class NutritionInfoPage extends StatelessWidget {
  const NutritionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutritional Status Explanation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF3E5F8A),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(20),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overnutrition',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Overnutrition occurs when calorie intake consistently exceeds the body\'s energy expenditure. '
                'This can lead to excess fat accumulation over time.\n',
              ),
              Text('Short-term effects:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Weight gain\n• Post-meal fatigue or sluggishness\n'),
              Text('Long-term effects:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Obesity\n• Type 2 diabetes\n• Cardiovascular diseases\n'),
              SizedBox(height: 20),

              Text(
                'Undernutrition',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Undernutrition happens when energy intake is consistently lower than what the body requires. '
                'It can lead to nutrient deficiencies and muscle loss.\n',
              ),
              Text('Short-term effects:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Fatigue and weakness\n• Difficulty concentrating\n'),
              Text('Long-term effects:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• Malnutrition\n• Osteoporosis\n• Hormonal imbalances\n'),
              SizedBox(height: 20),

              Text(
                'Balanced Weekly Meal Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 8),

              Text('Each day includes 3 balanced meal options (breakfast, lunch, dinner):\n'),

              Text(
                'Monday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Oatmeal with banana • Greek yogurt with berries • Whole grain toast with avocado'),
              Text('Lunch: Grilled chicken salad • Quinoa and veggies • Tuna sandwich with salad'),
              Text('Dinner: Baked salmon with broccoli • Stir-fried tofu with rice • Lentil soup with whole grain bread\n'),

              Text(
                'Tuesday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Smoothie with spinach and protein • Scrambled eggs with wholemeal toast • Cottage cheese with fruit'),
              Text('Lunch: Chickpea wrap • Grilled turkey with couscous • Veggie burrito bowl'),
              Text('Dinner: Chicken stir-fry with brown rice • Baked sweet potatoes with beans • Vegetable curry with rice\n'),

              Text(
                'Wednesday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Muesli with milk • Almond butter toast • Boiled eggs with tomatoes'),
              Text('Lunch: Turkey and hummus wrap • Rice with lentils and veggies • Grilled tofu salad'),
              Text('Dinner: Baked cod with greens • Whole wheat pasta with tomato sauce • Chicken soup with barley\n'),

              Text(
                'Thursday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Chia pudding with fruit • Peanut butter banana toast • Yogurt parfait'),
              Text('Lunch: Spinach and cheese omelette • Turkey sandwich with lettuce • Couscous salad with chickpeas'),
              Text('Dinner: Shrimp stir-fry • Vegetable lasagna • Beef stew with quinoa\n'),

              Text(
                'Friday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Protein pancakes • Fruit smoothie bowl • Hard-boiled eggs with toast'),
              Text('Lunch: Chicken Caesar salad • Tuna pasta • Roasted veggie wrap'),
              Text('Dinner: Grilled steak with sweet potato • Black bean tacos • Baked eggplant with rice\n'),

              Text(
                'Saturday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Avocado toast with egg • Yogurt with granola • Oatmeal with raisins'),
              Text('Lunch: Rice bowl with chicken • Vegetable quiche • Grilled sandwich with salad'),
              Text('Dinner: Pasta primavera • Turkey meatballs with rice • Stir-fried vegetables with noodles\n'),

              Text(
                'Sunday',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Breakfast: Smoothie with oats • Pancakes with fruit • Whole grain cereal with milk'),
              Text('Lunch: Grilled fish with salad • Lentil burger • Brown rice with chickpeas'),
              Text('Dinner: Chicken and veggie stir-fry • Spinach ravioli • Tomato soup with whole grain toast\n'),

              SizedBox(height: 20),
              Text(
                'Note:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Choose one option per meal per day. Stay hydrated and adjust portions based on your energy needs.'),
            ],
          ),
        ),
      ),
    );
  }
}
