class Product {
  final String name;
  final String price;
  final String expiry;
  final String? shopperName;
  final int calories;

  Product({
    required this.name,
    required this.price,
    required this.expiry,
    required this.shopperName,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'calories': calories,
    'shopperName': shopperName,
    'expiry': expiry,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'],
    price: json['price'],
    calories: json['calories'],
    shopperName: json['shopperName'],
    expiry: json['expiry'],
  );

}
