import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/signup/signup_form_page.dart';
import 'package:safe_hi/view_model/signup_view_model.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';

/// 역할 선택 화면 - 회원가입 시 사용자 역할 선택
class RoleSelectPage extends StatefulWidget {
  const RoleSelectPage({super.key});

  @override
  State<RoleSelectPage> createState() => _RoleSelectPageState();
}

class _RoleSelectPageState extends State<RoleSelectPage> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
        child: Column(
          children: [
            Expanded(
              // 역할 선택 영역을 가운데 정렬
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 메인 타이틀
                    Text(
                      '역할을 선택해주세요',
                      style: TextStyle(
                        fontSize: responsive.fontXL,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    
                    // 안내 텍스트
                    Text(
                      '안심하이는 여러분의 역할에 맞춰 \n더 쉽고 정확한 관리를 도와드려요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey, fontSize: responsive.fontSmall),
                    ),
                    SizedBox(height: responsive.sectionSpacing),
                    
                    // 역할 옵션 1: 기관/지자체
                    _buildRoleOption('기관 / 지자체', '👨‍💼👩‍💼', responsive),
                    SizedBox(height: responsive.itemSpacing),
                    
                    // 역할 옵션 2: 동행매니저
                    _buildRoleOption('동행매니저', '🙋‍♂️🙋‍♀️', responsive),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 하단 다음 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.paddingHorizontal,
        ),
        child: BottomOneButton(
          buttonText: '다음',
          isEnabled: _selectedRole != null,
          onButtonTap: () {
            int roleValue = _selectedRole == '기관 / 지자체' ? 0 : 1; // 역할 코드 변환
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => SignupViewModel(),
                  // 추후 SignupFormPage 연결 필요
                  //child: SignupFormPage(role: roleValue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 역할 선택 카드 위젯
  Widget _buildRoleOption(String role, String emoji, Responsive responsive) {
    final isSelected = _selectedRole == role;

    // 역할별 설명 텍스트 - 추후 다국어 지원 필요
    String subText;
    if (role == '기관 / 지자체') {
      subText = '기관·지자체 관리자님께 꼭 맞춘 서비스예요.\n현재 한전MCS와 지자체에서 사용 중이에요!'; // 더미값
    } else {
      subText = '동행매니저님이 기록과 분석을\n쉽게 관리할 수 있도록 도와드릴게요!'; // 더미값
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      child: Container(
        padding: EdgeInsets.all(responsive.itemSpacing),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEDED) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFEB5C5C) : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // 체크박스 아이콘
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? const Color(0xFFEB5C5C) : Colors.grey,
              ),
            ),
            
            // 역할 이모지
            Text(emoji, style: TextStyle(fontSize: responsive.fontXL)),
            SizedBox(height: responsive.itemSpacing / 2),
            
            // 역할 이름
            Text(
              role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.fontBase,
              ),
            ),
            SizedBox(height: responsive.itemSpacing / 2),
            
            // 역할 설명
            Text(
              subText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.fontSmall,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}