import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> migrateChats({bool dryRun = true}) async {
    debugPrint('Starting Migration (Dry Run: \$dryRun)...');
    
    final chatsSnapshot = await _firestore.collection('chats').get();
    int processed = 0;
    int updated = 0;
    int errors = 0;

    for (final doc in chatsSnapshot.docs) {
      processed++;
      final data = doc.data();
      final chatId = doc.id;
      
      try {
        Map<String, dynamic> updates = {};
        bool needsUpdate = false;

        // 1. Check Participants
        if (!data.containsKey('participants') || data['participants'] == null) {
           final userId = data['userId'] ?? '';
           if (userId.isNotEmpty) {
             updates['participants'] = [userId, 'admin'];
             needsUpdate = true;
             // debugPrint('[\$chatId] Needs participants array. Setting [\$userId, admin]');
           }
        }

        // 2. Check Order/Product ID (Try to infer from messages if missing)
        if (!data.containsKey('orderId') && !data.containsKey('productId')) {
           // Fetch last 5 messages to check for orderId
           final messagesSnap = await _firestore
               .collection('chats')
               .doc(chatId)
               .collection('messages')
               .orderBy('timestamp', descending: true)
               .limit(5)
               .get();
           
           if (messagesSnap.docs.isNotEmpty) {
              for (final msgDoc in messagesSnap.docs) {
                 final msgData = msgDoc.data();
                 if (msgData.containsKey('orderId') && msgData['orderId'] != null) {
                    updates['orderId'] = msgData['orderId'];
                    needsUpdate = true;
                    // debugPrint('[\$chatId] Found orderId in message: \${msgData['orderId']}');
                    break; // Found one
                 }
              }
           }
        }

        // 3. Normalize Unread Counts
        if (!data.containsKey('unreadCounts') || data['unreadCounts'] == null) {
           updates['unreadCounts'] = {
              'admin': data['unreadCount'] ?? 0,
              'user': 0
           };
           needsUpdate = true;
           // debugPrint('[\$chatId] Normalizing unreadCounts.');
        }

        // Apply Updates
        if (needsUpdate) {
           if (!dryRun) {
              await _firestore.collection('chats').doc(chatId).update(updates);
              updated++;
              // debugPrint('[\$chatId] Updated.');
           } else {
              // debugPrint('[\$chatId] WOULD update: \$updates');
              updated++;
           }
        }

      } catch (e) {
        debugPrint('[\$chatId] Error: \$e');
        errors++;
      }
    }

    debugPrint('Migration Complete.');
    debugPrint('Processed: \$processed, Updated: \$updated, Errors: \$errors');
    
    return {
      'processed': processed,
      'updated': updated,
      'errors': errors,
    };
  }
}
