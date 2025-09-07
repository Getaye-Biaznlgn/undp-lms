part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfileEvent extends UserProfileEvent {
  final bool forceRefresh;

  const GetUserProfileEvent({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final Map<String, dynamic> profileData;

  const UpdateUserProfileEvent({
    required this.profileData,
  });

  @override
  List<Object> get props => [profileData];
}

class UpdateUserProfilePictureEvent extends UserProfileEvent {
  final File imageFile;

  const UpdateUserProfilePictureEvent({
    required this.imageFile,
  });

  @override
  List<Object> get props => [imageFile];
}

class UpdateUserBioEvent extends UserProfileEvent {
  final Map<String, dynamic> bioData;

  const UpdateUserBioEvent({
    required this.bioData,
  });

  @override
  List<Object> get props => [bioData];
}

class UpdateUserPasswordEvent extends UserProfileEvent {
  final Map<String, dynamic> passwordData;

  const UpdateUserPasswordEvent({
    required this.passwordData,
  });

  @override
  List<Object> get props => [passwordData];
}

