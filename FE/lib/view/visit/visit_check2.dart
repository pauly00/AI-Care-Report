import 'package:flutter/material.dart';
import 'package:safe_hi/provider/id/report_id.dart';
import 'package:safe_hi/view/visit/visit_welfare_recommend.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:provider/provider.dart';

class Check2 extends StatelessWidget {
  const Check2({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VisitPolicyViewModel>(
      create: (_) => VisitPolicyViewModel(),
      builder: (context, child) => const _Check2Body(),
    );
  }
}

class _Check2Body extends StatefulWidget {
  const _Check2Body();

  @override
  State<_Check2Body> createState() => _Check2BodyState();
}

class _Check2BodyState extends State<_Check2Body> {
  final List<String> checklistItems = [
    '집 안에 약 봉투가 계속 쌓여있다.',
    '집 안의 온도와 무관하게 맞지 않는 옷을 입고 있다.',
    '집 주변에 파리, 구더기 등 벌레가 보이고 악취가 난다.',
  ];

  List<bool> isChecked = List.generate(3, (_) => false);

  int? selectedMealCondition;
  int? selectedCognitiveCondition;
  int? selectedCommunicationCondition;

  bool _isAllChecked() {
    return selectedMealCondition != null &&
        selectedCognitiveCondition != null &&
        selectedCommunicationCondition != null;
  }

  @override
  Widget build(BuildContext context) {
    final vmPolicy = context.watch<VisitPolicyViewModel>();
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            DefaultBackAppBar(title: '현장체크'),
            SizedBox(height: responsive.itemSpacing),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingHorizontal),
              child: Text(
                '상태 변화 관리',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: responsive.fontXL,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: responsive.sectionSpacing),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...checklistItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        String item = entry.value;
                        return _buildChecklistItem(index, item, responsive);
                      }),
                      SizedBox(height: responsive.itemSpacing),
                      _buildConditionSection('식사 기능', (value) {
                        setState(() {
                          selectedMealCondition = value;
                        });
                      }, selectedMealCondition, responsive),
                      SizedBox(height: responsive.itemSpacing),
                      _buildConditionSection('인지 기능', (value) {
                        setState(() {
                          selectedCognitiveCondition = value;
                        });
                      }, selectedCognitiveCondition, responsive),
                      SizedBox(height: responsive.itemSpacing),
                      _buildConditionSection('의사 기능', (value) {
                        setState(() {
                          selectedCommunicationCondition = value;
                        });
                      }, selectedCommunicationCondition, responsive),
                    ],
                  ),
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
          onButtonTap: () async {
            final reportId = context.read<ReportIdProvider>().reportId;
            debugPrint('[타겟id!!!] : ${reportId}');

            if (reportId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('대상자를 먼저 선택해주세요.')),
              );
              return;
            }

            final welfareList =
                await vmPolicy.fetchWelfarePolicies(reportId); // ✅ 이제 OK
            if (!mounted) return;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WelfareRecommend(welfareData: welfareList),
                ),
              );
            });
          },
          isEnabled: _isAllChecked(),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(int index, String item, Responsive responsive) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: responsive.itemSpacing / 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD8DA).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: isChecked[index],
          activeColor: const Color(0xFFFB5457),
          onChanged: (bool? value) {
            setState(() {
              isChecked[index] = value!;
            });
          },
        ),
        title: Text(
          item,
          style: TextStyle(
            color: Colors.black,
            fontSize: responsive.fontBase,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildConditionSection(
    String title,
    Function(int?) onChanged,
    int? selectedCondition,
    Responsive responsive,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.checkSpacing,
        horizontal: responsive.checkSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFDD8DA).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Wrap(
              spacing: responsive.checkSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.fontM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildConditionCheckbox(
                    '양호', 0, onChanged, selectedCondition, responsive),
                _buildConditionCheckbox(
                    '보통', 1, onChanged, selectedCondition, responsive),
                _buildConditionCheckbox(
                    '불량', 2, onChanged, selectedCondition, responsive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCheckbox(
    String label,
    int index,
    Function(int?) onChanged,
    int? selectedCondition,
    Responsive responsive,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: selectedCondition == index,
          activeColor: const Color(0xFFFB5457),
          onChanged: (bool? value) {
            onChanged(value! ? index : null);
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: responsive.fontM,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
