import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/router/app_router.dart';
import 'package:lms/core/constants/app_images.dart';
import 'package:lms/core/widgets/common_button.dart';
import 'package:lms/features/auth/domain/entities/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    const OnboardingSlide(
      id: '1',
      title: 'Welcome to UNDP',
      description: 'Discover a world of knowledge and unlock your potential with our curated courses.',
      imageUrl: AppImages.image1,
      color: AppTheme.primaryColor,
    ),
    const OnboardingSlide(
      id: '2',
      title: 'Learn at Your Pace',
      description: 'Access courses anytime, anywhere, and track your progress as you grow.',
      imageUrl: AppImages.image2,
      color: AppTheme.secondaryColor,
    ),
    const OnboardingSlide(
      id: '3',
      title: 'Showcase Your Skills',
      description: 'Complete courses to earn certificates and take your career to new heights.',
      imageUrl: AppImages.image3,
      color: AppTheme.accentColor,
    ),
  ];
List<Widget> cols= [];
  @override
  void initState() {
    super.initState();
   cols= [
  _buildSlide(_slides[0]),
  _buildSlide(_slides[1]),
  _buildSlide(_slides[2]),
];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() {
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _getStarted,
                   child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return cols[index];
                },
              ),
            ),
            
            // Bottom section with indicators and buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _slides[index].color
                              : AppTheme.borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Next/Get Started button
                  CommonButton(
                    text: _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                    onPressed: _nextPage,
                    type: ButtonType.primary,
                    size: ButtonSize.large,
                    customColor: _slides[_currentPage].color,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 280,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
        
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:  Image.asset(
                      slide.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            slide.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
