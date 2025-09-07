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

