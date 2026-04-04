import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';

class Report5Conversation extends StatefulWidget {
  const Report5Conversation({super.key});

  @override
  State<Report5Conversation> createState() => _Report5ConversationState();
}

class _Report5ConversationState extends State<Report5Conversation> {
  String? conversationText;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    final reportId = context.read<ReportViewModel>().selectedTarget?.reportId;

    if (reportId == null) return;

    try {
      await context.read<ReportViewModel>().fetchConversationText(reportId);
      setState(() {
        conversationText = context.read<ReportViewModel>().conversationText;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ 텍스트 불러오기 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '상담내용 전체 보기'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: responsive.sectionSpacing), // ✅ 여백 추가
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(responsive.cardSpacing),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFFDD8DA),
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Text(
                                conversationText ?? '내용이 없습니다.',
                                style: TextStyle(fontSize: responsive.fontBase),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomOneButton(
          buttonText: '닫기',
          onButtonTap: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
