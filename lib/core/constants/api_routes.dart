class ApiRoutes{

     static const String apiUrl = "https://test.dololoet.com/api";
     static const String imageUrl = "https://test.dololoet.com";
     static const String socketUrl = "http://93.127.203.113:6002";
     static const String todos="/todos";
     static const String register="/register";
     static const String signup="/register";
     static const String login="/login";
     static const String forgetPassword="/forget-password";
     static const String resetPassword="/reset-password";
     static const String profile="/profile";
     static const String popularCourses="/popular-courses";
     static const String freshCourses="/fresh-courses";
     static const String courseMainCategories="/course-main-categories";
     static const String coursesByCategory="/courses-by-category/{slug}";
     
    static const String searchCourses= "/search-courses?search={search}";
    static const String courseDetails="/course/{slug}";

    static const String enrolledCourses="/enrolled-courses";
    static const String updateProfile="/update-profile";
    static const String updateProfilePicture="/update-profile-picture"; // ATTACH FIEL AS 'image' key
    static const String changePassword="/update-password";
    static const String updateBio="/update-bio"; // help us to update bio, short_bio and job_title

  //quize
    static const String quizeByCourseId = "/course-quizzes/{course_id}";
    static const String quizeByCourseAndChapter = "/quiz-bundle/quizzes/{course_id}/{chapter_id}";
    static const String quizeDetail = "/quiz-bundle/{quizeId}";
    static const String quizeSubmit= "/quiz-bundle/{quizeId}/submit";
    static const String quizeResult = "/quiz-bundle/results/{userId}"; //TODO GET ALL QUEIZE RESULTS
  
// Review
    static const String courseReviews = "/course/reviews/{courseSlug}"; //BOTH GET AND POST


  // meeting (Lives Sessions)
  static const String allMeetings = "/meetings/all";
  static const String meetingsByCourse = "/meetings/by-course?course_id={course_id}";
  static const String meetingsByUser = "/meetings/by-user?user_id={user_id}";


  }