// ignore_for_file: empty_catches

import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WebMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  
  // Your VAPID key from Firebase Console
  static const String vapidKey = "BNEm1I08YMzK-ly_jXbmCCEeO_Dg5UofXg53U2OmUCD3V8Yu4fx74SzXgTgCMQQq9GLUlWp0r8pxDQmTK6NjcmA";
  
  // Callback for when notification is received in foreground
  static Function(RemoteMessage)? onMessageCallback;
  static Function(RemoteMessage)? onMessageOpenedAppCallback;
  
  static void triggerLocalNotification(String title, String body, {Map<String, dynamic>? data}) {
    if (onMessageCallback != null) {
      try {
        final message = RemoteMessage(
          notification: RemoteNotification(title: title, body: body),
          data: data ?? {},
        );
        onMessageCallback!(message);
      } catch (e) {
      }
    }
  }

  static Future<void> initialize() async {
    try {

      // Request notification permission
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      } else {
        return;
      }

      // Set foreground notification presentation
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        
        if (onMessageCallback != null) {
          onMessageCallback!(message);
        }
        _handleForegroundMessage(message);
      });

      // Handle when notification is clicked and app is opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (onMessageOpenedAppCallback != null) {
          onMessageOpenedAppCallback!(message);
        }
        _handleMessageClick(message);
      });

      // Get FCM token with VAPID key for web
      // ignore: unused_local_variable
      String? token;
      if (kIsWeb) {
        token = await _fcm.getToken(vapidKey: vapidKey);
      } else {
        token = await _fcm.getToken();
      }
      
      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        // Save new token to your backend
      });

    } catch (e) {
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
  }

  static void _handleMessageClick(RemoteMessage message) {
    
    // Handle navigation based on notification type
    // Example:
    // if (message.data['type'] == 'order') {
    //   // Navigate to order detail page
    // }
  }

  static Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        return await _fcm.getToken(vapidKey: vapidKey);
      }
      return await _fcm.getToken();
    } catch (e) {
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {

      await _fcm.subscribeToTopic(topic);
    } catch (e) {
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {

      await _fcm.unsubscribeFromTopic(topic);
    } catch (e) {
    }
  }
}