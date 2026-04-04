import 'package:flutter/material.dart';

import '../../util/responsive.dart';
import '../login/login_page.dart';

/// 약관 동의 바텀시트
class TermsBottomSheet extends StatefulWidget {
  const TermsBottomSheet({Key? key}) : super(key: key);

  @override
  State<TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<TermsBottomSheet> {
  bool _allAgreeValue = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;
  bool _agreeThirdParty = false;

  // 확장 상태 관리
  bool _termsExpanded = false;
  bool _privacyExpanded = false;
  bool _thirdPartyExpanded = false;

  bool get _allIndividualAgree =>
      _agreeTerms && _agreePrivacy && _agreeThirdParty;

  /// 전체 동의 체크박스 상태 업데이트
  void _updateOverallCheckbox() {
    setState(() {
      _allAgreeValue = _allIndividualAgree;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 드래그 핸들
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '약관 동의',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingHorizontal,
                ),
                child: Column(
                  children: [
                    // 안내 텍스트
                    const Text(
                      '서비스 시작 및 가입을 위해\n먼저 아래 약관에 동의해주세요.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF433A3A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // 전체 동의 체크박스
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _allAgreeValue = !_allAgreeValue;
                                _agreeTerms = _allAgreeValue;
                                _agreePrivacy = _allAgreeValue;
                                _agreeThirdParty = _allAgreeValue;
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _allAgreeValue ? const Color(0xFFFB5457) : Colors.white,
                                border: Border.all(
                                  color: _allAgreeValue ? const Color(0xFFFB5457) : Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: _allAgreeValue
                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              '필수 전체 동의',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 개별 약관 항목들
                    _buildExpandableTermItem(
                      '(필수) 이용약관 동의',
                      _agreeTerms,
                      _termsExpanded,
                      (value) {
                        setState(() {
                          _agreeTerms = value;
                          _updateOverallCheckbox();
                        });
                      },
                      () {
                        setState(() {
                          _termsExpanded = !_termsExpanded;
                        });
                      },
                      _getTermsContent(), // 더미값 - 추후 실제 약관 내용으로 교체 필요
                      responsive,
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableTermItem(
                      '(필수) 개인정보 수집 및 이용동의',
                      _agreePrivacy,
                      _privacyExpanded,
                      (value) {
                        setState(() {
                          _agreePrivacy = value;
                          _updateOverallCheckbox();
                        });
                      },
                      () {
                        setState(() {
                          _privacyExpanded = !_privacyExpanded;
                        });
                      },
                      _getPrivacyContent(), // 더미값 - 추후 실제 개인정보 정책으로 교체 필요
                      responsive,
                    ),
                    const SizedBox(height: 16),
                    _buildExpandableTermItem(
                      '(필수) 개인정보 제3자 제공 동의',
                      _agreeThirdParty,
                      _thirdPartyExpanded,
                      (value) {
                        setState(() {
                          _agreeThirdParty = value;
                          _updateOverallCheckbox();
                        });
                      },
                      () {
                        setState(() {
                          _thirdPartyExpanded = !_thirdPartyExpanded;
                        });
                      },
                      _getThirdPartyContent(), // 더미값 - 추후 실제 제3자 제공 정책으로 교체 필요
                      responsive,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 동의 완료 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _allIndividualAgree ? () {
                          Navigator.of(context).pop(); // 바텀시트 닫기
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _allIndividualAgree 
                              ? const Color(0xFFFB5457) 
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '동의하고 완료',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 확장 가능한 약관 항목 위젯
  Widget _buildExpandableTermItem(
    String title,
    bool isChecked,
    bool isExpanded,
    ValueChanged<bool> onCheckChanged,
    VoidCallback onExpandToggle,
    String content,
    Responsive responsive,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더 부분
          InkWell(
            onTap: onExpandToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // 체크 아이콘
                  InkWell(
                    onTap: () => onCheckChanged(!isChecked),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isChecked ? const Color(0xFFFB5457) : Colors.white,
                        border: Border.all(
                          color: isChecked ? const Color(0xFFFB5457) : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: isChecked
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 드롭다운 아이콘
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          // 확장된 내용
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 이용약관 내용 - 더미값
  String _getTermsContent() {
    return '''제1조 (목적)
이 약관은 안심하이(이하 "회사"라 합니다)가 운영하는 안심하이 서비스(이하 "서비스"라 합니다)의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (정의)
1. "서비스"란 회사가 제공하는 모든 서비스를 말합니다.
2. "이용자"란 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.''';
  }

  /// 개인정보 수집 내용 - 더미값
  String _getPrivacyContent() {
    return '''1. 개인정보의 수집 및 이용 목적
회사는 다음의 목적을 위하여 개인정보를 처리합니다.

가. 서비스 제공에 관한 계약 이행
나. 회원 관리

2. 처리하는 개인정보의 항목
- 필수항목: 이름, 생년월일, 성별, 이메일, 전화번호''';
  }

  /// 제3자 제공 내용 - 더미값
  String _getThirdPartyContent() {
    return '''1. 개인정보를 제공받는 자
- 배송업체, 결제대행업체, 본인확인업체

2. 제공하는 개인정보의 항목
가. 배송업체: 성명, 주소, 전화번호
나. 결제대행업체: 성명, 전화번호, 이메일''';
  }
}
