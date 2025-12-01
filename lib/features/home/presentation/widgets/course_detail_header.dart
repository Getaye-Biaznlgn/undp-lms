import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/constants/api_routes.dart';
import 'package:lms/core/theme/app_theme.dart';
import 'package:lms/core/services/offline_storage_service.dart';
import 'package:lms/features/home/data/models/course_detail_model.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class CourseDetailHeader extends StatefulWidget {
  final CourseDetailModel courseDetail;
  final Function(String)? onVideoUrlChanged;
  final VoidCallback? onContentLoaded; // Callback when content finishes loading
  final String? courseId; // Course ID for offline file checking
  final String? lessonId; // Lesson ID for offline file checking

  const CourseDetailHeader({
    super.key,
    required this.courseDetail,
    this.onVideoUrlChanged,
    this.onContentLoaded,
    this.courseId,
    this.lessonId,
  });

  @override
  State<CourseDetailHeader> createState() => CourseDetailHeaderState();
}

class CourseDetailHeaderState extends State<CourseDetailHeader> {
  bool _isVideoPlaying = false;
  String? _videoId;
  String? _currentVideoUrl;
  bool _isYouTubeVideo = false;
  bool _isLocalFile = false; // Track if video is a local file
  double _startTime = 0.0; // Start time in seconds
  WebViewController? _webViewController;
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController; // For local file playback

  @override
  void initState() {
    super.initState();
    _extractVideoId();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _videoPlayerController?.dispose();
    _webViewController = null;
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

  void playVideo(String videoUrl, {String? storage, double startTime = 0.0, String? courseId, String? lessonId}) {
    if (mounted) {
      Logger().d('playVideo called - videoUrl: $videoUrl, storage: $storage, courseId: $courseId, lessonId: $lessonId');
      
      // Skip if it's a document type (PDFs not supported)
      if (storage == 'document' || storage == 'pdf') {
        Logger().d('Document type detected, skipping video player');
        if (widget.onContentLoaded != null) {
          widget.onContentLoaded!();
        }
        return;
      }
      
      // Check for offline file first
      String? finalVideoUrl = videoUrl;
      bool isOfflineFile = false;
      
      // Check if videoUrl is already a file:// URI or local file path
      if (videoUrl.startsWith('file://')) {
        // Extract actual file path from file:// URI
        final filePath = videoUrl.replaceFirst('file://', '');
        final file = File(filePath);
        if (file.existsSync()) {
          finalVideoUrl = filePath; // Use actual file path for video_player
          isOfflineFile = true;
          Logger().d('Using offline file from file:// URI: $finalVideoUrl');
        }
      } else if (courseId != null && lessonId != null) {
        // Try to get local file path from storage
        final downloadedLesson = OfflineStorageService.getDownloadedLesson(
          courseId: courseId,
          lessonId: lessonId,
        );
        
        if (downloadedLesson != null && downloadedLesson.status == 'completed') {
          final file = File(downloadedLesson.filePath);
          if (file.existsSync()) {
            // Use actual file path for video_player
            finalVideoUrl = downloadedLesson.filePath;
            isOfflineFile = true;
            Logger().d('Using offline file: $finalVideoUrl');
          }
        }
      }
      
      // Skip YouTube videos if offline (YouTube requires internet)
      if (isOfflineFile && (storage == 'external_link' || _isYouTubeUrl(finalVideoUrl))) {
        Logger().w('Cannot play YouTube videos offline');
        if (widget.onContentLoaded != null) {
          widget.onContentLoaded!();
        }
        return;
      }
      
      setState(() {
        _currentVideoUrl = finalVideoUrl;
        _startTime = startTime;
        _isVideoPlaying = false; // Reset to show thumbnail first
        _isLocalFile = isOfflineFile;
      });
      
      // For local files, initialize video_player
      if (isOfflineFile && finalVideoUrl.isNotEmpty) {
        _videoId = finalVideoUrl; // Store file path for video_player
        _isYouTubeVideo = false;
        _initializeLocalVideoPlayer(finalVideoUrl);
      } else {
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
      }
      
      Logger().d('After extractVideoId - _isYouTubeVideo: $_isYouTubeVideo, _isLocalFile: $_isLocalFile, _videoId: $_videoId');
      
      // Show video player if we have a valid video ID
      if (_videoId != null && _videoId!.isNotEmpty) {
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
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  Future<void> _initializeLocalVideoPlayer(String filePath) async {
    try {
      // Dispose previous controller if exists
      await _videoPlayerController?.dispose();
      
      // Create new controller for local file
      _videoPlayerController = VideoPlayerController.file(File(filePath));
      await _videoPlayerController!.initialize();
      
      // Ensure audio is enabled (volume = 1.0)
      await _videoPlayerController!.setVolume(1.0);
      
      // Seek to start time
      if (_startTime > 0) {
        await _videoPlayerController!.seekTo(Duration(seconds: _startTime.toInt()));
      }
      
      // Auto play
      await _videoPlayerController!.play();
      
      // Listen for player state changes
      _videoPlayerController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      
      if (mounted) {
        setState(() {});
      }
      
      Logger().d('Local video player initialized: $filePath');
      
      if (widget.onContentLoaded != null) {
        widget.onContentLoaded!();
      }
    } catch (e, stackTrace) {
      Logger().e('Error initializing local video player: $e', error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() {
          _isLocalFile = false; // Fallback to WebView if video_player fails
        });
      }
      if (widget.onContentLoaded != null) {
        widget.onContentLoaded!();
      }
    }
  }
  
  void _togglePlayPause() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
      } else {
        _videoPlayerController!.play();
      }
      setState(() {});
    }
  }


  Widget _buildVideoPlayer() {
    // Use video_player for local files
    if (_isLocalFile && _videoPlayerController != null) {
      if (_videoPlayerController!.value.isInitialized) {
        return GestureDetector(
          onTap: _togglePlayPause,
          child: AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoPlayerController!),
                // Play/Pause button overlay (always visible, semi-transparent when playing)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _videoPlayerController!.value.isPlaying ? 0.0 : 0.7,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Icon(
                            _videoPlayerController!.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Always visible play/pause button in bottom-left corner
                Positioned(
                  bottom: 50,
                  left: 16,
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _videoPlayerController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
                // Controls overlay at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress indicator with scrubbing (VideoProgressIndicator handles scrubbing automatically)
                        VideoProgressIndicator(
                          _videoPlayerController!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: AppTheme.primaryColor,
                            bufferedColor: AppTheme.primaryColor.withOpacity(0.5),
                            backgroundColor: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        // Time indicators
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(_videoPlayerController!.value.position),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                _formatDuration(_videoPlayerController!.value.duration),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
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
      } else {
        // Local file is loading
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }
    
    // Use YouTube player for YouTube videos
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
    }
    
    // Regular video files (network URLs or local files) using WebView
    if (_videoId != null && _videoId!.isNotEmpty) {
      // Escape the video URL for HTML
      final escapedVideoUrl = _videoId!.replaceAll("'", "\\'").replaceAll('"', '\\"');
      
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              Logger().d('WebView video loaded: $url');
              if (widget.onContentLoaded != null) {
                widget.onContentLoaded!();
              }
            },
            onWebResourceError: (WebResourceError error) {
              Logger().e('WebView video load error: ${error.description}, URL: ${_videoId}');
              if (widget.onContentLoaded != null) {
                widget.onContentLoaded!();
              }
            },
          ),
        )
        ..loadHtmlString('''
          <!DOCTYPE html>
          <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              * { margin: 0; padding: 0; box-sizing: border-box; }
              html, body { width: 100%; height: 100%; background: black; overflow: hidden; }
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
                playsinline
                webkit-playsinline
                src="$escapedVideoUrl">
                Your browser does not support the video tag.
              </video>
            </div>
            <script>
              var video = document.getElementById('videoPlayer');
              var startTime = $_startTime;
              
              function seekToStartTime() {
                if (video.readyState >= 2) { // HAVE_CURRENT_DATA
                  video.currentTime = startTime;
                  video.removeEventListener('loadedmetadata', seekToStartTime);
                  video.removeEventListener('canplay', seekToStartTime);
                }
              }
              
              video.addEventListener('loadedmetadata', seekToStartTime);
              video.addEventListener('canplay', seekToStartTime);
              video.addEventListener('loadeddata', function() {
                video.currentTime = startTime;
              });
              
              video.addEventListener('error', function(e) {
                console.error('Video load error:', video.error ? video.error.message : 'Unknown error');
                console.error('Video source:', video.src);
              });
              
              // Try to play when ready
              video.addEventListener('canplaythrough', function() {
                video.play().catch(function(err) {
                  console.error('Play error:', err);
                });
              });
            </script>
          </body>
          </html>
        ''');
      return WebViewWidget(controller: _webViewController!);
    }
    
    // Fallback: Show loading state
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
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
