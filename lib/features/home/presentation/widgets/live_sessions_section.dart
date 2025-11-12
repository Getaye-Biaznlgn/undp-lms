import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/features/home/presentation/bloc/meeting_bloc.dart';
import 'package:lms/features/home/presentation/bloc/meeting_event.dart';
import 'package:lms/features/home/presentation/bloc/meeting_state.dart';
import 'package:lms/features/home/data/models/meeting_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class LiveSessionsSection extends StatelessWidget {
  const LiveSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Live Sessions',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(AppRouter.meetingsList);
              },
              child: Text(
                'See All',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<MeetingBloc, MeetingState>(
          builder: (context, state) {
            if (state is MeetingLoadingState) {
              return  LoadingWidget(
                height: 200.h,
                message: 'Loading live sessions...',
              );
            } else if (state is MeetingsLoadedState) {
              if (state.meetingList.meetings.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'No live sessions available',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 200.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.meetingList.meetings.length,
                  itemBuilder: (context, index) {
                    final meeting = state.meetingList.meetings[index];
                    return _buildMeetingCard(context, meeting);
                  },
                ),
              );
            } else if (state is MeetingErrorState) {
              return ErrorRetryWidget(
                title: state.message,
                onRetry: () {
                  context.read<MeetingBloc>().add(const GetAllMeetingsEvent());
                },
                height: 200,
              );
            }
            
            return SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'No live sessions available',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMeetingCard(BuildContext context, MeetingModel meeting) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getMeetingTypeColor(meeting.meetingType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      meeting.meetingType.toUpperCase(),
                      style: AppTheme.labelSmall.copyWith(
                        color: _getMeetingTypeColor(meeting.meetingType),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (meeting.status.isNotEmpty)
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(meeting.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        meeting.status.toUpperCase(),
                        style: AppTheme.labelSmall.copyWith(
                          color: _getStatusColor(meeting.status),
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              meeting.title,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (meeting.description.isNotEmpty)
              Text(
                meeting.description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _formatDateTime(meeting.startTime),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
        
           SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _launchMeetingUrl(meeting.joinUrl),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('Join Meeting'),
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

  Future<void> _launchMeetingUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

