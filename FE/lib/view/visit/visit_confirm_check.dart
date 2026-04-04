import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safe_hi/view/visit/visit_start_record.dart';
import 'dart:io';

/// 방문 확인 및 체크 페이지 - 대상자 정보 확인 및 방문 전 체크리스트
class VisitCheckConfirmPage extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  // 주소가 분리된 경우를 위한 선택적 매개변수
  final String? address1;
  final String? address2;

  const VisitCheckConfirmPage({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    this.address1,
    this.address2,
  });

  @override
  State<VisitCheckConfirmPage> createState() => _VisitCheckConfirmPageState();
}

class _VisitCheckConfirmPageState extends State<VisitCheckConfirmPage> {
  // 체크리스트 상태 관리
  bool _checkedInternet = false;
  bool _checkedConsent = false;

  /// 전화걸기 기능
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showErrorDialog('전화를 걸 수 없습니다.');
      }
    } catch (e) {
      _showErrorDialog('전화 연결 중 오류가 발생했습니다.');
    }
  }

  /// 네이버 지도 길찾기 열기
  Future<void> _openNaverMapRoute({required String destAddress}) async {
    try {
      final cleanAddress = destAddress.trim();
      debugPrint('🗺️ 네이버 지도 길찾기 시작 - 목적지: $cleanAddress');

      // 네이버 지도 스킴 방식들 (현재위치 → 목적지)
      final List<String> urlsToTry = [
        // 1차: 네이버 지도 앱 길찾기
        'nmap://search?query=${Uri.encodeComponent(cleanAddress)}&appname=com.safehi.app',
        // 2차: 네이버 지도 웹 길찾기
        'https://map.naver.com/p/directions/-/-/${Uri.encodeComponent(cleanAddress)}/car',
        // 3차: 네이버 지도 검색
        'nmap://search?query=${Uri.encodeComponent(cleanAddress)}&appname=com.safehi.app',
        // 4차: 네이버 지도 웹 검색
        'https://map.naver.com/p/search/${Uri.encodeComponent(cleanAddress)}',
        // 5차: 구글맵 폴백
        'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(cleanAddress)}&travelmode=driving',
      ];

      bool launched = false;
      for (int i = 0; i < urlsToTry.length; i++) {
        final urlString = urlsToTry[i];
        debugPrint('🔄 지도 앱 시도 ${i + 1}: $urlString');

        try {
          final uri = Uri.parse(urlString);
          launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

          if (launched) {
            debugPrint('✅ 지도 앱 실행 성공 (시도 ${i + 1})');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('네이버 지도에서 "${cleanAddress}"로 길찾기를 시작합니다.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
            return;
          }
        } catch (e) {
          debugPrint('❌ URL 시도 ${i + 1} 실패: $e');
        }

        // 각 시도 사이 짧은 대기
        await Future.delayed(const Duration(milliseconds: 200));
      }

      // 모든 시도 실패
      debugPrint('❌ 모든 지도 앱 실행 시도 실패');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('지도 앱을 실행할 수 없습니다.\n주소: $destAddress'),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: '다시시도',
              onPressed: () => _openNaverMapRoute(destAddress: destAddress),
            ),
          ),
        );
      }

    } catch (e) {
      debugPrint('❌ 지도 앱 실행 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('길찾기 실행 실패\n주소: $destAddress\n오류: ${e.toString()}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// 주소 통합 처리 (address1 + address2 우선, 없으면 address 사용)
  String _buildFullAddress() {
    final parts = [widget.address1, widget.address2]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toList();
    if (parts.isNotEmpty) {
      final result = parts.join(' ');
      debugPrint('🏠 분리된 주소 합치기: address1="${widget.address1}", address2="${widget.address2}" → "$result"');
      return result;
    }
    final result = (widget.address).trim();
    debugPrint('🏠 통합 주소 사용: address="$result"');
    return result;
  }

  /// 오류 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFB5457)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 대상자 기본 정보
              Text(
                  '${widget.name} 님',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              const SizedBox(height: 4),
              Text(_buildFullAddress()),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Color(0xFFFB5457)),
                  const SizedBox(width: 6),
                  Text(widget.phone),
                  const Spacer(),

                  // 길찾기 버튼
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFB5457), width: 1.5),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () async {
                          final fullAddress = _buildFullAddress();
                          debugPrint('🎯 길찾기 버튼 클릭');
                          debugPrint('📍 전체 주소: "$fullAddress"');

                          if (fullAddress.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('목적지 주소가 없습니다.')),
                            );
                            return;
                          }

                          // 네이버 지도 길찾기 실행
                          await _openNaverMapRoute(destAddress: fullAddress);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 자동차 아이콘
                              Icon(Icons.directions_car, color: Color(0xFFFB5457), size: 20),
                              SizedBox(width: 6),
                              Text(
                                '길찾기',
                                style: TextStyle(
                                  color: Color(0xFFFB5457),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // 전화걸기 버튼
                  OutlinedButton(
                    onPressed: () => _makePhoneCall(widget.phone),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFB5457)),
                      foregroundColor: const Color(0xFFFB5457),
                    ),
                    child: const Text('전화걸기'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 이전 상담 내용 컨테이너
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        '이전 상담 내용',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        '6.26 목 오전 10:29     15분 36초', // 더미값 - 추후 API 연동 필요
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.6
                        )
                    ),
                    const SizedBox(height: 12),

                    // Divider 바
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),

                    // 더미값 - 추후 API 연동 필요
                    const Text(
                        '<건강 상태>\n• 최근 허리 통증 호소 (지난주보다 심해짐)\n• 보행 시 지팡이 의존 ↑, 거동 속도 저하 확인\n• 혈압 측정: 150/95 (약간 높은 상태)\n\n<생활 환경>\n• 집안 청소 상태 양호하나, 욕실 바닥 미끄럽고 안전손잡이 미설치\n• 냉장고에 식재료는 충분하나, 주로 빵·라면 섭취 → 균형 잡힌 식단 부족\n\n<정서·사회적 상태>\n• 외출 기회 적어 고립감 호소\n• TV 시청·라디오 청취로 주로 시간을 보냄\n• 최근 우울감 언급, 대화 중 눈물 보임',
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.6
                        )
                    ),
                  ],
                ),
              ),

              // 담당자 메모 컨테이너
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '담당자 메모',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                    SizedBox(height: 8),
                    // 더미값 - 추후 API 연동 필요
                    Text(
                        '대상자의 건강·정서적 위험이 동시에 확인됨\n단기적으로 건강·안전 조치 필요, 중장기적으로 정서지원 강화 권장',
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.6
                        )
                    ),
                  ],
                ),
              ),

              // 돌봄 전 체크 사항 컨테이너
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        '✅ 돌봄 전 체크 사항',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                    const SizedBox(height: 12),
                    // 인터넷 연결 확인 체크박스
                    CheckboxListTile(
                      value: _checkedInternet,
                      onChanged: (val) => setState(() => _checkedInternet = val ?? false),
                      title: const Text('인터넷 연결을 확인해주세요.'),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    // 녹음 동의 확인 체크박스
                    CheckboxListTile(
                      value: _checkedConsent,
                      onChanged: (val) => setState(() => _checkedConsent = val ?? false),
                      title: const Text('대상자에게 녹음 동의를 구했습니다.'),
                      subtitle: const Text(
                        '※ 상담 내용은 서비스 개선 및 복지 제안에 사용될 수 있습니다.',
                        style: TextStyle(fontSize: 12),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: (_checkedInternet && _checkedConsent) ? () {
              // 돌봄 시작 로직 - visit_start_record.dart 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitStartRecordPage(),
                ),
              );
            } : null, // 체크박스가 모두 체크되지 않으면 비활성화
            style: ElevatedButton.styleFrom(
              backgroundColor: (_checkedInternet && _checkedConsent)
                  ? const Color(0xFFFB5457)
                  : Colors.grey,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '돌봄 시작하기',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}