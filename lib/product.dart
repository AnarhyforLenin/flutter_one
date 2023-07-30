
class Product {
  int? id;
  String? name;
  String? imageUrl;
  int? price;
  String? description;

  Product({this.id, this.name,  this.imageUrl,  this.price,  this.description});

  Product.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    price = json['price'];
    description = json['description'];
  }
}