import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/view_model/visit/visit_call_view_model.dart';
import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
import 'package:safe_hi/widget/button/bottom_two_btn.dart';
import 'package:safe_hi/util/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitCallReady extends StatefulWidget {
  final String phoneNumber;
  final int reportId;

  const VisitCallReady({
    super.key,
    required this.phoneNumber,
    required this.reportId,
  });

  @override
  State<VisitCallReady> createState() => _VisitCallReadyState();
}

class _VisitCallReadyState extends State<VisitCallReady> {
  bool _fileUploaded = false;
  File? _selectedAudioFile;
  late AudioPlayer _audioPlayer;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final Uri launchUri =
                  Uri(scheme: 'tel', path: widget.phoneNumber);
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('전화 앱을 실행할 수 없습니다.')),
                );
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav', 'mp3', 'm4a', 'webm'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _selectedAudioFile = file;
        _fileUploaded = true;
      });

      await _audioPlayer.setFilePath(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('파일 선택이 취소되었습니다.')),
      );
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: responsive.sectionSpacing * 3),
                      Center(
                        child: Icon(Icons.phone_in_talk,
                            size: responsive.isTablet ? 140 : 100,
                            color: Colors.redAccent),
                      ),
                      SizedBox(height: responsive.sectionSpacing),
                      _buildInfoCard(responsive),
                      SizedBox(height: responsive.sectionSpacing),
                      _buildNoticeCard(responsive),
                      SizedBox(height: responsive.sectionSpacing),
                      if (_selectedAudioFile != null)
                        _buildAudioCard(responsive),
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
        child: BottomTwoButton(
          buttonText1: '파일 업로드',
          buttonText2: _fileUploaded ? '완료' : '전화 상담 시작',
          onButtonTap1: () async {
            await _pickAudioFile();
          },
          onButtonTap2: () async {
            if (!_fileUploaded) {
              _showDialog(
                title: '녹음 안내',
                content: '전화 상담을 시작하면 반드시 앱에서 녹음을 시작해야 합니다.',
              );
            } else {
              if (_selectedAudioFile == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('녹음 파일이 선택되지 않았습니다.')),
                );
                return;
              }
              try {
                final viewModel = context.read<VisitCallViewModel>();
                await viewModel.uploadCallRecord(
                  reportId: widget.reportId,
                  audioFile: _selectedAudioFile!,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('녹음 파일 업로드가 완료되었습니다.')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('업로드 실패: $e')),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(Responsive responsive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.mic, color: Colors.redAccent, size: 60),
          SizedBox(height: 12),
          Text(
            '전화 중에는 반드시 녹음을 시작해 주세요.',
            style: TextStyle(
              color: Colors.black,
              fontSize: responsive.fontBase,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            '녹음하지 않으면 상담 내용을 확인할 수 없습니다.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: responsive.fontSmall,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(Responsive responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '📢 꼭 확인하세요!',
            style: TextStyle(
              fontSize: responsive.fontBase,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '전화 상담이 끝나면 앱으로 돌아와 녹음 파일을 꼭 업로드해 주세요.',
            style: TextStyle(
              fontSize: responsive.fontSmall,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioCard(Responsive responsive) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '선택된 파일: ${path.basename(_selectedAudioFile!.path)}',
            style: TextStyle(
              color: Colors.black87,
              fontSize: responsive.fontSmall,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async => await _audioPlayer.play(),
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () async => await _audioPlayer.pause(),
              ),
              SizedBox(width: 12),
              Text(
                "${formatDuration(_currentPosition)} / ${formatDuration(_totalDuration)}",
                style: TextStyle(
                  fontSize: responsive.fontSmall,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
