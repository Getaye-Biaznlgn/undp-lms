import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CourseDetailHeader extends StatefulWidget {
  final CourseDetailModel courseDetail;

  const CourseDetailHeader({
    super.key,
    required this.courseDetail,
  });

  @override
  State<CourseDetailHeader> createState() => _CourseDetailHeaderState();
}

class _CourseDetailHeaderState extends State<CourseDetailHeader> {
  bool _isVideoPlaying = false;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _extractVideoId();
  }

  void _extractVideoId() {
    if (widget.courseDetail.demoVideo.isNotEmpty) {
      // Handle different YouTube URL formats
      String videoUrl = widget.courseDetail.demoVideo;
      
      // Extract video ID from embed URL (e.g., https://www.youtube.com/embed/MHhIzIgFgJo?rel=0)
      if (videoUrl.contains('/embed/')) {
        final embedMatch = RegExp(r'/embed/([a-zA-Z0-9_-]+)').firstMatch(videoUrl);
        if (embedMatch != null) {
          _videoId = embedMatch.group(1);
        }
      }
      // Extract from regular YouTube URL (e.g., https://www.youtube.com/watch?v=MHhIzIgFgJo)
      else if (videoUrl.contains('youtube.com/watch')) {
        final uri = Uri.parse(videoUrl);
        _videoId = uri.queryParameters['v'];
      }
      // Extract from youtu.be URL (e.g., https://youtu.be/MHhIzIgFgJo)
      else if (videoUrl.contains('youtu.be/')) {
        final uri = Uri.parse(videoUrl);
        _videoId = uri.pathSegments.first;
      }
      // Extract from regular YouTube URL (e.g., https://www.youtube.com/watch?v=MHhIzIgFgJo)
      else if (videoUrl.contains('youtube.com')) {
        final uri = Uri.parse(videoUrl);
        _videoId = uri.queryParameters['v'];
      }
    }
  }

  void _toggleVideo() {
    if (_videoId != null) {
      setState(() {
        _isVideoPlaying = !_isVideoPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        child: _isVideoPlaying && _videoId != null
            ? Stack(
                children: [
                  // YouTube Player using WebView
                  WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadHtmlString('''
                        <!DOCTYPE html>
                        <html>
                        <head>
                          <meta name="viewport" content="width=device-width, initial-scale=1.0">
                          <style>
                            body { margin: 0; padding: 0; background: black; }
                            .video-container { 
                              position: relative; 
                              width: 100%; 
                              height: 100vh; 
                              display: flex; 
                              align-items: center; 
                              justify-content: center; 
                            }
                            iframe { 
                              width: 100%; 
                              height: 100%; 
                              border: none; 
                            }
                          </style>
                        </head>
                        <body>
                          <div class="video-container">
                            <iframe 
                              src="https://www.youtube.com/embed/${_videoId}?autoplay=1&rel=0&modestbranding=1" 
                              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                              allowfullscreen>
                            </iframe>
                          </div>
                        </body>
                        </html>
                      '''),
                  ),
                  // Close button
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVideoPlaying = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  // Course Thumbnail
                  Positioned.fill(
                    child: widget.courseDetail.thumbnail.isNotEmpty
                      ? Image.network(
                          '${ApiRoutes.imageUrl}${widget.courseDetail.thumbnail}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.school,
                                color: Colors.white,
                                size: 60,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                  ),
                  // Dark overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                  // Play button overlay
                  Positioned.fill(
                    child: Center(
                      child: GestureDetector(
                        onTap: _videoId != null ? _toggleVideo : null,
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: _videoId != null 
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey.withOpacity(0.6),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _videoId != null ? Icons.play_arrow : Icons.play_disabled,
                            size: 40.w,
                            color: _videoId != null 
                              ? AppTheme.primaryColor
                              : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Company logo overlay (top left)
                  Positioned(
                    top: 60.h,
                    left: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 16.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'LMS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
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
}
