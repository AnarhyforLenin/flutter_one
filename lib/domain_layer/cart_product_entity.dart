class CartProductEntity {
  int? productId;
  int? quantity;

  CartProductEntity({this.productId, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory CartProductEntity.fromMap(Map<String, dynamic> map) {
    return CartProductEntity(
      productId: map['product_id'],
      quantity: map['quantity'],
    );
  }
}