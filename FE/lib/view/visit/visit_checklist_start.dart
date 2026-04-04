import 'package:flutter/material.dart';
import 'package:safe_hi/view/visit/visit_checklist_ready.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';

class CheckList extends StatelessWidget {
  const CheckList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultBackAppBar(title: '대화 가이드라인'),
              const SizedBox(height: 70),
              Center(
                child: Text(
                  '체크할 준비가 되었나요?',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  '아직 준비가 되지 않았다면\n스몰토크를 진행해주세요!',
                  style: const TextStyle(
                    color: Color(0xFFB3A5A5),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/3d.png',
                  width: 230,
                  height: 230,
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Text(
                  '스몰토크 하러가기',
                  style: const TextStyle(
                    color: Color(0xFFFB5457),
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFFB5457),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32.0),
        child: BottomOneButton(
          buttonText: '체크리스트 시작하기',
          onButtonTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckListReady()),
            );
          },
        ),
      ),
    );
  }
}
