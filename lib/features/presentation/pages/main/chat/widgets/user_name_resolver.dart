import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserNameResolver extends StatefulWidget {
  final String userId;
  final String? orderId;
  final Widget Function(BuildContext context, String name) builder;

  const UserNameResolver({
    super.key,
    required this.userId,
    this.orderId,
    required this.builder,
  });

  @override
  State<UserNameResolver> createState() => _UserNameResolverState();
}

class _UserNameResolverState extends State<UserNameResolver> {
  static final Map<String, String> _nameCache = {};
  String? _resolvedName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _resolveName();
  }

  @override
  void didUpdateWidget(UserNameResolver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId || oldWidget.orderId != widget.orderId) {
      _resolveName();
    }
  }

  Future<void> _resolveName() async {
    final cacheKey = widget.userId;
    if (_nameCache.containsKey(cacheKey)) {
      if (mounted) setState(() => _resolvedName = _nameCache[cacheKey]);
      return;
    }

    if (mounted) setState(() => _isLoading = true);

    try {
      // 1. Try to find name in Users collection
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        final name = data?['name'] ?? data?['userName'] ?? data?['fullName'];
        if (name != null) {
          _nameCache[cacheKey] = name;
          if (mounted) setState(() => _resolvedName = name);
          return;
        }
      }

      // 2. Fallback: Try to find name in Orders collection if orderId is provided
      if (widget.orderId != null && widget.orderId!.isNotEmpty) {
        final orderDoc = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
        if (orderDoc.exists) {
          final data = orderDoc.data();
          final name = data?['userName'] ?? data?['customerName'] ?? data?['name'];
          if (name != null) {
            _nameCache[cacheKey] = name;
            if (mounted) setState(() => _resolvedName = name);
            return;
          }
        }
      }
      
      // 3. Last fallback
      final fallback = 'User ${widget.userId.substring(0, 5)}';
      _nameCache[cacheKey] = fallback;
      if (mounted) setState(() => _resolvedName = fallback);

    } catch (e) {
      if (mounted) setState(() => _resolvedName = 'User ${widget.userId.substring(0, 5)}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _resolvedName == null) {
      return widget.builder(context, 'Loading...');
    }
    return widget.builder(context, _resolvedName ?? 'User ${widget.userId.substring(0, 5)}');
  }
}
