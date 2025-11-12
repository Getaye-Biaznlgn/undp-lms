import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UrlLauncherUtils {
  /// Launches a URL in an external application.
  /// 
  /// Tries to launch with external application mode first,
  /// then falls back to platform default if that fails.
  /// 
  /// [url] - The URL string to launch
  /// [context] - Optional BuildContext to show error messages
  /// 
  /// Returns true if the URL was successfully launched, false otherwise.
  static Future<bool> launchUrl(
    String url, {
    BuildContext? context,
    url_launcher.LaunchMode mode = url_launcher.LaunchMode.externalApplication,
  }) async {
    try {
      final uri = Uri.parse(url);
      
      // Try to launch with the specified mode
      final launched = await url_launcher.launchUrl(
        uri,
        mode: mode,
      );
      
      if (launched) {
        return true;
      }
    } catch (e) {
      // If external application mode fails, try platform default
      try {
        final uri = Uri.parse(url);
        final launched = await url_launcher.launchUrl(
          uri,
          mode: url_launcher.LaunchMode.platformDefault,
        );
        
        if (launched) {
          return true;
        }
      } catch (e2) {
        debugPrint('Failed to launch URL: $url. Error: $e2');
        
        // Optionally show error message to user if context is provided
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open link. Please try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        return false;
      }
    }
    
    return false;
  }

  /// Launches a meeting URL (Zoom, Jitsi, Google Meet, etc.)
  /// 
  /// This is a convenience method specifically for meeting links.
  /// 
  /// [url] - The meeting URL to launch
  /// [context] - Optional BuildContext to show error messages
  static Future<bool> launchMeetingUrl(
    String url, {
    BuildContext? context,
  }) async {
    return await launchUrl(
      url,
      context: context,
      mode: url_launcher.LaunchMode.externalApplication,
    );
  }
}

