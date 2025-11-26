import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailHeader extends StatefulWidget {
  final CourseDetailModel courseDetail;
  final Function(String)? onVideoUrlChanged;

  const CourseDetailHeader({
    super.key,
    required this.courseDetail,
    this.onVideoUrlChanged,
  });

  @override
  State<CourseDetailHeader> createState() => CourseDetailHeaderState();
}

class CourseDetailHeaderState extends State<CourseDetailHeader> {
  bool _isVideoPlaying = false;
  String? _videoId;
  String? _currentVideoUrl;
  bool _isYouTubeVideo = false;
  double _startTime = 0.0; // Start time in seconds
  WebViewController? _webViewController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _extractVideoId();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  void _extractVideoId({String? storage}) {
    String videoUrl = _currentVideoUrl ?? widget.courseDetail.demoVideo;
    
    if (videoUrl.isNotEmpty) {
      // Check both storage field and URL to determine if it's YouTube
      _isYouTubeVideo = (storage == 'external_link') || _isYouTubeUrl(videoUrl);
      
      if (_isYouTubeVideo) {
        // Extract video ID from different YouTube URL formats
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
      } else {
        // For direct video URLs, use the URL directly
        _videoId = videoUrl;
      }
    }
  }

  void playVideo(String videoUrl, {String? storage, double startTime = 0.0}) {
    if (mounted) {
      setState(() {
        _currentVideoUrl = videoUrl;
        _startTime = startTime;
        _isVideoPlaying = false; // Reset to show thumbnail first
      });
      _extractVideoId(storage: storage);
      
      // Initialize YouTube player controller if it's a YouTube video
      if (_isYouTubeVideo && _videoId != null) {
        _youtubeController?.dispose(); // Dispose previous controller
        _youtubeController = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            startAt: startTime.toInt(),
            mute: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );
      }
      
      if (_videoId != null) {
        setState(() {
          _isVideoPlaying = true;
        });
      }
    }
  }

  @override
  void didUpdateWidget(CourseDetailHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onVideoUrlChanged != oldWidget.onVideoUrlChanged) {
      // If callback changes, we might need to update
    }
  }

  void _toggleVideo() {
    if (_videoId != null) {
      setState(() {
        _isVideoPlaying = !_isVideoPlaying;
      });
    }
  }

  Widget _buildVideoPlayer() {
    if (_isYouTubeVideo && _videoId != null) {
      // Initialize controller if not already initialized
      if (_youtubeController == null || _youtubeController!.initialVideoId != _videoId) {
        _youtubeController?.dispose();
        _youtubeController = YoutubePlayerController(
          initialVideoId: _videoId!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            startAt: _startTime.toInt(),
            mute: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        );
      }
      
      // Use youtube_player_flutter for YouTube videos
      return YoutubePlayerBuilder(
        onExitFullScreen: () {
          // Handle exit fullscreen if needed
        },
        player: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppTheme.primaryColor,
          progressColors: ProgressBarColors(
            playedColor: AppTheme.primaryColor,
            handleColor: AppTheme.primaryColor,
          ),
        ),
        builder: (context, player) {
          return player;
        },
      );
    } else {
      _webViewController = WebViewController()
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
              video { 
                width: 100%; 
                height: 100%; 
                object-fit: contain;
              }
            </style>
          </head>
          <body>
            <div class="video-container">
              <video 
                id="videoPlayer"
                controls 
                autoplay
                src="${_videoId}">
                Your browser does not support the video tag.
              </video>
            </div>
            <script>
              var video = document.getElementById('videoPlayer');
              video.currentTime = $_startTime;
              video.addEventListener('loadedmetadata', function() {
                video.currentTime = $_startTime;
              });
            </script>
          </body>
          </html>
        ''');
      return WebViewWidget(controller: _webViewController!);
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
                  // Video Player using WebView
                  _buildVideoPlayer(),
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
                 
                ],
              ),
      ),
    );
  }
}
