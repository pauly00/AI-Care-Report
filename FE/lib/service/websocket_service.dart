import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;

  Function(String error)? onErrorCallback;
  Function()? onDoneCallback;

  Stream? _broadcastStream;

  bool get isConnected => _channel != null;
  Stream? get stream => _broadcastStream; // ✅ 안전하게 반환

  Future<void> connect(String url) async {
    try {
      // 1️⃣ 먼저 연결
      final channel = IOWebSocketChannel.connect(url);
      _channel = channel;

      // 2️⃣ broadcast 스트림 생성
      _broadcastStream = _channel!.stream.asBroadcastStream();

      // 3️⃣ 내부 listen (옵션, 직접 메시지 처리할 때만)
      _streamSubscription = _broadcastStream!.listen(
        (message) {},
        onError: (error) {
          debugPrint('[WebSocket] 에러 발생: $error');
          onErrorCallback?.call(error.toString());
        },
        onDone: () {
          debugPrint('[WebSocket] 연결 종료됨');
          onDoneCallback?.call();
        },
        cancelOnError: true,
      );
    } catch (e) {
      _channel = null;
      debugPrint('❌ WebSocket 연결 실패: $e');
      rethrow;
    }
  }

  void sendBinary(Uint8List data) {
    if (_channel != null) {
      _channel!.sink.add(data);
    } else {
      debugPrint('[WebSocket] 연결 안됨! 메시지 전송 불가');
    }
  }

  void sendMessage(String data) {
    if (_channel != null) {
      _channel!.sink.add(data);
    } else {
      debugPrint('[WebSocket] 연결 안됨! 메시지 전송 불가');
    }
  }

  void disconnect() {
    _streamSubscription?.cancel();
    _channel?.sink.close();
    _channel = null;
    _broadcastStream = null;
  }
}
