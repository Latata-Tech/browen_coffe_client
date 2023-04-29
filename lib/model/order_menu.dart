class OrderMenu {
  final String name, variant, thumbnail;
  final int quantity, price, id, discount;

  OrderMenu({
    required this.id,
    required this.thumbnail,
    required this.name,
    required this.price,
    required this.quantity,
    required this.variant,
    required this.discount
  });
}