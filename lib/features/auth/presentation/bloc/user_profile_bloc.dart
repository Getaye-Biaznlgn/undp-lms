import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_profile_picture_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  UserProfileModel? userProfile;

  UserProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
    required this.updateProfilePictureUseCase,
  }) : super(UserProfileInitialState()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateUserProfilePictureEvent>(_onUpdateUserProfilePicture);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    // If we have cached profile and not forcing refresh, return cached data
    if(userProfile != null && !event.forceRefresh){
      emit(UserProfileLoadedState(userProfile: userProfile!));
      return;
    }
    
    Logger().i('UserProfileBloc: Fetching user profile (forceRefresh: ${event.forceRefresh})');
    emit(UserProfileLoadingState());
    
    final failureOrUserProfile = await getUserProfileUseCase(NoParams());
    
    failureOrUserProfile.fold(
      (failure) {
        Logger().e('UserProfileBloc: Failed to fetch user profile: ${failure.message}');
        emit(UserProfileErrorState(message: failure.message));
      },
      (profile) {
        Logger().i('UserProfileBloc: User profile fetched successfully');
        userProfile = profile;
        emit(UserProfileLoadedState(userProfile: profile));
      },
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileUpdatingState());
    
    final failureOrUpdateResult = await updateProfileUseCase(UpdateProfileParams(profileData: event.profileData));
    
    failureOrUpdateResult.fold(
      (failure) => emit(UserProfileUpdateErrorState(message: failure.message)),
      (updateResult) {
        emit(UserProfileUpdatedState());
        add(GetUserProfileEvent(forceRefresh: true));
      },
    );
  }

  Future<void> _onUpdateUserProfilePicture(
    UpdateUserProfilePictureEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    Logger().i('UserProfileBloc: Starting profile picture update for file: ${event.imageFile.path}');
    emit(UserProfilePictureUpdatingState());
    
    final failureOrUpdateResult = await updateProfilePictureUseCase(UpdateProfilePictureParams(imageFile: event.imageFile));
    
    failureOrUpdateResult.fold(
      (failure) {
        Logger().e('UserProfileBloc: Profile picture update failed: ${failure.message}');
        emit(UserProfilePictureUpdateErrorState(message: failure.message));
      },
      (updateResult) {
        Logger().i('UserProfileBloc: Profile picture update successful, refreshing profile data');
        emit(UserProfilePictureUpdatedState());
        add(GetUserProfileEvent(forceRefresh: true));
      },
    );
  }
}

