import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/utils/url_launcher_utils.dart';
import 'package:lms/features/home/presentation/bloc/meeting_bloc.dart';
import 'package:lms/features/home/presentation/bloc/meeting_event.dart';
import 'package:lms/features/home/presentation/bloc/meeting_state.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';
import 'package:intl/intl.dart';

class CourseMeetingsWidget extends StatelessWidget {
  final String courseId;

  const CourseMeetingsWidget({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state is MeetingLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MeetingsLoadedState) {
          if (state.meetingList.meetings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_call,
                    size: 60.w,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No live sessions available',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'There are no scheduled meetings for this course',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: state.meetingList.meetings.length,
            itemBuilder: (context, index) {
              final meeting = state.meetingList.meetings[index];
              return _buildMeetingCard(context, meeting);
            },
          );
        } else if (state is MeetingErrorState) {
          return Center(
            child: ErrorRetryWidget(
              title: state.message,
              onRetry: () {
                context.read<MeetingBloc>().add(
                      GetMeetingsByCourseIdEvent(courseId: courseId),
                    );
              },
            ),
          );
        }

        return Center(
          child: Text(
            'No live sessions available',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeetingCard(BuildContext context, MeetingModel meeting) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getMeetingTypeColor(meeting.meetingType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    meeting.meetingType.toUpperCase(),
                    style: AppTheme.labelSmall.copyWith(
                      color: _getMeetingTypeColor(meeting.meetingType),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (meeting.status.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(meeting.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      meeting.status.toUpperCase(),
                      style: AppTheme.labelSmall.copyWith(
                        color: _getStatusColor(meeting.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              meeting.title,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            if (meeting.description.isNotEmpty)
              Text(
                meeting.description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.w,
                  color: AppTheme.textSecondaryColor,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    _formatDateTime(meeting.startTime),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
                if (meeting.duration.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.timer,
                    size: 16.w,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${meeting.duration} min',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => UrlLauncherUtils.launchMeetingUrl(
                  meeting.joinUrl,
                  context: context,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_call,
                      size: 20.w,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Join Meeting',
                      style: AppTheme.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMeetingTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'zoom':
        return Colors.blue;
      case 'jitsi':
        return Colors.purple;
      case 'google_meet':
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'live':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formatter = DateFormat('MMM dd, yyyy • HH:mm');
      return formatter.format(dateTime.toLocal());
    } catch (e) {
      return dateTimeString;
    }
  }
}



