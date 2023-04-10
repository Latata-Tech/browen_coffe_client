class Menu {
  final int id, hotPrice, coldPrice, categoryId;
  final String name, photo;
  Menu(this.id, this.name, this.photo, this.hotPrice, this.coldPrice, this.categoryId);

  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price'], json['category_id']);
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price'], json['category_id']);
  }
}