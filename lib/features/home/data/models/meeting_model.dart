class MeetingListModel {
  final int currentPage;
  final List<MeetingModel> meetings;
  final int total;
  final int perPage;
  final int lastPage;

  MeetingListModel({
    required this.currentPage,
    required this.meetings,
    required this.total,
    required this.perPage,
    required this.lastPage,
  });

  factory MeetingListModel.fromJson(Map<String, dynamic> json) {
    return MeetingListModel(
      currentPage: json['current_page'] ?? 1,
      meetings: (json['data'] as List<dynamic>?)
              ?.map((meeting) => MeetingModel.fromJson(meeting))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 20,
      lastPage: json['last_page'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': meetings.map((meeting) => meeting.toJson()).toList(),
      'total': total,
      'per_page': perPage,
      'last_page': lastPage,
    };
  }
}

class MeetingModel {
  final int id;
  final String courseId;
  final String? lessonId;
  final String title;
  final String type;
  final String startTime;
  final String meetingType;
  final String description;
  final String timezone;
  final String maxParticipants;
  final bool isRecurring;
  final String? recurringPattern;
  final bool hasGroupChat;
  final String? chatRoomId;
  final String? notificationSettings;
  final String? reminderSentAt;
  final String status;
  final String duration;
  final Map<String, dynamic>? metadata;
  final String meetingId;
  final String? password;
  final String joinUrl;
  final String? googleEventId;
  final String? googleMeetingId;
  final String? googleHtmlLink;
  final String? googleAttendees;
  final String createdAt;
  final String updatedAt;

  MeetingModel({
    required this.id,
    required this.courseId,
    this.lessonId,
    required this.title,
    required this.type,
    required this.startTime,
    required this.meetingType,
    required this.description,
    required this.timezone,
    required this.maxParticipants,
    required this.isRecurring,
    this.recurringPattern,
    required this.hasGroupChat,
    this.chatRoomId,
    this.notificationSettings,
    this.reminderSentAt,
    required this.status,
    required this.duration,
    this.metadata,
    required this.meetingId,
    this.password,
    required this.joinUrl,
    this.googleEventId,
    this.googleMeetingId,
    this.googleHtmlLink,
    this.googleAttendees,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'] ?? 0,
      courseId: json['course_id']?.toString() ?? '',
      lessonId: json['lesson_id']?.toString(),
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      meetingType: json['meeting_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? '',
      maxParticipants: json['max_participants']?.toString() ?? '',
      isRecurring: json['is_recurring'] ?? false,
      recurringPattern: json['recurring_pattern']?.toString(),
      hasGroupChat: json['has_group_chat'] ?? false,
      chatRoomId: json['chat_room_id']?.toString(),
      notificationSettings: json['notification_settings']?.toString(),
      reminderSentAt: json['reminder_sent_at']?.toString(),
      status: json['status']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      metadata: json['metadata'] as Map<String, dynamic>?,
      meetingId: json['meeting_id']?.toString() ?? '',
      password: json['password']?.toString(),
      joinUrl: json['join_url']?.toString() ?? '',
      googleEventId: json['google_event_id']?.toString(),
      googleMeetingId: json['google_meeting_id']?.toString(),
      googleHtmlLink: json['google_html_link']?.toString(),
      googleAttendees: json['google_attendees']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'lesson_id': lessonId,
      'title': title,
      'type': type,
      'start_time': startTime,
      'meeting_type': meetingType,
      'description': description,
      'timezone': timezone,
      'max_participants': maxParticipants,
      'is_recurring': isRecurring,
      'recurring_pattern': recurringPattern,
      'has_group_chat': hasGroupChat,
      'chat_room_id': chatRoomId,
      'notification_settings': notificationSettings,
      'reminder_sent_at': reminderSentAt,
      'status': status,
      'duration': duration,
      'metadata': metadata,
      'meeting_id': meetingId,
      'password': password,
      'join_url': joinUrl,
      'google_event_id': googleEventId,
      'google_meeting_id': googleMeetingId,
      'google_html_link': googleHtmlLink,
      'google_attendees': googleAttendees,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

