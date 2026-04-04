import 'package:flutter/material.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/repository/report_repository.dart';
import 'package:safe_hi/repository/visit_repository.dart';
import 'package:safe_hi/service/report_service.dart';
import 'package:safe_hi/service/visit_service.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/view_model/signup_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_call_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_list_view_model.dart';
import 'package:safe_hi/view_model/visit/visit_policy_view_model.dart';
import 'package:safe_hi/widget/bottom_menubar/bottom_menubar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(
            create: (_) => VisitViewModel(
                repository: VisitRepository(service: VisitService()))),
        ChangeNotifierProvider(create: (_) => VisitPolicyViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
      ],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<BottomNavProvider>();
    return Scaffold(
      body: navProvider.pages[navProvider.currentIndex],
      bottomNavigationBar: const BottomMenubar(),
    );
  }
}
