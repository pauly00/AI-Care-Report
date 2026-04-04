import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view/report/report_5_conversation.dart';
import 'package:safe_hi/view/report/report_6.dart';
import 'package:safe_hi/view/report/widget/report_step_header.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';

// 미사용 코드

class Report5 extends StatefulWidget {
  const Report5({super.key});

  @override
  State<Report5> createState() => _Report5State();
}

class _Report5State extends State<Report5> {
  final List<XFile> _selectedImages = [];
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    setState(() => _isLoading = true);
    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const DefaultBackAppBar(title: '돌봄 리포트'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.paddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReportStepHeader(
                      currentStep: 5,
                      totalSteps: 6,
                      stepTitle: 'step 5',
                      stepSubtitle: '부록/첨부',
                    ),
                    SizedBox(height: responsive.sectionSpacing * 1.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Report5Conversation()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: responsive.buttonHeight * 1.3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEAEA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📋',
                                style: TextStyle(fontSize: responsive.fontXL)),
                            SizedBox(height: responsive.itemSpacing / 2),
                            Text('상담내용 전체 보기',
                                style: TextStyle(
                                    fontSize: responsive.fontBase,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: responsive.buttonHeight * 1.3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEAEA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📎',
                                style: TextStyle(fontSize: responsive.fontXL)),
                            SizedBox(height: responsive.itemSpacing / 2),
                            Text('사진 첨부하기',
                                style: TextStyle(
                                    fontSize: responsive.fontBase,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.itemSpacing),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (_selectedImages.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: responsive.itemSpacing),
                        child: Wrap(
                          spacing: responsive.itemSpacing / 2,
                          runSpacing: responsive.itemSpacing / 2,
                          children: List.generate(_selectedImages.length, (i) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImages[i].path),
                                    width: responsive.imageReportSize,
                                    height: responsive.imageReportSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(i),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.close,
                                          color: Colors.white,
                                          size: responsive.fontSmall),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    SizedBox(height: responsive.sectionSpacing * 1.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: responsive.paddingHorizontal),
        child: BottomTwoButton(
            buttonText1: '이전',
            buttonText2: '다음'.padLeft(14).padRight(28),
            onButtonTap1: () => Navigator.pop(context),
            onButtonTap2: () async {
              final reportId =
                  context.read<ReportViewModel>().selectedTarget?.reportId;

              if (reportId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('리포트 ID가 없습니다.')),
                );
                return;
              }

              try {
                if (_selectedImages.isNotEmpty) {
                  final imageFiles =
                      _selectedImages.map((xfile) => File(xfile.path)).toList();

                  await context
                      .read<ReportViewModel>()
                      .uploadImages(reportId, imageFiles);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Report6()),
                );
              } catch (e) {
                debugPrint('❌ 이미지 업로드 실패: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('이미지 전송 실패: $e')),
                );
              }
            }),
      ),
    );
  }
}
