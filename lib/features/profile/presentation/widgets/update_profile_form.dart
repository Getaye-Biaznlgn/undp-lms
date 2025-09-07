import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/utils/snackbar_utils.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/core/widgets/common_text_field.dart';
import 'package:lms/features/auth/data/models/user_profile_model.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';

class UpdateProfileForm extends StatefulWidget {
  final UserProfileModel userProfile;
  final VoidCallback onSuccess;
  final VoidCallback onError;

  const UpdateProfileForm({
    super.key,
    required this.userProfile,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _nameController.text = widget.userProfile.name;
    _phoneController.text = widget.userProfile.phone;
    _emailController.text = widget.userProfile.email;
    _ageController.text = widget.userProfile.age.toString();
    // Convert gender to match dropdown items (capitalize first letter)
    _selectedGender = widget.userProfile.gender.isNotEmpty 
        ? widget.userProfile.gender[0].toUpperCase() + widget.userProfile.gender.substring(1).toLowerCase()
        : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'gender': _selectedGender,
        'age': _ageController.text.trim(),
      };
      
      context.read<UserProfileBloc>().add(
        UpdateUserProfileEvent(profileData: profileData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileUpdatedState) {
          widget.onSuccess();
          SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
        } else if (state is UserProfileUpdateErrorState) {
          widget.onError();
          SnackbarUtils.showError(context, state.message);
        }
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [   
              // Name Field
              CommonTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter your name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              
              // Phone Field
              CommonTextField(
                controller: _phoneController,
                labelText: 'Phone',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              
              // Email Field
              CommonTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              
              // Gender Dropdown
              _buildGenderDropdown(),
              SizedBox(height: 16.h),
              
              // Age Field
              CommonTextField(
                controller: _ageController,
                labelText: 'Age',
                hintText: 'Enter your age',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              
              // Update Button
              BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  final isLoading = state is UserProfileUpdatingState;
                  
                  return SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      text: 'Update Profile',
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


  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: _selectedGender.isEmpty || !['Male', 'Female'].contains(_selectedGender) 
              ? null 
              : _selectedGender,
          decoration: InputDecoration(
            hintText: 'Select gender',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value ?? '';
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a gender';
            }
            return null;
          },
        ),
      ],
    );
  }
}
