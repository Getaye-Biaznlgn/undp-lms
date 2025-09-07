part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserProfileModel userProfile;

  const UserProfileLoadedState({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileErrorState extends UserProfileState {
  final String message;

  const UserProfileErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfileUpdatingState extends UserProfileState {}

class UserProfileUpdatedState extends UserProfileState {
 

  const UserProfileUpdatedState();

  @override
  List<Object> get props => [];
}

class UserProfileUpdateErrorState extends UserProfileState {
  final String message;

  const UserProfileUpdateErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfilePictureUpdatingState extends UserProfileState {}

class UserProfilePictureUpdatedState extends UserProfileState {
  const UserProfilePictureUpdatedState();

  @override
  List<Object> get props => [];
}

class UserProfilePictureUpdateErrorState extends UserProfileState {
  final String message;

  const UserProfilePictureUpdateErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfileBioUpdatingState extends UserProfileState {}

class UserProfileBioUpdatedState extends UserProfileState {
  const UserProfileBioUpdatedState();

  @override
  List<Object> get props => [];
}

class UserProfileBioUpdateErrorState extends UserProfileState {
  final String message;

  const UserProfileBioUpdateErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class UserProfilePasswordUpdatingState extends UserProfileState {}

class UserProfilePasswordUpdatedState extends UserProfileState {
  const UserProfilePasswordUpdatedState();

  @override
  List<Object> get props => [];
}

class UserProfilePasswordUpdateErrorState extends UserProfileState {
  final String message;

  const UserProfilePasswordUpdateErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

