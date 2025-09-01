class CategoryModel {
  final String slug;
  final String name;
  final String icon;
  final bool showAtTrending;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.icon,
    required this.showAtTrending,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      showAtTrending: json['show_at_trending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'icon': icon,
      'show_at_trending': showAtTrending,
    };
  }
}

