class CourseModel {
  final String slug;
  final String title;
  final String thumbnail;
  final String price;
  final int discount;
  final Instructor instructor;
  final int students;
  final double averageRating;

  CourseModel({
    required this.slug,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.discount,
    required this.instructor,
    required this.students,
    required this.averageRating,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      price: json['price']?.toString() ?? '',
      discount: json['discount'] ?? 0,
      instructor: Instructor.fromJson(json['instructor'] ?? {}),
      students: json['students'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'discount': discount,
      'instructor': instructor.toJson(),
      'students': students,
      'average_rating': averageRating,
    };
  }
}

class Instructor {
  final int id;
  final String name;
  final String image;

  Instructor({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
