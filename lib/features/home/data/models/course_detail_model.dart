class CourseDetailModel {
  final String demoVideoSource;
  final String demoVideo;
  final String thumbnail;
  final bool isWishlist;
  final String title;
  final String slug;
  final Instructor instructor;
  final double averageRating;
  final int reviewsCount;
  final int students;
  final String lastUpdated;
  final String duration;
  final bool certificate;
  final int lessonsCount;
  final int quizzesCount;
  final String languages;
  final String price;
  final int discount;
  final String description;
  final List<Curriculum> curriculums;

  CourseDetailModel({
    required this.demoVideoSource,
    required this.demoVideo,
    required this.thumbnail,
    required this.isWishlist,
    required this.title,
    required this.slug,
    required this.instructor,
    required this.averageRating,
    required this.reviewsCount,
    required this.students,
    required this.lastUpdated,
    required this.duration,
    required this.certificate,
    required this.lessonsCount,
    required this.quizzesCount,
    required this.languages,
    required this.price,
    required this.discount,
    required this.description,
    required this.curriculums,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      demoVideoSource: json['demo_video_source'] ?? '',
      demoVideo: json['demo_video'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      isWishlist: json['is_wishlist'] ?? false,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      instructor: Instructor.fromJson(json['instructor'] ?? {}),
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      students: json['students'] ?? 0,
      lastUpdated: json['last_updated'] ?? '',
      duration: json['duration'] ?? '',
      certificate: json['certificate'] ?? false,
      lessonsCount: json['lessons_count'] ?? 0,
      quizzesCount: json['quizzes_count'] ?? 0,
      languages: json['languages'] ?? '',
      price: json['price']?.toString() ?? '',
      discount: json['discount'] ?? 0,
      description: json['description'] ?? '',
      curriculums: (json['curriculums'] as List<dynamic>?)
          ?.map((curriculum) => Curriculum.fromJson(curriculum))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'demo_video_source': demoVideoSource,
      'demo_video': demoVideo,
      'thumbnail': thumbnail,
      'is_wishlist': isWishlist,
      'title': title,
      'slug': slug,
      'instructor': instructor.toJson(),
      'average_rating': averageRating,
      'reviews_count': reviewsCount,
      'students': students,
      'last_updated': lastUpdated,
      'duration': duration,
      'certificate': certificate,
      'lessons_count': lessonsCount,
      'quizzes_count': quizzesCount,
      'languages': languages,
      'price': price,
      'discount': discount,
      'description': description,
      'curriculums': curriculums.map((curriculum) => curriculum.toJson()).toList(),
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

class Curriculum {
  final int id;
  final String title;
  final List<Chapter> chapters;

  Curriculum({
    required this.id,
    required this.title,
    required this.chapters,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) {
    return Curriculum(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((chapter) => Chapter.fromJson(chapter))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
    };
  }
}

class Chapter {
  final String type;
  final ChapterItem item;

  Chapter({
    required this.type,
    required this.item,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      type: json['type'] ?? '',
      item: ChapterItem.fromJson(json['item'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'item': item.toJson(),
    };
  }
}

class ChapterItem {
  final int id;
  final String title;
  final String? fileType;
  final String? duration;
  final bool? isFree;

  ChapterItem({
    required this.id,
    required this.title,
    this.fileType,
    this.duration,
    this.isFree,
  });

  factory ChapterItem.fromJson(Map<String, dynamic> json) {
    return ChapterItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      fileType: json['file_type'],
      duration: json['duration'],
      isFree: json['is_free'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_type': fileType,
      'duration': duration,
      'is_free': isFree,
    };
  }
}

