import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:lms/features/auth/domain/usecases/update_profile_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  UserProfileModel? userProfile;

  UserProfileBloc({
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(UserProfileInitialState()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    if(userProfile != null){
      emit(UserProfileLoadedState(userProfile: userProfile!));
      return;
    }
    emit(UserProfileLoadingState());
    
    final failureOrUserProfile = await getUserProfileUseCase(NoParams());
    
    failureOrUserProfile.fold(
      (failure) => emit(UserProfileErrorState(message: failure.message)),
      (profile) {
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


}

