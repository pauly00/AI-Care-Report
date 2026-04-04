import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/report/target_card.dart';
import 'package:safe_hi/view/report/widget/target_card_data.dart';

class ReportSearchBar extends StatefulWidget {
  const ReportSearchBar({
    super.key,
    required this.r,
    required this.onSearch,
    required this.allTargets,
  });

  final Responsive r;
  final Function(List<TargetCardData>) onSearch; // 검색 결과 콜백
  final List<TargetCardData> allTargets; // 전체 대상자 리스트

  @override
  State<ReportSearchBar> createState() => _ReportSearchBarState();
}

class _ReportSearchBarState extends State<ReportSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 이름 기준 검색 함수
  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      // 검색어가 비어있으면 전체 목록 표시
      widget.onSearch(widget.allTargets);
    } else {
      // 이름에 검색어가 포함된 대상자 필터링
      final filteredTargets = widget.allTargets
          .where((target) => target.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      widget.onSearch(filteredTargets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged, // 검색어 변경 시 실시간 검색
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xFF9D9D9D)),
          hintText: '대상자 이름을 검색해주세요',
          hintStyle: TextStyle(
            color: const Color(0xFF9D9D9D),
            fontSize: widget.r.fontSmall,
          ),
          filled: true,
          fillColor: Colors.transparent, // Container 색상 사용
          contentPadding: EdgeInsets.symmetric(
            vertical: widget.r.itemSpacing,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFFFB5457), // 포커스 시 메인 컬러
              width: 1.5,
            ),
          ),
          // 검색어 지우기 버튼 추가
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF9D9D9D)),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged(''); // 전체 목록으로 초기화
                  },
                )
              : null,
        ),
      ),
    );
  }
}
