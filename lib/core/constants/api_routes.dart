class ApiRoutes{

     static const String apiUrl = "https://front.dololoet.com/api";
     static const String imageUrl = "https://front.dololoet.com";
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
  }