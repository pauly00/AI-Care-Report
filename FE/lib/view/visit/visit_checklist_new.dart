import 'package:flutter/material.dart';
import 'package:safe_hi/view/visit/visit_report.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';

/// 현장 체크리스트 화면 - 방문 상태 체크 및 담당자 메모 작성
class CheckListNew extends StatefulWidget {
  const CheckListNew({super.key});

  @override
  State<CheckListNew> createState() => _CheckListNewState();
}

class _CheckListNewState extends State<CheckListNew> {
  // 각 카드의 선택 인덱스 상태 (-1은 아무 것도 선택 안 함)
  final Map<String, int> _selectedIndex = {
    '건강상태-1': 0,
    '식사기능': 0,
    '건강상태-2': 0,
    '건강상태-3': 0,
  };

  // 메모 입력 컨트롤러 - 더미값으로 초기화
  final TextEditingController _memoController = TextEditingController(
    text: '오늘 아침 방문 시 대상자께서는 전날보다 안색이 밝아 보였으며, 아침 식사도 비교적 잘 드신 상태였습니다.\n\n다만 무릎 통증이 여전히 지속되어 장시간 보행은 힘들어 하셨습니다. 통증이 심하지는 않으나 날씨가 습하면 더 불편함을 느끼시는 것으로 보입니다.',
  );

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFFB5457);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const DefaultBackAppBar(title: '현장 체크'),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 섹션 헤더
              const _SectionHeader(text: '상태 변화 관리'),
              const SizedBox(height: 12),

              // 건강상태 체크카드 1
              _StatusCard(
                title: '건강상태',
                keyId: '건강상태-1',
                options: const ['양호', '주의', '위급'], // 더미값 - 추후 API 연동 필요
                selectedIndex: _selectedIndex['건강상태-1'] ?? -1,
                onChanged: (i) => setState(() => _selectedIndex['건강상태-1'] = i),
              ),
              const SizedBox(height: 12),

              // 식사기능 체크카드
              _StatusCard(
                title: '식사기능',
                keyId: '식사기능',
                options: const ['양호', '보통', '불량'], // 더미값 - 추후 API 연동 필요
                selectedIndex: _selectedIndex['식사기능'] ?? -1,
                onChanged: (i) => setState(() => _selectedIndex['식사기능'] = i),
              ),
              const SizedBox(height: 12),

              // 건강상태 체크카드 2
              _StatusCard(
                title: '건강상태',
                keyId: '건강상태-2',
                options: const ['양호', '보통', '불량'], // 더미값 - 추후 API 연동 필요
                selectedIndex: _selectedIndex['건강상태-2'] ?? -1,
                onChanged: (i) => setState(() => _selectedIndex['건강상태-2'] = i),
              ),
              const SizedBox(height: 12),

              // 건강상태 체크카드 3
              _StatusCard(
                title: '건강상태',
                keyId: '건강상태-3',
                options: const ['양호', '보통', '불량'], // 더미값 - 추후 API 연동 필요
                selectedIndex: _selectedIndex['건강상태-3'] ?? -1,
                onChanged: (i) => setState(() => _selectedIndex['건강상태-3'] = i),
              ),

              const SizedBox(height: 28),

              // 담당자 메모 섹션
              const _SectionHeader(text: '담당자 메모'),
              const SizedBox(height: 12),

              // 메모 입력란
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Color(0xFFEFEFEF)),
                ),
                child: TextField(
                  controller: _memoController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // 하단 다음 버튼
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // 돌봄 완료 페이지로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const VisitReportPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              '다음',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 섹션 헤더 위젯
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF3E3E3E),
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// 상태 체크 카드 위젯 - 좌측 타이틀과 우측 3개 옵션
class _StatusCard extends StatelessWidget {
  final String title;
  final String keyId;
  final List<String> options; // 3개 옵션 가정
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _StatusCard({
    required this.title,
    required this.keyId,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(16);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: border,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: Color(0xFFEFEFEF)),
      ),
      child: Row(
        children: [
          // 좌측 항목명
          SizedBox(
            width: 86,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF7A7A7A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // 우측 체크 옵션들
          Expanded(
            child: Wrap(
              spacing: 28,
              runSpacing: 8,
              children: List.generate(3, (i) {
                final label = options[i];
                final checked = selectedIndex == i;
                return _CheckOption(
                  label: label,
                  checked: checked,
                  onTap: () => onChanged(i),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// 체크박스와 라벨을 포함한 옵션 위젯
class _CheckOption extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _CheckOption({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFFB5457);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 체크박스
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: checked ? red : Colors.black87,
                width: 2,
              ),
              color: checked ? red : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: checked
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 10),
          // 라벨 텍스트
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}