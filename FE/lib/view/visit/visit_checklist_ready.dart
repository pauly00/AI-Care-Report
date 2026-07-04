import 'package:flutter/material.dart';
import 'package:safe_hi/service/audio_service.dart';
import 'package:safe_hi/service/websocket_service.dart';
import 'package:safe_hi/view/visit/visit_process.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'dart:io';

class CheckListReady extends StatefulWidget {
  const CheckListReady({super.key});

  @override
  State<CheckListReady> createState() => _CheckListReadyState();
}

class _CheckListReadyState extends State<CheckListReady> {
  // 싱글톤이 아닌 인스턴스
  late final WebSocketService _ws;
  late final AudioWebSocketRecorder _audio;

  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    _ws = WebSocketService();
    _audio = AudioWebSocketRecorder(ws: _ws);

    _connectToServer();
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToServer() async {
    final hasInternet = await isInternetAvailable();

    if (!hasInternet) {
      if (mounted) {
        _showDialog(
          title: '인터넷 연결 없음',
          content: '인터넷이 연결되어 있지 않습니다.\n연결 후 다시 시도해주세요.',
        );
      }
      return;
    }

    try {
      await _ws.connect('ws://211.188.55.88:8085');
      debugPrint('✅ 서버 연결 성공');
    } catch (e) {
      debugPrint('❌ WebSocket 연결 실패: $e');
      if (mounted) {
        _showRetryDialog();
      }
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('서버 연결 실패'),
        content: const Text('서버가 꺼져있거나 연결할 수 없습니다.\n다시 시도하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await _connectToServer();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 혹시나 현재 화면에서 dispose시 정리하고 싶으면
    _audio.dispose();
    _ws.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '실시간 대화'),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingHorizontal,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: responsive.sectionSpacing * 2),
                        Text(
                          '체크할 준비가 되었나요?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.fontXL,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.itemSpacing),
                        Text(
                          '지금부터 안심하이가 함께 하겠습니다.',
                          style: TextStyle(
                            color: const Color(0xFFB3A5A5),
                            fontSize: responsive.fontBase,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: responsive.sectionSpacing * 3),
                        Image.asset(
                          'assets/images/checklist.png',
                          width: responsive.isTablet ? 300 : 230,
                          height: responsive.isTablet ? 300 : 230,
                        ),
                        SizedBox(height: responsive.sectionSpacing * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '시작하기',
          onButtonTap: () async {
            if (!_ws.isConnected) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('연결 오류'),
                  content: const Text('서버에 연결되지 않았습니다.\n다시 시도해주세요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
              return;
            }

            try {
              await _audio.initRecorder();
              await _audio.startRecording();
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VisitProcess(ws: _ws, audio: _audio),
                ),
              );
            } catch (e) {
              debugPrint('[Audio Error] $e');
              if (e.toString().contains('마이크 권한이 없습니다')) {
                // 📢 마이크 권한 거부 팝업 띄우기
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('마이크 권한 필요'),
                    content:
                        const Text('마이크 권한이 허용되지 않았습니다.\n설정에서 마이크 접근을 허용해주세요.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
