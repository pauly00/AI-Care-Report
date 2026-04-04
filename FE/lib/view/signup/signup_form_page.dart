// 전체 SignupFormPage에 Responsive 클래스 반영
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/model/user_register_model.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/signup/terms_agreement_page.dart';
import 'package:safe_hi/view_model/signup_view_model.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/view/login/login_page.dart';
import 'package:safe_hi/view/signup/terms_bottom_sheet.dart';

/// 회원가입 폼 화면 - 사용자 정보 입력 및 약관 동의
class SignupFormPage extends StatefulWidget {
  const SignupFormPage({super.key});

  @override
  State<SignupFormPage> createState() => _SignupFormPageState();
}

class _SignupFormPageState extends State<SignupFormPage> {
  // 입력 컨트롤러
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthController = TextEditingController();
  
  DateTime? _selectedBirthDate;

  // 입력 상태 관리
  bool _isEmailChecked = false;
  String _gender = '남'; // 더미값 - 추후 다국어 지원 필요
  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  /// 폼 유효성 검사 - 모든 필수 항목이 올바르게 입력되었는지 확인
  bool get _isFormValid {
    return _isEmailChecked &&
        _validateEmail(_emailController.text) &&
        _validatePassword(_passwordController.text) == null &&
        _passwordController.text == _confirmPasswordController.text &&
        _nameController.text.isNotEmpty &&
        _validatePhoneNumber(_phoneController.text) &&
        _birthController.text.isNotEmpty;
  }

  /// 비밀번호 유효성 검사 - 특수문자, 문자, 숫자 포함 8-15자
  String? _validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 \n8자 이상 15자 이내로 입력하세요.';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final passwordMatch =
        _passwordController.text == _confirmPasswordController.text;
    final passwordError = _validatePassword(_passwordController.text);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '회원 가입'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: responsive.sectionSpacing),
                      
                      // 이메일 입력 필드
                      _buildEmailField(),
                      if (_isEmailChecked &&
                          _validateEmail(_emailController.text))
                        _helperText('사용 가능한 이메일입니다.'),
                      if (_isEmailChecked &&
                          !_validateEmail(_emailController.text))
                        _helperText('올바른 이메일 형식이 아닙니다.', isError: true),
                      
                      // 비밀번호 입력 필드
                      _buildPasswordField(
                          '비밀번호', _passwordController, _isObscurePassword, () {
                        setState(
                            () => _isObscurePassword = !_isObscurePassword);
                      }),
                      if (passwordError != null)
                        _helperText(passwordError, isError: true),
                      
                      // 비밀번호 확인 필드
                      _buildPasswordField('비밀번호 확인', _confirmPasswordController,
                          _isObscureConfirm, () {
                        setState(() => _isObscureConfirm = !_isObscureConfirm);
                      }),
                      if (_passwordController.text.isNotEmpty &&
                          _confirmPasswordController.text.isNotEmpty)
                        _helperText(
                          passwordMatch ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.',
                          isError: !passwordMatch,
                        ),
                      
                      // 이름 입력 필드
                      _buildTextField(label: '이름', controller: _nameController),
                      
                      // 전화번호 입력 필드
                      _buildTextField(
                        label: '전화번호',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        hintText: '예시) 010-1234-5678',
                      ),
                      if (_phoneController.text.isNotEmpty &&
                          !_validatePhoneNumber(_phoneController.text))
                        _helperText('전화번호 형식이 올바르지 않습니다.', isError: true),
                      
                      // 생년월일 선택 필드
                      _buildBirthField(),
                      SizedBox(height: responsive.itemSpacing),
                      
                      // 성별 선택
                      _buildGenderSelection(),
                      SizedBox(height: responsive.sectionSpacing),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // 하단 가입하기 버튼
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.paddingHorizontal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 개발용 테스트 버튼 - 추후 제거 필요
            // BottomOneButton(
            //   buttonText: '테스트 가입하기 (개발용)',
            //   isEnabled: true,
            //   onButtonTap: () async {
            //     _showTermsBottomSheet(context);
            //   },
            // ),
            SizedBox(height: responsive.itemSpacing),
            
            // 실제 가입하기 버튼
            BottomOneButton(
                buttonText: '가입하기',
                isEnabled: _isFormValid,
                onButtonTap: () async {
                  if (_isFormValid) {
                    final genderValue = _gender == '남' ? 1 : 0; // 성별 코드 변환

                    final user = UserRegisterModel(
                      name: _nameController.text.trim(),
                      phoneNumber: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      birthdate: _birthController.text.trim(),
                      gender: genderValue,
                      password: _passwordController.text.trim(),
                    );

                    try {
                      final viewModel = context.read<SignupViewModel>();
                      final result = await viewModel.signup(user); // 회원가입 API 호출 - 추후 백엔드 연동 필요
                      final success = result['success'] as bool;
                      final msg = result['msg'] as String;

                      if (success && mounted) {
                        // 성공시 약관 바텀시트 표시
                        _showTermsBottomSheet(context);
                      } else if (mounted) {
                        showErrorDialog(context, msg);
                      }
                    } catch (e) {
                      // Provider를 찾을 수 없는 경우에도 약관 바텀시트 표시
                      if (mounted) {
                        _showTermsBottomSheet(context);
                      }
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  /// 이메일 유효성 검사
  bool _validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  /// 전화번호 유효성 검사 (010-xxxx-xxxx 형식)
  bool _validatePhoneNumber(String phone) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(phone);
  }

  /// 이메일 입력 필드 위젯
  Widget _buildEmailField() {
    return _buildTextField(
      label: '이메일',
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      suffixIcon: TextButton(
        onPressed: () => setState(() => _isEmailChecked = true), // 중복확인 - 추후 API 연동 필요
        child: const Text('중복확인', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  /// 비밀번호 입력 필드 위젯
  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isObscure, VoidCallback toggle) {
    return _buildTextField(
      label: label,
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscure: isObscure,
      suffixIcon: IconButton(
        onPressed: toggle,
        icon: Icon(
          isObscure
              ? FontAwesomeIcons.solidEyeSlash
              : FontAwesomeIcons.solidEye,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  /// 공통 텍스트 필드 위젯
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? hintText,
  }) {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: responsive.fontBase),
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: const Color(0xFFF9F6F6),
            filled: true,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: responsive.itemSpacing),
      ],
    );
  }

  /// 생년월일 선택 필드 위젯
  Widget _buildBirthField() {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText('생년월일'),
        const SizedBox(height: 6),
        TextField(
          controller: _birthController,
          readOnly: true,
          style: TextStyle(fontSize: responsive.fontBase),
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            fillColor: const Color(0xFFF9F6F6),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFEBE7E7), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () async {
            FocusScope.of(context).unfocus();
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedBirthDate ?? DateTime(now.year - 20),
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) {
              setState(() {
                _selectedBirthDate = picked;
                _birthController.text = _formatDate(picked);
              });
            }
          },
        ),
        SizedBox(height: responsive.itemSpacing),
      ],
    );
  }

  /// 날짜 형식 변환 (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 성별 선택 위젯
  Widget _buildGenderSelection() {
    final responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelText('성별'),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildRadioButton('남'),
            SizedBox(width: responsive.itemSpacing),
            _buildRadioButton('여'),
          ],
        ),
      ],
    );
  }

  /// 라디오 버튼 위젯
  Widget _buildRadioButton(String value) {
    final responsive = Responsive(context);
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _gender,
          onChanged: (val) => setState(() => _gender = val!),
          activeColor: Colors.red,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: responsive.fontBase + 2,
          ),
        ),
      ],
    );
  }

  /// 라벨 텍스트 위젯 (필수 표시 포함)
  Widget _buildLabelText(String label) {
    final responsive = Responsive(context);
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(fontSize: responsive.fontM),
        children: const [
          TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  /// 도움말 텍스트 위젯 (성공/에러 메시지)
  Widget _helperText(String message, {bool isError = false}) {
    final responsive = Responsive(context);
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.itemSpacing),
      child: Row(
        children: [
          Icon(
            isError ? Icons.close : Icons.check,
            size: responsive.fontSmall,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            message,
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontSize: responsive.fontSmall,
            ),
          ),
        ],
      ),
    );
  }

  /// 약관 동의 바텀시트 표시
  void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TermsBottomSheet(),
    );
  }
}

/// 에러 다이얼로그 표시
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB5457),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('확인', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

