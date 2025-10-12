import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/widgets/retry_button.dart';
import 'package:lms/features/home/presentation/bloc/quiz_bloc.dart';
import 'package:lms/features/home/presentation/bloc/quiz_event.dart';
import 'package:lms/features/home/presentation/bloc/quiz_state.dart';
import 'package:lms/features/home/data/models/quiz_detail_model.dart';
import 'package:lms/features/home/data/models/quiz_submission_result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizTakingPage extends StatefulWidget {
  final int quizId;
  final String quizTitle;

  const QuizTakingPage({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  final Map<int, int> _selectedAnswers = {}; // question_id -> answer_id
  int _currentQuestionIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(GetQuizDetailEvent(quizId: widget.quizId));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _remainingSeconds = minutes * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _submitQuiz();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // Get user ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 1;

    if (context.mounted) {
      context.read<QuizBloc>().add(
            SubmitQuizEvent(
              quizId: widget.quizId,
              userId: userId,
              answers: _selectedAnswers,
            ),
          );
    }
  }

  void _showSubmitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Submit Quiz?',
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to submit this quiz? You cannot change your answers after submission.',
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitQuiz();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: Text(
                'Submit',
                style: AppTheme.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit Quiz?',
              style: AppTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Your progress will be lost. Are you sure you want to exit?',
              style: AppTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppTheme.labelLarge,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                ),
                child: Text(
                  'Exit',
                  style: AppTheme.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            widget.quizTitle,
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Exit Quiz?',
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Your progress will be lost. Are you sure you want to exit?',
                    style: AppTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: AppTheme.labelLarge,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                      ),
                      child: Text(
                        'Exit',
                        style: AppTheme.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              if (shouldPop == true && context.mounted) {
                // Navigator.pop(context);
                Navigator.pop(context);
                if(context.canPop()){
                 Navigator.pop(context); 
                }
                
              }
            },
          ),
        ),
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizSubmittedState) {
              _timer?.cancel();
              setState(() {
                _isSubmitting = false;
              });
              _showResultDialog(context, state.result);
            } else if (state is QuizErrorState && _isSubmitting) {
              setState(() {
                _isSubmitting = false;
              });
            }
          },
          builder: (context, state) {
            // Show loading when initially loading quiz or when submitting
            if ((state is QuizLoadingState && !_isSubmitting) || _isSubmitting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                    if (_isSubmitting) ...[
                      SizedBox(height: 16.h),
                      Text(
                        'Submitting your quiz...',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            } else if (state is QuizDetailLoadedState) {
              if (_timer == null) {
                _startTimer(int.parse(state.quizDetail.quiz.time));
              }
              
              return _buildQuizContent(state.quizDetail);
            } else if (state is QuizErrorState) {
              return ErrorRetryWidget(
                title: state.message,
                onRetry: () {
                  context.read<QuizBloc>().add(GetQuizDetailEvent(quizId: widget.quizId));
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildQuizContent(QuizDetailModel quizDetail) {
    final quiz = quizDetail.quiz;
    final questions = quiz.questions;

    if (questions.isEmpty) {
      return const Center(
        child: Text('No questions available'),
      );
    }

    final currentQuestion = questions[_currentQuestionIndex];

    return Column(
      children: [
        // Timer and Progress Header
        Container(
          padding: EdgeInsets.all(16.w),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 20.w,
                        color: _remainingSeconds < 300 
                            ? AppTheme.errorColor 
                            : AppTheme.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: AppTheme.titleMedium.copyWith(
                          color: _remainingSeconds < 300 
                              ? AppTheme.errorColor 
                              : AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${questions.length}',
                    style: AppTheme.titleSmall.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questions.length,
                backgroundColor: AppTheme.dividerColor,
                color: AppTheme.primaryColor,
                minHeight: 6.h,
              ),
            ],
          ),
        ),

        // Question Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppTheme.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Answers
                Text(
                  'Select your answer:',
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
                ...currentQuestion.answers.asMap().entries.map((entry) {
                  final answer = entry.value;
                  final isSelected = _selectedAnswers[currentQuestion.id] == answer.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAnswers[currentQuestion.id] = answer.id;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1) 
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : AppTheme.borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                    ? AppTheme.primaryColor 
                                    : AppTheme.borderColor,
                                width: 2,
                              ),
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16.w,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              answer.text,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textPrimaryColor,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Navigation Buttons
        Container(
          padding: EdgeInsets.all(20.w),
          color: Colors.white,
          child: Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex--;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                    child: Text(
                      'Previous',
                      style: AppTheme.labelLarge.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              if (_currentQuestionIndex > 0) SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_currentQuestionIndex < questions.length - 1) {
                            setState(() {
                              _currentQuestionIndex++;
                            });
                          } else {
                            _showSubmitConfirmation(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _currentQuestionIndex < questions.length - 1 
                              ? 'Next' 
                              : 'Submit Quiz',
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
      ],
    );
  }

  void _showResultDialog(BuildContext context, QuizSubmissionResultModel result) {
    final percentage = result.percentage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.assignment_turned_in,
                      size: 50.w,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Result Title
                  Text(
                    'Quiz Submitted',
                    style: AppTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    'Your quiz has been submitted successfully',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Score Display
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildResultStat(
                              label: 'Your Score',
                              value: '${result.score}',
                              color: AppTheme.primaryColor,
                            ),
                            Container(
                              width: 1,
                              height: 50.h,
                              color: AppTheme.dividerColor,
                            ),
                            _buildResultStat(
                              label: 'Total Marks',
                              value: '${result.totalMark}',
                              color: AppTheme.secondaryColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Percentage: ',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: AppTheme.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext); // Close dialog
                            // Go back to course detail page (skip quiz list page)
                            // Navigator.popUntil(context, (route) => route.isFirst);
                            if(context.canPop()){
                              Navigator.pop(context);
                            }
                            if(context.canPop()){
                              Navigator.pop(context);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: const BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: AppTheme.labelLarge.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext); // Close dialog
                            // Go back to course detail page (skip quiz list page)
                            if(context.canPop()){
                              Navigator.pop(context);
                            }
                            if(context.canPop()){
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Done',
                            style: AppTheme.labelLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
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
}
