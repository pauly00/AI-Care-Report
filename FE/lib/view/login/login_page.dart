import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/main_screen.dart';
import 'package:safe_hi/view/signup/terms_agreement_page.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/util/responsive.dart';

import '../signup/signup_form_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAutoLogin = false;
  bool _isLoading = false;

  // 무조건 로그인용 우회코드, 추후 주석처리
  // void _login() async {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (_) => const MainScreen()),
  //   );
  // }

  void _login() async {
    setState(() => _isLoading = true);

    final userVM = Provider.of<UserViewModel>(context, listen: false);
    final result = await userVM.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      saveLogin: _isAutoLogin,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      // 로그인 성공 시 메인 화면으로 이동
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      });
    } else {
      // 로그인 실패 시 에러 다이얼로그 표시
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('로그인 실패'),
          content: Text(result['msg']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 이미지
                Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: 1.25,
                    child: Image.asset(
                      'assets/images/logoicon.png',
                      width: responsive.imageSize + 10,
                      height: responsive.imageSize + 10,
                    ),
                  ),
                ),
                SizedBox(height: responsive.itemSpacing),

                SizedBox(height: responsive.sectionSpacing * 2),

                // 이메일 입력 섹션
                Text(
                  '이메일 주소',
                  style: TextStyle(
                    fontSize: responsive.fontSmall,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(height: 4),

                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: '이메일을 입력해주세요.',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9D9D9D),
                      fontSize: responsive.fontSmall,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: responsive.itemSpacing,
                      horizontal: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0DCDC)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFFB5457)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: responsive.itemSpacing),

                // 비밀번호 입력 섹션
                Text(
                  '비밀번호',
                  style: TextStyle(
                    fontSize: responsive.fontSmall,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF999999),
                  ),
                ),
                SizedBox(height: 4),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요.',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9D9D9D),
                      fontSize: responsive.fontSmall,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: responsive.itemSpacing,
                      horizontal: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFE0DCDC)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFFB5457)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: responsive.itemSpacing / 1.2),

                // 자동 로그인 체크박스와 계정 찾기 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 자동 로그인 체크박스
                    Row(
                      children: [
                        Checkbox(
                          value: _isAutoLogin,
                          onChanged: (value) {
                            setState(() => _isAutoLogin = value ?? false);
                          },
                          activeColor: const Color(0xFFFB5457),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF9D9D9D),
                            width: 1.2,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '자동로그인',
                          style: TextStyle(
                            fontSize: responsive.fontSmall,
                            color: const Color(0xFF9D9D9D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // 아이디/비밀번호 찾기 버튼
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '아이디 찾기',
                            style: TextStyle(
                              fontSize: responsive.fontSmall,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 1,
                          height: responsive.fontSmall + 6,
                          color: const Color(0xFFBDBDBD),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '비밀번호 찾기',
                            style: TextStyle(
                              fontSize: responsive.fontSmall,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionSpacing),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB5457),
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.itemSpacing * 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: responsive.fontBase,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: responsive.sectionSpacing * 1.5),

                // 회원가입 안내 섹션
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 아직 없으신가요?',
                      style: TextStyle(
                        fontSize: responsive.fontSmall,
                        color: const Color(0xFF9D9D9D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 24),

                    // 회원가입 버튼
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignupFormPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFBDBDBD),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '회원가입 하러가기',
                          style: TextStyle(
                            fontSize: responsive.fontSmall,
                            color: const Color(0xFF9D9D9D),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.sectionSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
