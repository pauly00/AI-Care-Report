import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/view/login/login_page.dart';
import 'package:safe_hi/widget/appbar/default_appbar.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 사용자 정보 가져오기
    final userVM = Provider.of<UserViewModel>(context);
    final username = userVM.user?.name ?? 'OOO';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          children: [
            // 커스텀 앱바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFFB5457),
                      size: 28,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '마이페이지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF433A3A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // 좌우 대칭을 위한 공간
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      // 사용자 프로필 섹션
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // 프로필 이미지
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xFFFFF8F8),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/profile.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // 사용자 이름 및 주소
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${username}님',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF433A3A),
                                    ),
                                  ),
                                  Text( // 임의의 주소, 추후 연동 필요
                                    '대전 동구 마산동',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFB3A5A5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // 정보 수정 버튼
                          GestureDetector(
                            onTap: () { // 추후 navigator로 페이지 추가 필요
                              print('내 정보 수정 버튼 클릭');
                            },
                            child: const Text(
                              '내 정보 수정',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3A5A5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 활동 통계 카드
                      Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFDD8DA).withValues(alpha: 0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 연간 방문 수
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '방문',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('1년 기준', style: TextStyle(fontSize: 9)),
                                SizedBox(height: 5),
                                Text(
                                  '289',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFB5457),
                                  ),
                                ),
                              ],
                            ),

                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 30,
                            ),

                            // 월간 방문 수
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '방문',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('한 달 기준', style: TextStyle(fontSize: 9)),
                                SizedBox(height: 5),
                                Text(
                                  '32',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFB5457),
                                  ),
                                ),
                              ],
                            ),

                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 30,
                            ),

                            // 담당 가구 수
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '담당 가구',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('', style: TextStyle(fontSize: 9)),
                                SizedBox(height: 5),
                                Text(
                                  '11',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFB5457),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 메인 메뉴 리스트
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            // 고객센터
                            GestureDetector(
                              onTap: () { // 추후 navigator로 페이지 추가 필요
                                print('고객센터 버튼 클릭');
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 30,
                                    color: Color(0xFFFB5457),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '고객센터',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF433A3A),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFFB3A5A5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 공지사항
                            GestureDetector(
                              onTap: () { // 추후 navigator로 페이지 추가 필요
                                print('공지사항 버튼 클릭');
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.document_scanner,
                                    size: 30,
                                    color: Color(0xFFFB5457),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '공지사항',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF433A3A),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFFB3A5A5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 자주 묻는 질문
                            GestureDetector(
                              onTap: () {// 추후 navigator로 페이지 추가 필요
                                print('자주 묻는 질문 버튼 클릭');
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.chat,
                                    size: 30,
                                    color: Color(0xFFFB5457),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '자주 묻는 질문',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF433A3A),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFFB3A5A5),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 약관 및 동의
                            GestureDetector(
                              onTap: () { // 추후 navigator로 페이지 추가 필요
                                print('약관 및 동의 버튼 클릭');
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 30,
                                    color: Color(0xFFFB5457),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '약관 및 동의',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF433A3A),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFFB3A5A5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // 설정 및 로그아웃 카드
                      Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFDD8DA).withValues(alpha: 0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 앱 설정
                            GestureDetector(
                              onTap: () { // 추후 navigator로 페이지 추가 필요
                                print('앱 설정 버튼 클릭');
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 25,
                                    color: Color(0xFFB3A5A5),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '앱 설정',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFB3A5A5),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              width: 30,
                            ),

                            // 로그아웃 (사용자 세션 종료)
                            GestureDetector(
                              onTap: () async {
                                final userVM = Provider.of<UserViewModel>(context, listen: false);
                                await userVM.logout();

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                      (route) => false,
                                );
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                      Icons.logout,
                                      size: 25,
                                      color: Color(0xFFB3A5A5)
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '로그아웃',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFFB3A5A5)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // 홈으로 이동하는 고정 버튼
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFB5457),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  '홈으로 가기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 개발 중인 기능들을 위한 임시 페이지
class TodoPage extends StatelessWidget {
  final String title;

  const TodoPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFB5457),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TODO',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFB5457),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$title 페이지',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF433A3A),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB5457),
                foregroundColor: Colors.white,
              ),
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}