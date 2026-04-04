import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/visit/visit_checklist_new.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart'; // ✅ import 추가


// TODO: 음성 녹음을 위한 패키지 추가 필요
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:audio_session/audio_session.dart';

// 방문 돌봄 녹음 페이지
class VisitStartRecordPage extends StatefulWidget {
  const VisitStartRecordPage({super.key});

  @override
  State<VisitStartRecordPage> createState() => _VisitStartRecordPageState();
}

class _VisitStartRecordPageState extends State<VisitStartRecordPage>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // TODO: 음성 인식 관련 변수 추가 필요
  // late SpeechToText _speech;
  // bool _isListening = false;
  // String _currentText = '';
  // List<ChatMessage> _messages = [];

  // TODO: 대화 메시지 모델 클래스 정의 필요
  // class ChatMessage {
  //   final String text;
  //   final bool isFromUser; // true: 어르신, false: 상담원
  //   final DateTime timestamp;
  //   
  //   ChatMessage({required this.text, required this.isFromUser, required this.timestamp});
  // }

  @override
  void initState() {
    super.initState();
    // 맥박 애니메이션 초기화 (1초 주기로 반복)
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // 크기 변화 애니메이션 (0.9 ~ 1.1 배율)
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // TODO: 음성 인식 초기화 및 권한 요청
    // _initializeSpeechRecognition();
  }

  // TODO: 음성 인식 초기화 함수
  // Future<void> _initializeSpeechRecognition() async {
  //   _speech = SpeechToText();
  //   // 마이크 권한 요청
  //   await Permission.microphone.request();
  //   // 음성 인식 초기화
  //   bool available = await _speech.initialize();
  //   if (available) {
  //     _startListening();
  //   }
  // }

  // TODO: 음성 인식 시작 함수
  // void _startListening() async {
  //   await _speech.listen(
  //     onResult: _onSpeechResult,
  //     listenFor: Duration(minutes: 30), // 최대 30분 녹음
  //     pauseFor: Duration(seconds: 3), // 3초 침묵 시 일시정지
  //     partialResults: true, // 실시간 결과 표시
  //     localeId: 'ko_KR', // 한국어 설정
  //   );
  //   setState(() {
  //     _isListening = true;
  //   });
  // }

  // TODO: 음성 인식 결과 처리 함수
  // void _onSpeechResult(result) {
  //   setState(() {
  //     _currentText = result.recognizedWords;
  //     if (result.finalResult) {
  //       // 화자 구분 로직 (AI 모델 또는 음성 분석 필요)
  //       bool isFromUser = _determineSpeaker(_currentText);
  //       _messages.add(ChatMessage(
  //         text: _currentText,
  //         isFromUser: isFromUser,
  //         timestamp: DateTime.now(),
  //       ));
  //       _currentText = '';
  //     }
  //   });
  // }

  // TODO: 화자 구분 함수 (AI 모델 연동 필요)
  // bool _determineSpeaker(String text) {
  //   // 음성 주파수 분석, 음성 패턴 분석, 또는 AI 모델을 통한 화자 구분
  //   // 현재는 간단한 키워드 기반 구분 (임시)
  //   List<String> counselorKeywords = ['안녕하세요', '어떠세요', '언제부터', '검사'];
  //   for (String keyword in counselorKeywords) {
  //     if (text.contains(keyword)) return false; // 상담원
  //   }
  //   return true; // 기본적으로 어르신으로 분류
  // }

  // TODO: 음성 인식 중지 함수
  // void _stopListening() async {
  //   await _speech.stop();
  //   setState(() {
  //     _isListening = false;
  //   });
  // }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 정리
    _animationController.dispose();
    // TODO: 음성 인식 리소스 정리
    // _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: const DefaultBackAppBar(title: '실시간 대화'),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // 중앙 녹음 버튼 영역 (애니메이션 포함)
            Column(
              children: [
                // 맥박 애니메이션이 적용된 마이크 버튼
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFB5457)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFB5457).withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // 녹음 상태 텍스트
                Text(
                  "실시간 녹음 중",
                  style: TextStyle(
                    fontSize: responsive.fontXL,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFB5457),
                  ),
                ),
                const SizedBox(height: 8),
                // 안내 메시지
                Text(
                  "대화 내용이 자동으로 기록됩니다",
                  style: TextStyle(
                    fontSize: responsive.fontSmall,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // TODO: 실제 음성 인식 결과로 대화 내용 표시
            // 현재는 더미 데이터 사용, 실제 구현 시 _messages 리스트 활용
            // 대화 내용 표시 영역(더미값 활용)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView(
                  // TODO: ListView.builder로 변경하여 _messages 리스트 표시
                  // itemCount: _messages.length,
                  // itemBuilder: (context, index) {
                  //   final message = _messages[index];
                  //   return _buildMessageBubble(message);
                  // },
                  children: [
                    // TODO: 아래 더미 데이터를 실제 음성 인식 결과로 교체
                    // 상담원 질문 (좌측 정렬)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12, right: 50),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB5457),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "안녕하세요. 몸 상태는 어떠세요?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // 어르신 답변 (우측 정렬)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12, left: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          "아이고, 요 며칠 허리가 더 아파서 잘 못 움직이겠어요.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // 추가 상담원 질문 (좌측 정렬)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12, right: 50),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFB5457),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "언제부터 더 아프셨나요?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // 추가 어르신 답변 (우측 정렬)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12, left: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          "지난주부터요. 계단 오르르기 힘들어서...",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // 하단 돌봄 종료 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              _showEndRecordingDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB5457),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "돌봄 종료하기",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TODO: 메시지 버블 생성 함수
  // Widget _buildMessageBubble(ChatMessage message) {
  //   return Align(
  //     alignment: message.isFromUser ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       margin: EdgeInsets.only(
  //         bottom: 12,
  //         left: message.isFromUser ? 50 : 0,
  //         right: message.isFromUser ? 0 : 50,
  //       ),
  //       decoration: BoxDecoration(
  //         color: message.isFromUser ? Colors.white : const Color(0xFFFB5457),
  //         borderRadius: BorderRadius.circular(12),
  //         border: message.isFromUser ? Border.all(color: Colors.grey.shade200) : null,
  //       ),
  //       child: Text(
  //         message.text,
  //         style: TextStyle(
  //           color: message.isFromUser ? Colors.black87 : Colors.white,
  //           fontWeight: message.isFromUser ? FontWeight.w500 : FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // 돌봄 종료 확인 다이얼로그 표시
  void _showEndRecordingDialog() {
    // TODO: 돌봄 종료 시 음성 인식 중지 및 데이터 저장
    // _stopListening();
    // _saveRecordingData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '돌봄 종료',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '돌봄을 종료하시겠습니까?',
          ),
          actions: [
            // 취소 버튼 - 녹음을 계속 진행
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기만 하고 녹음 유지
                // TODO: 음성 인식 재시작 (일시정지 상태였다면)
                // _startListening();
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            // 종료 확인 버튼 - 리포트 페이지로 이동
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 돌봄 완료 후 리포트 페이지로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckListNew(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB5457),
                foregroundColor: Colors.white,
              ),
              child: const Text('종료'),
            ),
          ],
        );
      },
    );
  }

// TODO: 녹음 데이터 저장 함수
// Future<void> _saveRecordingData() async {
//   // 서버에 대화 내용 저장
//   // 로컬 데이터베이스에 백업 저장
//   // 리포트 생성을 위한 데이터 가공
// }
}
