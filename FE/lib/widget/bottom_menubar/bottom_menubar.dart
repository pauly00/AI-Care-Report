import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart'; // 바 변경 시 해당 파일 임포트 변경
import 'package:safe_hi/util/responsive.dart';

class BottomMenubar extends StatelessWidget {
  const BottomMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    final currentIndex = navProvider.currentIndex;
    final responsive = Responsive(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (newIndex) {
        navProvider.setIndex(newIndex);
      },
      backgroundColor: const Color(0xFFFFFFFF),
      selectedItemColor: const Color(0xFFFB5457),
      unselectedItemColor: const Color(0xFFB3A5A5),
      type: BottomNavigationBarType.fixed,
      selectedFontSize: responsive.fontBase,
      unselectedFontSize: responsive.fontSmall,
      iconSize: responsive.iconSize,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_outlined),
          label: '돌봄 진행',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: '돌봄 기록',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_emotions_outlined),
          label: '리포트 관리',
        ),
      ],
    );
  }
}
