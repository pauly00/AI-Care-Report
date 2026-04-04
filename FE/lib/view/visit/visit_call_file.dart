import 'package:flutter/material.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_one_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class VisitCallFile extends StatefulWidget {
  const VisitCallFile({super.key});

  @override
  State<VisitCallFile> createState() => _VisitCallFileState();
}

class _VisitCallFileState extends State<VisitCallFile> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '전화 상담'),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingHorizontal,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: responsive.sectionSpacing * 2),
                        Text(
                          '전화 상담 준비 안내',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.fontXL,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
          buttonText: '완료',
          onButtonTap: () async {},
        ),
      ),
    );
  }
}
