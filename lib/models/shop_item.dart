class ShopItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final bool isUnlocked;

  ShopItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.isUnlocked,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    bool? isUnlocked,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'is_unlocked': isUnlocked ? 1 : 0,
    };
  }

  factory ShopItem.fromMap(Map<String, dynamic> map) {
    return ShopItem(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      isUnlocked: (map['is_unlocked'] as int) == 1,
    );
  }
}
