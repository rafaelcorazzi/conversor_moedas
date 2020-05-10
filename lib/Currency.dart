class Currency{


  String name;
  double price;

  Currency(this.name, this.price);

  factory Currency.fromJson(dynamic json){
    return Currency(json['name'], json['buy']);
  }
}