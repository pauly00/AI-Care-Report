import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safe_hi/service/websocket_service.dart';
import 'package:safe_hi/service/audio_service.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/view/visit/visit_check1.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VisitProcess extends StatefulWidget {
  final WebSocketService ws;
  final AudioWebSocketRecorder audio;

  const VisitProcess({
    super.key,
    required this.ws,
    required this.audio,
  });

  @override
  VisitProcessState createState() => VisitProcessState();
}

class VisitProcessState extends State<VisitProcess>
    with SingleTickerProviderStateMixin {
  final List<String> _sttTexts = [];
  final ScrollController _scrollController = ScrollController();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isReconnectDialogVisible = false;

  StreamSubscription? _wsSub; // 현재 listen 보관
  bool _reconnecting = false; // 중복 재시도 방지

  Timer? _noAudioTimer;
  bool _hasReceivedAudio = false;

  void _startNoAudioTimer() {
    _noAudioTimer = Timer(const Duration(seconds: 10), () {
      if (!_hasReceivedAudio && mounted) {
        _showNoAudioDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    // WebSocket 연결 끊김 감지
    widget.ws.onErrorCallback = (error) {
      _showDialog('서버 오류', '서버와의 연결 중 오류가 발생했어요.\n네트워크 상태를 확인해 주세요.');
    };

    widget.ws.onDoneCallback = () {
      _showDialog('서버 연결 종료', '서버와의 연결이 종료되었어요.\n잠시 후 다시 시도해 주세요.');
    };

    _hasReceivedAudio = true;
    widget.ws.stream?.listen((message) {
      setState(() {
        _sttTexts.add(message.toString());
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showNoAudioDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('음성 데이터 없음'),
        content: const Text(
          '10초 동안 음성이 수신되지 않았어요.\n\n'
          '말씀이 없으신 경우에는 걱정하지 않으셔도 되고,\n'
          '혹시 계속 말씀 중인데도 반응이 없다면\n'
          '네트워크 환경(방화벽, 프록시 등)을 확인해 주세요.',
        ),
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

  void _showDialog(String title, String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('서버 연결 종료'),
        content: const Text('서버와의 연결이 끊어졌습니다.\n다시 연결을 시도하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await _tryReconnect();
            },
            child: const Text('확인 후 다시 연결'),
          ),
        ],
      ),
    );
  }

  Future<void> _tryReconnect() async {
    if (_reconnecting) return; // 동시에 두 번 못 들어오게
    _reconnecting = true;

    // 0) 기존 세션 정리
    _wsSub?.cancel();
    await widget.audio.stopRecording(); // 🎙 녹음 확실히 중단
    widget.ws.disconnect();

    // 1) 최대 3회 재시도
    const url = 'https://safe-hi.xyz';
    bool ok = false;
    for (int i = 0; i < 3 && !ok; i++) {
      try {
        await widget.ws.connect(url); // 소켓 열기
        ok = true;
      } catch (_) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    if (!ok) {
      _reconnecting = false;
      if (mounted) _showReconnectDialog(); // 다시‑시도 팝업
      return;
    }

    // 2) 새로 listen 등록 (이전에 cancel 했으므로 안전)
    _wsSub = widget.ws.stream?.listen(
      (msg) {
        setState(() => _sttTexts.add(msg.toString()));
        _scrollToBottom();
      },
      onError: (err) {
        if (mounted) _showReconnectDialog();
      },
      onDone: () {
        if (mounted) _showReconnectDialog();
      },
      cancelOnError: true,
    );

    // 3) 녹음 재시작
    await widget.audio.startRecording();

    _reconnecting = false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showReconnectDialog() {
    if (_isReconnectDialogVisible) return;
    _isReconnectDialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('서버 연결 끊김'),
        content: const Text('서버와의 연결이 끊어졌습니다.\n다시 연결하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              _isReconnectDialogVisible = false;

              // 팝업 닫힌 다음 프레임에서 다시 재시도
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Future.delayed(
                    const Duration(milliseconds: 200)); // 💡 약간의 여유 줌
                await _tryReconnect(); // 실패하면 다시 showReconnectDialog 호출됨
              });
            },
            child: const Text('확인 후 다시 연결'),
          ),
        ],
      ),
    );
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        padding: EdgeInsets.all(responsive.itemSpacing),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red.shade200, Colors.red.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: responsive.iconSize,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    Text(
                      '어르신의 말씀을 하나하나 담고 있어요 :)',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: responsive.fontBase + 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.sectionSpacing),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: responsive.screenHeight * 0.45,
                        minHeight: responsive.screenHeight * 0.45,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.itemSpacing,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        controller: _scrollController,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.itemSpacing,
                        ),
                        itemCount: _sttTexts.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: responsive.itemSpacing),
                        itemBuilder: (context, index) =>
                            _buildBubble(_sttTexts[index], responsive),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.paddingHorizontal,
        ),
        child: BottomTwoButton(
          buttonText1: '이전 대화',
          buttonText2: '상담 종료',
          onButtonTap1: () {},
          onButtonTap2: () async {
            WakelockPlus.disable();
            await widget.audio.stopRecording();
            widget.ws.disconnect();

            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Check1()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBubble(String text, Responsive responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: responsive.itemSpacing),
          child: Icon(
            Icons.chat_bubble_outline,
            color: Colors.red.shade300,
            size: responsive.iconSize * 0.55,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(responsive.itemSpacing * 0.85),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.red.shade100, width: 1),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: responsive.fontBase,
                color: Colors.grey.shade900,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
