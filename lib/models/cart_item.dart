class CartItem {
  final String id;              // ID do produto
  final String name;            // Nome do produto
  final double price;           // Preço unitário (já com adicionais!)
  final String? imageUrl;       // URL da imagem
  final int quantity;           // Quantidade
  final List<Map<String, dynamic>> addons; // Adicionais escolhidos
  final String restaurantId;    // ID do restaurante (importante!)
  final String? restaurantName; // Nome do restaurante

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
    this.addons = const [],
    required this.restaurantId,
    this.restaurantName,
  });

  // 💰 Preço total (preço × quantidade)
  double get totalPrice => price * quantity;

  // 📝 Descrição dos adicionais
  String get addonsDescription {
    if (addons.isEmpty) return '';
    return addons.map((a) => a['name']).join(', ');
  }

  // 🔄 Criar cópia com quantidade alterada
  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      addons: addons,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );
  }

  // Conversão para JSON (para API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit_price': price,
    };
  }
}
