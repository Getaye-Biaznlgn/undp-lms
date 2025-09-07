class UserProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String image;
  final String jobTitle;
  final String shortBio;
  final String bio;
  final String gender;
  final int countryId;
  final String state;
  final String city;
  final String address;
  final String facebook;
  final String twitter;
  final String linkedin;
  final String website;
  final String github;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.image,
    required this.jobTitle,
    required this.shortBio,
    required this.bio,
    required this.gender,
    required this.countryId,
    required this.state,
    required this.city,
    required this.address,
    required this.facebook,
    required this.twitter,
    required this.linkedin,
    required this.website,
    required this.github,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      image: json['image'] ?? '',
      jobTitle: json['job_title'] ?? '',
      shortBio: json['short_bio'] ?? '',
      bio: json['bio'] ?? '',
      gender: json['gender'] ?? '',
      countryId: json['country_id'] ?? 0,
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      facebook: json['facebook'] ?? '',
      twitter: json['twitter'] ?? '',
      linkedin: json['linkedin'] ?? '',
      website: json['website'] ?? '',
      github: json['github'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'image': image,
      'job_title': jobTitle,
      'short_bio': shortBio,
      'bio': bio,
      'gender': gender,
      'country_id': countryId,
      'state': state,
      'city': city,
      'address': address,
      'facebook': facebook,
      'twitter': twitter,
      'linkedin': linkedin,
      'website': website,
      'github': github,
    };
  }
}

