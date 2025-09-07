import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/usecases/usecase.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/domain/usecases/get_user_profile_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  UserProfileModel? userProfile;

  UserProfileBloc({
    required this.getUserProfileUseCase,
  }) : super(UserProfileInitialState()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
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
}

