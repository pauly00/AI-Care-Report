import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';

class BottomMenubar extends StatelessWidget {
  const BottomMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    final currentIndex = navProvider.currentIndex;

    return Material(
      color: Colors.white,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              _BottomMenuItem(
                icon: Icons.home_outlined,
                label: '홈',
                selected: currentIndex == 0,
                onTap: () => navProvider.setIndex(0),
              ),
              _BottomMenuItem(
                icon: Icons.inventory_outlined,
                label: '돌봄 진행',
                selected: currentIndex == 1,
                onTap: () => navProvider.setIndex(1),
              ),
              _BottomMenuItem(
                icon: Icons.library_books,
                label: '돌봄 기록',
                selected: currentIndex == 2,
                onTap: () => navProvider.setIndex(2),
              ),
              _BottomMenuItem(
                icon: Icons.emoji_emotions_outlined,
                label: '리포트 관리',
                selected: currentIndex == 3,
                onTap: () => navProvider.setIndex(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomMenuItem extends StatelessWidget {
  const _BottomMenuItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFFB5457) : const Color(0xFFB3A5A5);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
