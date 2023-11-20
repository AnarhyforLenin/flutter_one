class Product {
  int? id;
  String? name;
  String? imageUrl;
  int? price;
  String? description;

  Product({this.id, this.name, this.imageUrl, this.price, this.description});

  Product.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "price": price,
        "description": description
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      description: map['description'],
    );
  }
}