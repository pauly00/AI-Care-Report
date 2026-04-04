import 'package:flutter/material.dart';
import 'package:safe_hi/model/visit_detail_model.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:safe_hi/view/visit/visit_call_ready.dart';
import 'package:safe_hi/view/visit/widget/drop_box.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safe_hi/view/visit/visit_checklist_ready.dart';

class VisitDetailPage extends StatefulWidget {
  final int reportId;
  final VisitViewModel viewModel;

  const VisitDetailPage({
    Key? key,
    required this.reportId,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends State<VisitDetailPage> {
  VisitDetail? _visit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDetail();
    });
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    try {
      final detail = await widget.viewModel.fetchVisitDetail(widget.reportId);
      setState(() {
        _visit = detail;
      });
    } catch (e) {
      debugPrint('상세 조회 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('전화 연결을 할 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    debugPrint('reportId: ${widget.reportId}');
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultBackAppBar(title: '상세 보기'),
                    SizedBox(height: responsive.sectionSpacing),
                    if (_visit == null)
                      Padding(
                        padding:
                            EdgeInsets.only(top: responsive.screenHeight * 0.2),
                        child: const Center(child: Text('상세 정보가 없습니다.')),
                      )
                    else
                      _buildDetailContent(responsive),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: _visit == null ? null : _buildBottomNav(responsive),
    );
  }

  Widget _buildDetailContent(Responsive responsive) {
    final visit = _visit!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.paddingHorizontal),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                visit.name,
                style: TextStyle(
                  fontSize: responsive.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: responsive.sectionSpacing),
            ],
          ),
          SizedBox(height: responsive.sectionSpacing),
          Container(
            padding: EdgeInsets.all(responsive.sectionSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFDD8DA).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '주소',
                  style: TextStyle(
                    fontSize: responsive.fontBase,
                    color: Color(0xFFB3A5A5),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(visit.address,
                        style: TextStyle(
                          fontSize: responsive.fontBase,
                        )),
                    Text(visit.addressDetails,
                        style: TextStyle(
                          fontSize: responsive.fontBase,
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.sectionSpacing),
          Container(
            padding: EdgeInsets.all(responsive.sectionSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFDD8DA).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '전화번호',
                  style: TextStyle(
                    fontSize: responsive.fontBase,
                    color: Color(0xFFB3A5A5),
                  ),
                ),
                Text(
                    visit.phone.isNotEmpty
                        ? visit.phone
                        : '정보 없음', // ✅ fallback 처리
                    style: TextStyle(
                      fontSize: responsive.fontBase,
                    )),
                InkWell(
                  onTap: visit.phone.isNotEmpty
                      ? () => _makePhoneCall(visit.phone)
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Colors.redAccent),
                      SizedBox(height: 4),
                      Text(
                        '전화걸기',
                        style: TextStyle(
                          fontSize: responsive.fontSmall,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.sectionSpacing),
          Column(
            children: [
              DropdownCard(
                title: '이전 방문',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: visit.lastVisits.map((lv) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: responsive.itemSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lv.date,
                            style: TextStyle(
                              fontSize: responsive.fontBase,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            lv.abstract,
                            style: TextStyle(
                              fontSize: responsive.fontSmall,
                            ),
                          ),
                          Divider(height: responsive.sectionSpacing),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.paddingHorizontal),
      child: BottomTwoButton(
        buttonText1: '전화 상담시작',
        buttonText2: '방문 상담시작',
        onButtonTap1: () {
          if (_visit != null && _visit!.phone.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitCallReady(
                  phoneNumber: _visit!.phone,
                  reportId: widget.reportId,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('전화번호 정보가 없습니다.')),
            );
          }
        },
        onButtonTap2: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckListReady()),
          );
        },
      ),
    );
  }
}
