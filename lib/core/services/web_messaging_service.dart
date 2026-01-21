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
        print('Error triggering local notification: $e');
      }
    }
  }

  static Future<void> initialize() async {
    try {
      print('🔄 Initializing Firebase Messaging...');

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
        print('✅ User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('⚠️ User granted provisional permission');
      } else {
        print('❌ User declined or has not yet granted permission');
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
        print('📬 Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        
        if (onMessageCallback != null) {
          onMessageCallback!(message);
        }
        _handleForegroundMessage(message);
      });

      // Handle when notification is clicked and app is opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('👆 Message clicked!');
        if (onMessageOpenedAppCallback != null) {
          onMessageOpenedAppCallback!(message);
        }
        _handleMessageClick(message);
      });

      // Get FCM token with VAPID key for web
      String? token;
      if (kIsWeb) {
        token = await _fcm.getToken(vapidKey: vapidKey);
      } else {
        token = await _fcm.getToken();
      }
      print('📱 FCM Token: $token');
      
      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        print('🔄 Token refreshed: $newToken');
        // Save new token to your backend
      });

    } catch (e) {
      print('❌ Error initializing Firebase Messaging: $e');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  static void _handleMessageClick(RemoteMessage message) {
    print('Message data type: ${message.data['type']}');
    
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
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {

      await _fcm.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {

      await _fcm.unsubscribeFromTopic(topic);
      print('❌ Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }
}