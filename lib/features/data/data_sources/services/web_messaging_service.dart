

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you need to access Firebase in background, initialize it:
  await Firebase.initializeApp();
  // if (kDebugMode) {
  //   print("Handling a background message: ${message.messageId}");
  // }
}

class WebMessagingService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Your VAPID key for Web Push (if applicable)
  static const String vapidKey = "BNEm1I08YMzK-ly_jXbmCCEeO_Dg5UofXg53U2OmUCD3V8Yu4fx74SzXgTgCMQQq9GLUlWp0r8pxDQmTK6NjcmA";
  
  static Function(RemoteMessage)? onMessageCallback;
  static Function(RemoteMessage)? onMessageOpenedAppCallback;

  // Define Android Notification Channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  /// Trigger a local notification manually (e.g., from ChatBloc)
  static void triggerLocalNotification(String title, String body, {Map<String, dynamic>? data}) {
    try {
      if (!kIsWeb) {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        _flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecond, // Unique ID
          title, 
          body, 
          platformChannelSpecifics,
          payload: data.toString(), 
        );
      } else {
        // Web notification logic could go here if needed, usually browser handles it if tab is background
        // if (kDebugMode) print("Local Notification Triggered (Web): $title - $body");
      }

      // Also trigger the callback if any listener is attached
      if (onMessageCallback != null) {
          final message = RemoteMessage(
            notification: RemoteNotification(title: title, body: body),
            data: data ?? {},
          );
          onMessageCallback!(message);
      }
    } catch (e) {
      // if (kDebugMode) print("Error triggering local notification: $e");
    }
  }

  static Future<void> initialize() async {
    try {
      // 1. Register Background Handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 2. Request Permissions
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // if (kDebugMode) {
      //   print('User permission status: ${settings.authorizationStatus}');
      // }

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        //  if (kDebugMode) print("User declined or has not accepted notification permission");
        return;
      }

      // 3. Initialize Local Notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
             requestAlertPermission: true,
             requestBadgePermission: true,
             requestSoundPermission: true,
          );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
            // if (kDebugMode) print("Notification Tapped with payload: ${response.payload}");
            // Handle notification tap logic here
        },
      );

      // Create Android Channel
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // 4. Foreground Notification Options (for iOS primarily)
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 5. Check for initial message (if app opened from terminated state)
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        if (onMessageOpenedAppCallback != null) {
          onMessageOpenedAppCallback!(initialMessage);
        }
        _handleMessageClick(initialMessage);
      }

      // 6. Listen for Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // if (kDebugMode) {
        //   print('Foreground Message Received: ${message.messageId}');
        //   if (message.notification != null) {
        //      print('Message Title: ${message.notification!.title}, Body: ${message.notification!.body}');
        //   }
        // }
        
        if (onMessageCallback != null) {
          onMessageCallback!(message);
        }
        _handleForegroundMessage(message);
      });

      // 7. Listen for Background Message Taps
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // if (kDebugMode) print("Notification Opened App");
        if (onMessageOpenedAppCallback != null) {
          onMessageOpenedAppCallback!(message);
        }
        _handleMessageClick(message);
      });

      // 8. Get Token
      // ignore: unused_local_variable
      String? token;
      if (kIsWeb) {
        token = await _fcm.getToken(vapidKey: vapidKey);
      } else {
        token = await _fcm.getToken();
      }
      // if (kDebugMode) print("FCM Token: $token");
      
      _fcm.onTokenRefresh.listen((newToken) {
        //  if (kDebugMode) print("FCM Token Refreshed: $newToken");
      });

    } catch (e) {
      // if (kDebugMode) print("Error initializing WebMessagingService: $e");
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Show local notification if the message comes with a notification payload
    // and we are capable of showing it (e.g., Android channel exists).
    if (notification != null && android != null && !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data.toString()
      );
    }
  }

  static void _handleMessageClick(RemoteMessage message) {
    //  if (kDebugMode) print("Handling Message Click for message: ${message.messageId}");
     // Add navigation logic if needed
  }

  static Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        return await _fcm.getToken(vapidKey: vapidKey);
      }
      return await _fcm.getToken();
    } catch (e) {
      // if (kDebugMode) print("Error getting token: $e");
      return null;
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      if (kIsWeb) {
        return;
      }
      await _fcm.subscribeToTopic(topic);
      // if (kDebugMode) print("Subscribed to topic: $topic");
    } catch (e) {
      // if (kDebugMode) print("Error subscribing to topic: $e");
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      if (kIsWeb) {
        return;
      }
      await _fcm.unsubscribeFromTopic(topic);
      //  if (kDebugMode) print("Unsubscribed from topic: $topic");
    } catch (e) {
        //  if (kDebugMode) print("Error unsubscribing from topic: $e");
    }
  }
}