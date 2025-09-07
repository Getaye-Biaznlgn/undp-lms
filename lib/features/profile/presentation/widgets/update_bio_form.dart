import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/utils/snackbar_utils.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/core/widgets/common_text_field.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';

class UpdateBioForm extends StatefulWidget {
  final UserProfileModel userProfile;
  final VoidCallback onSuccess;
  final VoidCallback onError;

  const UpdateBioForm({
    super.key,
    required this.userProfile,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<UpdateBioForm> createState() => _UpdateBioFormState();
}

class _UpdateBioFormState extends State<UpdateBioForm> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _shortBioController = TextEditingController();
  final _jobTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _shortBioController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    _bioController.text = widget.userProfile.bio;
    _shortBioController.text = widget.userProfile.shortBio;
    _jobTitleController.text = widget.userProfile.jobTitle;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final bioData = {
        'bio': _bioController.text.trim(),
        'short_bio': _shortBioController.text.trim(),
        'job_title': _jobTitleController.text.trim(),
      };

      context.read<UserProfileBloc>().add(
        UpdateUserBioEvent(bioData: bioData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileBioUpdatedState) {
          widget.onSuccess();
          SnackbarUtils.showSuccess(context, 'Bio updated successfully!');
        } else if (state is UserProfileBioUpdateErrorState) {
          widget.onError();
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bio Field
              CommonTextField(
                controller: _bioController,
                labelText: 'Bio',
                hintText: 'Tell us about yourself',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Bio is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Short Bio Field
              CommonTextField(
                controller: _shortBioController,
                labelText: 'Short Bio',
                hintText: 'Brief description about yourself',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Short bio is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Job Title Field
              CommonTextField(
                controller: _jobTitleController,
                labelText: 'Job Title',
                hintText: 'Your current job title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Job title is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),

              // Update Button
              BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  final isLoading = state is UserProfileBioUpdatingState;

                  return SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      text: 'Update Bio',
                      onPressed: isLoading ? null : _submitForm,
                      isLoading: isLoading,
                      customColor: AppTheme.primaryColor,
                      customTextColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
