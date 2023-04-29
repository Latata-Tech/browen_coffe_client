class Menu {
  final int id, hotPrice, coldPrice, categoryId, promoIcePrice, promoHotPrice;
  final String name, photo;
  Menu(this.id, this.name, this.photo, this.hotPrice, this.coldPrice, this.categoryId, this.promoHotPrice, this.promoIcePrice);

  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price'], json['category_id'], json['promo_hot_price'], json['promo_ice_price']);
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(json['id'], json['name'], json['photo'], json['hot_price'], json['ice_price'], json['category_id'], json['promo_hot_price'], json['promo_ice_price']);
  }
}