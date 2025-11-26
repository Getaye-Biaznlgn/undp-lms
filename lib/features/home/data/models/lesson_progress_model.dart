class LessonProgressModel {
  final bool watched;
  final String percentage;
  final String currentTime;
  final bool isCompleted;
  final bool? isUnlocked;
  final String formattedWatchTime;
  final String formattedTotalDuration;

  LessonProgressModel({
    required this.watched,
    required this.percentage,
    required this.currentTime,
    required this.isCompleted,
    this.isUnlocked,
    required this.formattedWatchTime,
    required this.formattedTotalDuration,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      watched: json['watched'] ?? false,
      percentage: json['percentage'] ?? '0.00',
      currentTime: json['current_time'] ?? '0.00',
      isCompleted: json['is_completed'] ?? false,
      isUnlocked: json['is_unlocked'],
      formattedWatchTime: json['formatted_watch_time'] ?? '0:00',
      formattedTotalDuration: json['formatted_total_duration'] ?? '0:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watched': watched,
      'percentage': percentage,
      'current_time': currentTime,
      'is_completed': isCompleted,
      'is_unlocked': isUnlocked,
      'formatted_watch_time': formattedWatchTime,
      'formatted_total_duration': formattedTotalDuration,
    };
  }
}

class LessonProgressResponse {
  final bool success;
  final LessonProgressModel progress;

  LessonProgressResponse({
    required this.success,
    required this.progress,
  });

  factory LessonProgressResponse.fromJson(Map<String, dynamic> json) {
    return LessonProgressResponse(
      success: json['success'] ?? false,
      progress: LessonProgressModel.fromJson(json['progress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'progress': progress.toJson(),
    };
  }
}


