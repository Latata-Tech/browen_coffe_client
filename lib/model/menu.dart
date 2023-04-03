class Menu {
  final int id, hotPrice, coldPrice;
  final String name, photo;
  Menu(this.id, this.name, this.photo, this.hotPrice, this.coldPrice);

  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price']);
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price']);
  }
}