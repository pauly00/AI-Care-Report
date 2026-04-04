import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    final Connectivity _connectivity = Connectivity();

    // ✅ 실행 직후 상태 강제 확인
    checkInitialConnection();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      final isOffline =
          results.isEmpty || results.contains(ConnectivityResult.none);

      if (isOffline && !_isDialogVisible) {
        _showNoConnectionDialog();
      } else if (!isOffline && _isDialogVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        _isDialogVisible = false;
      }
    });
  }

  void checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    final isOffline = result == ConnectivityResult.none;

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

              // ✅ 확인 후 연결이 여전히 안 되어 있다면 다시 팝업 띄우기
              await Future.delayed(const Duration(milliseconds: 300));
              final result = await Connectivity().checkConnectivity();
              final stillOffline = result == ConnectivityResult.none;

              if (stillOffline && mounted && !_isDialogVisible) {
                _showNoConnectionDialog(); // 🔁 다시 팝업
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
}

Future<bool> isInternetAvailable() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}
