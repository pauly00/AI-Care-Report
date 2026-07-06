import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    final connectivity = Connectivity();

    checkInitialConnection();

    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((results) {
      final isOffline = _isOffline(results);

      if (isOffline && !_isDialogVisible) {
        _showNoConnectionDialog();
      } else if (!isOffline && _isDialogVisible) {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        _isDialogVisible = false;
      }
    });
  }

  Future<void> checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final isOffline = _isOffline(results);

    if (isOffline && !_isDialogVisible && mounted) {
      _showNoConnectionDialog();
    }
  }

  void _showNoConnectionDialog() {
    _isDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('인터넷 연결 없음'),
        content: const Text('인터넷에 연결되어 있지 않습니다.\n연결 후 다시 시도해주세요.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              _isDialogVisible = false;

              await Future.delayed(const Duration(milliseconds: 300));
              final results = await Connectivity().checkConnectivity();
              final stillOffline = _isOffline(results);

              if (stillOffline && mounted && !_isDialogVisible) {
                _showNoConnectionDialog();
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  bool _isOffline(List<ConnectivityResult> results) {
    return results.isEmpty || results.contains(ConnectivityResult.none);
  }
}

Future<bool> isInternetAvailable() async {
  final results = await Connectivity().checkConnectivity();
  return results.isNotEmpty && !results.contains(ConnectivityResult.none);
}
