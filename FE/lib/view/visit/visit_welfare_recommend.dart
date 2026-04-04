import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';
import 'package:safe_hi/widget/loading/common_loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safe_hi/model/welfare_policy_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/main_screen.dart';
import 'package:safe_hi/util/responsive.dart';

class WelfareRecommend extends StatefulWidget {
  final List<WelfarePolicy> welfareData;

  const WelfareRecommend({super.key, required this.welfareData});

  @override
  State<WelfareRecommend> createState() => _WelfareRecommendState();
}

class _WelfareRecommendState extends State<WelfareRecommend> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (widget.welfareData.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: isLoading
            ? const CommonLoading(
                message: '어르신께 필요한 정보를 찾고 있습니다!',
              )
            : Column(
                children: [
                  const DefaultBackAppBar(title: 'AI 복지정책'),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.paddingHorizontal,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'AI 추천 복지 서비스',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: responsive.fontXL,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: responsive.itemSpacing),
                                Text(
                                  '어르신께 맞는 복지 서비스를 찾아봤어요.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: responsive.fontBase,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: responsive.itemSpacing),
                          ..._buildPolicyWidgets(
                            widget.welfareData,
                            responsive,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: isLoading
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
              child: BottomOneButton(
                buttonText: '완료',
                onButtonTap: () {
                  Provider.of<BottomNavProvider>(context, listen: false)
                      .setIndex(0);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
    );
  }

  List<Widget> _buildPolicyWidgets(
      List<WelfarePolicy> policyList, Responsive responsive) {
    return policyList.map((policy) {
      return Padding(
        padding: EdgeInsets.only(bottom: responsive.itemSpacing),
        child: _buildWelfareBox(policy, responsive),
      );
    }).toList();
  }

  Widget _buildWelfareBox(WelfarePolicy policy, Responsive responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.sectionSpacing),
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
          Text(
            policy.policyName,
            style: TextStyle(
              color: const Color(0xFFFB5457),
              fontSize: responsive.fontBase,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.itemSpacing / 2),
          Text(
            policy.shortDescription,
            style: TextStyle(
              color: Colors.black,
              fontSize: responsive.fontSmall,
            ),
          ),
          SizedBox(height: responsive.itemSpacing),
          Text(
            '세부정보',
            style: TextStyle(
              color: Colors.black,
              fontSize: responsive.fontSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.itemSpacing / 2),
          Text(
            '- 신청을 위해선 아래의 것들이 필요합니다.',
            style: TextStyle(
              color: Colors.black,
              fontSize: responsive.fontSmall,
            ),
          ),
          SizedBox(height: responsive.itemSpacing / 2),
          for (var condition in policy.detailedConditions)
            Text(
              ' > $condition',
              style: TextStyle(
                color: Colors.black,
                fontSize: responsive.fontSmall,
              ),
            ),
          SizedBox(height: responsive.itemSpacing),
          Center(
            child: InkWell(
              onTap: () => _launchURL(policy.link),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.isTablet ? 10 : 5,
                  horizontal: responsive.isTablet ? 200 : 110,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFB5457),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "자세히 보기",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.fontSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
