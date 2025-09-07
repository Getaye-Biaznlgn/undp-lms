import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/services/localstorage_service.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/common_app_bar.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/dependency_injection.dart';
import 'package:lms/features/auth/presentation/bloc/user_profile_bloc.dart';
import 'package:lms/features/profile/presentation/widgets/update_profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user profile when page loads
    
    return Scaffold(
      appBar: const WhiteAppBar(
        title: 'Profile',
      ),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          final userProfile = sl<UserProfileBloc>().userProfile;
          if ( userProfile==null && state is UserProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                // color: AppTheme.accentColor,
              ),
            );
          } else if ( userProfile==null && state is UserProfileErrorState) {
            return Center(
              child: ErrorRetryWidget(
                title: state.message,
                onRetry: () {
                  context.read<UserProfileBloc>().add(const GetUserProfileEvent());
                },
              ),
            );
          } else if (userProfile!=null) {
            return _buildProfileContent(context,userProfile);
          }
          
          return const Center(
            child: Text('No profile data available'),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, userProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(userProfile),
          const SizedBox(height: 24),
          
          
          // Account Section
          _buildAccountSection(context, userProfile),
          const SizedBox(height: 24),
          
          // Help and Support Section
          _buildHelpSupportSection(),
          const SizedBox(height: 32),
          
          // Logout Button
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(userProfile) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      // padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppTheme.accentColor.withOpacity(0.1),
            backgroundImage: userProfile.image.isNotEmpty
                ? NetworkImage('${ApiRoutes.imageUrl}${userProfile.image}')
                : null,
            child: userProfile.image.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.accentColor,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            userProfile.name,
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          
          // Email
          Text(
            userProfile.email,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _buildAccountSection(BuildContext context, userProfile) {
    return _buildSection(
      title: 'Account',
      items: [
        _buildListItem(
          title: 'Edit Profile',
          onTap: () {
            _showUpdateProfileModal(context, userProfile);
          },
        ),
        _buildListItem(
          title: 'Account Setting',
          onTap: () {
            // Handle account settings
          },
        ),
      ],
    );
  }

  Widget _buildHelpSupportSection() {
    return _buildSection(
      title: 'Help and Support',
      items: [
        _buildListItem(
          title: 'About UNDP LMS',
          onTap: () {
            // Handle about
          },
        ),
        _buildListItem(
          title: 'Frequently Asked Questions',
          onTap: () {
            // Handle FAQ
          },
        ),
        _buildListItem(
          title: 'Terms and Conditions',
          onTap: () {
            // Handle terms
          },
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              title,
              style: AppTheme.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Container(
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
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              AppPreferences().clear();
              context.go(AppRouter.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.errorColor,
              side: BorderSide(color: AppTheme.errorColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
    );
  }

  void _showUpdateProfileModal(BuildContext context, userProfile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                  const Spacer(),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance the close button
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: UpdateProfileForm(
                  userProfile: userProfile,
                  onSuccess: () {
                    Navigator.pop(context);
                    // Refresh the profile data
                    // context.read<UserProfileBloc>().add(const GetUserProfileEvent());
                  },
                  onError: () {
                   Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
