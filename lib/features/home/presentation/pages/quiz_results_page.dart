import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/features/home/presentation/bloc/quiz_bloc.dart';
import 'package:lms/features/home/presentation/bloc/quiz_event.dart';
import 'package:lms/features/home/presentation/bloc/quiz_state.dart';
import 'package:lms/features/home/data/models/quiz_result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultsPage extends StatefulWidget {
  const QuizResultsPage({super.key});

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 1;
    if (mounted) {
      context.read<QuizBloc>().add(GetQuizResultsEvent(userId: userId));
    }
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
          'Quiz Results',
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
          } else if (state is QuizResultsLoadedState) {
            if (state.results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      size: 60.w,
                      color: AppTheme.textSecondaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No quiz results yet',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Take a quiz to see your results here',
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
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                return _buildResultCard(state.results[index]);
              },
            );
          } else if (state is QuizErrorState) {
            return ErrorRetryWidget(
              title: state.message,
              onRetry: _loadResults,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildResultCard(QuizResultModel result) {
    final isPassed = result.status == 'passed';
    final passMark = int.tryParse(result.quiz.passMark) ?? 0;
    final totalMark = int.tryParse(result.quiz.totalMark) ?? 100;
    final percentage = totalMark > 0 ? (result.userGrade / totalMark * 100).toStringAsFixed(1) : '0';

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Title
            Text(
              result.quiz.title,
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: 12.h),

            // Status Badge
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isPassed 
                        ? AppTheme.successColor.withOpacity(0.1) 
                        : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPassed ? Icons.check_circle : Icons.cancel,
                        size: 16.w,
                        color: isPassed 
                            ? AppTheme.successColor 
                            : AppTheme.errorColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        result.status.toUpperCase(),
                        style: AppTheme.bodySmall.copyWith(
                          color: isPassed 
                              ? AppTheme.successColor 
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Score Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreItem(
                    label: 'Your Score',
                    value: '${result.userGrade}',
                    color: AppTheme.primaryColor,
                  ),
                  Container(
                    width: 1,
                    height: 40.h,
                    color: AppTheme.dividerColor,
                  ),
                  _buildScoreItem(
                    label: 'Percentage',
                    value: '$percentage%',
                    color: AppTheme.secondaryColor,
                  ),
                  Container(
                    width: 1,
                    height: 40.h,
                    color: AppTheme.dividerColor,
                  ),
                  _buildScoreItem(
                    label: 'Total',
                    value: '$totalMark',
                    color: AppTheme.accentColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Pass Mark Info
            Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 16.w,
                  color: AppTheme.textSecondaryColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Pass mark: $passMark%',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  'Taken on ${_formatDate(result.createdAt)}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
