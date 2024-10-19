

class Items {
  List<Item> inventory;
  List<Item> customItems;

  Items({
    required this.inventory,
    required this.customItems,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      inventory: (json['inventory'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList() ?? [], // Default to an empty list if null
      customItems: (json['customItems'] as List<dynamic>?)
          ?.map((item) => Item.fromJson(item))
          .toList() ?? [], // Default to an empty list if null
    );
  }
}





class Item {
  String name;
  Meta meta;
  int qty;

  Item({required this.name, required this.meta, required this.qty});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? 'Unknown', // Fallback in case name is null
      meta: Meta.fromJson(json['meta']),
      qty: json['qty'] ?? 0, // Fallback in case qty is null
    );
  }
}

class Meta {
  String selectType;

  Meta({required this.selectType});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      selectType: json['selectType'] ?? 'N/A', // Fallback in case selectType is null
    );
  }
}



