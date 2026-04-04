// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:safe_hi/view_model/visit/visit_summary_view_model.dart';
// import 'package:safe_hi/widget/appbar/default_back_appbar.dart';
// import 'package:safe_hi/widget/button/bottom_one_btn.dart';
// import 'package:safe_hi/model/summary_model.dart'; // SummarySection 정의된 파일

// class VisitComment extends StatelessWidget {
//   final List<SummarySection> summaryData;

//   const VisitComment({super.key, required this.summaryData});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<SummaryViewModel>(
//       create: (_) => SummaryViewModel(initialSummary: summaryData),
//       child: const _VisitCommentBody(),
//     );
//   }
// }

// class _VisitCommentBody extends StatefulWidget {
//   const _VisitCommentBody();

//   @override
//   State<_VisitCommentBody> createState() => _VisitCommentBodyState();
// }

// class _VisitCommentBodyState extends State<_VisitCommentBody> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SummaryViewModel>().fetchSummary();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<SummaryViewModel>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFFFF6F6),
//       body: SafeArea(
//         child: vm.isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Color(0xFFFB5457),
//                   ),
//                 ),
//               )
//             : Column(
//                 children: [
//                   const DefaultBackAppBar(title: '상담코멘트'),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               '요약',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             _buildSummaryContainer(vm.summaryData),
//                             const SizedBox(height: 20),
//                             const Text(
//                               '상담 코멘트 작성',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             _buildCommentBox(),
//                             const SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   BottomOneButton(
//                     buttonText: '완료',
//                     onButtonTap: () async {},
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildSummaryContainer(List<SummarySection> summaryData) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFDD8DA).withValues(alpha: 0.5),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: summaryData.map((summary) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFFB5457)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   summary.title,
//                   style: const TextStyle(
//                     color: Color(0xFFFB5457),
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               ...summary.content.map(
//                 (content) => Padding(
//                   padding: const EdgeInsets.only(bottom: 3),
//                   child: Text(
//                     content,
//                     style: const TextStyle(
//                       color: Color(0xFFB3A5A5),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildCommentBox() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFDD8DA).withValues(alpha: 0.5),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         maxLines: 3,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           hintText: '상담 코멘트를 입력하세요...',
//           hintStyle: TextStyle(color: Colors.grey[400]),
//         ),
//       ),
//     );
//   }
// }
