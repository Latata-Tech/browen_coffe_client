class OrderMenu {
  final String name, variant, thumbnail;
  final int quantity, price, id;

  OrderMenu({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.price,
    required this.quantity,
    required this.variant
  });
}