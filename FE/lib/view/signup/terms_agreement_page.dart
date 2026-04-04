import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view_model/signup_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/signup/signup_form_page.dart';

import '../login/login_page.dart';

class TermsAgreementPage extends StatefulWidget {
  const TermsAgreementPage({super.key});

  @override
  State<TermsAgreementPage> createState() => _TermsAgreementPageState();
}

class _TermsAgreementPageState extends State<TermsAgreementPage> {
  bool _allAgreeValue = false;
  bool _agreeTerms = false;
  bool _agreePrivacy = false;
  bool _agreeThirdParty = false;

  bool get _allIndividualAgree =>
      _agreeTerms && _agreePrivacy && _agreeThirdParty;

  void _updateOverallCheckbox() {
    setState(() {
      _allAgreeValue = _allIndividualAgree;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '약관 동의'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingHorizontal,
                ),
                child: Column(
                  children: [
                    SizedBox(height: responsive.sectionSpacing),
                    Text(
                      '서비스 시작 및 가입을 위해\n먼저 아래 약관에 동의해주세요.',
                      style: TextStyle(
                        fontSize: responsive.fontBase,
                        color: const Color(0xFF433A3A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.sectionSpacing),
                    CheckboxListTile(
                      value: _allAgreeValue,
                      onChanged: (value) {
                        setState(() {
                          _allAgreeValue = value ?? false;
                          _agreeTerms = _allAgreeValue;
                          _agreePrivacy = _allAgreeValue;
                          _agreeThirdParty = _allAgreeValue;
                        });
                      },
                      title: Text(
                        '필수 전체 동의',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.fontBase,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: const Color(0xFFFB5457),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    _buildTermItem(
                      '(필수) 이용약관 동의',
                      _agreeTerms,
                      (value) {
                        setState(() {
                          _agreeTerms = value ?? false;
                          _updateOverallCheckbox();
                        });
                      },
                      responsive,
                    ),
                    _buildTermItem(
                      '(필수) 개인정보 수집 및 이용동의',
                      _agreePrivacy,
                      (value) {
                        setState(() {
                          _agreePrivacy = value ?? false;
                          _updateOverallCheckbox();
                        });
                      },
                      responsive,
                    ),
                    _buildTermItem(
                      '(필수) 개인정보 제3자 제공 동의',
                      _agreeThirdParty,
                      (value) {
                        setState(() {
                          _agreeThirdParty = value ?? false;
                          _updateOverallCheckbox();
                        });
                      },
                      responsive,
                    ),
                    const Spacer(),
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
        child: BottomOneButton(
          buttonText: '다음',
          isEnabled: _allIndividualAgree,
          onButtonTap: () {
            if (_allIndividualAgree) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => SignupViewModel(),
                    child: const LoginPage(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTermItem(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
    Responsive responsive,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(fontSize: responsive.fontBase),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: const Color(0xFFFB5457),
      contentPadding: EdgeInsets.zero,
    );
  }
}
