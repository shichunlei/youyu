///tab公用模型
class TabModel<T> {
  TabModel(
      {required this.name,
      required this.id,
      this.children,
      this.customExtra,
      this.image});

  final int id;
  final String name;
  List<TabModel>? children;
  T? customExtra;
  String? image;

  static TabModel fromJson(Map<String, dynamic> json) {
    bool hasChildren = false;
    if (json.keys.contains('children')) {
      hasChildren = true;
    }
    return TabModel(
        id: json['id'] as int,
        name: json['name'] as String,
        image: json['image'] as String?,
        children: hasChildren
            ? (json['children'] as List<dynamic>)
                .map((e) => TabModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : []);
  }
}
