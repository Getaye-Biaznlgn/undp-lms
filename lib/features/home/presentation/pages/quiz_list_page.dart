import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/features/home/presentation/bloc/quiz_bloc.dart';
import 'package:lms/features/home/presentation/bloc/quiz_event.dart';
import 'package:lms/features/home/presentation/bloc/quiz_state.dart';
import 'package:lms/features/home/presentation/pages/quiz_taking_page.dart';
import 'package:lms/features/home/data/models/quiz_model.dart';

class QuizListPage extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const QuizListPage({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(GetQuizzesByCourseIdEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Course Quizzes',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          } else if (state is QuizListLoadedState) {
            if (state.quizzes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 60.w,
                      color: AppTheme.textSecondaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No quizzes available',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: state.quizzes.length,
              itemBuilder: (context, index) {
                return _buildQuizCard(context, state.quizzes[index]);
              },
            );
          } else if (state is QuizErrorState) {
            return ErrorRetryWidget(
              title: state.message,
              onRetry: () {
                context.read<QuizBloc>().add(GetQuizzesByCourseIdEvent(courseId: widget.courseId));
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizModel quiz) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizTakingPage(
                quizId: quiz.id,
                quizTitle: quiz.title,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quiz Title
              Text(
                quiz.title,
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              SizedBox(height: 12.h),

              // Quiz Info
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.timer,
                    label: '${quiz.time} min',
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  _buildInfoChip(
                    icon: Icons.star,
                    label: 'Pass: ${quiz.passMark}%',
                    color: AppTheme.secondaryColor,
                  ),
                  SizedBox(width: 8.w),
                  _buildInfoChip(
                    icon: Icons.assignment,
                    label: '${quiz.totalMark} marks',
                    color: AppTheme.accentColor,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Attempts
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 16.w,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${quiz.attempt} attempt(s) allowed',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: quiz.status == 'active' 
                          ? Colors.green.withOpacity(0.1) 
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      quiz.status.toUpperCase(),
                      style: AppTheme.bodySmall.copyWith(
                        color: quiz.status == 'active' 
                            ? Colors.green 
                            : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Take Quiz Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizTakingPage(
                          quizId: quiz.id,
                          quizTitle: quiz.title,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Take Quiz',
                    style: AppTheme.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.w,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
