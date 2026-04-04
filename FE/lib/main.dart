import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_hi/main_screen.dart';
import 'package:safe_hi/provider/id/report_id.dart';
import 'package:safe_hi/provider/nav/bottom_nav_provider.dart';
import 'package:safe_hi/service/user_service.dart';
import 'package:safe_hi/view/login/login_page.dart';
import 'package:safe_hi/view_model/signup_view_model.dart';
import 'package:safe_hi/view_model/user_view_model.dart';
import 'package:safe_hi/repository/report_repository.dart';
import 'package:safe_hi/service/report_service.dart';
import 'package:safe_hi/view_model/report_view_model.dart';
import 'package:safe_hi/util/connectivity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_hi/view_model/visit/visit_call_view_model.dart';
import 'package:safe_hi/view_model/today_visit_view_model.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

// 모든 인증서 강제 허용(보안 문제 발생 위험 가능, 서버 인증서 문제 때문)
class MyHttpOverrides extends HttpOverrides { // 임시 추가(ssl 무시)
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userVM = UserViewModel(UserService());
  // 앱 시작 시 자동 로그인 시도
  await userVM.tryAutoLogin();

  // await Firebase.initializeApp(); // firebase 실행
  HttpOverrides.global = MyHttpOverrides(); // ssl 인증 무시

  runApp(
    ConnectivityWrapper(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserViewModel>.value(value: userVM),
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ChangeNotifierProvider(create: (_) => ReportIdProvider()),
          ChangeNotifierProvider(
            create: (_) => ReportViewModel(
              repository: ReportRepository(service: ReportService()),
            )..fetchTargets(),
          ),
          ChangeNotifierProvider(create: (_) => VisitCallViewModel()),
          ChangeNotifierProvider(create: (_) => TodayVisitViewModel()),
          ChangeNotifierProvider(create: (_) => SignupViewModel()), // 이미 등록되어 있는지 확인
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _networkChecked = false;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialNetwork();
  }

  Future<void> _checkInitialNetwork() async {
    final connected = await isInternetAvailable();
    
    setState(() {
      _hasInternet = connected;
      _networkChecked = true;
    });

    if (!connected) {
      _showNetworkDialog();
    } else {
      // 네트워크 연결 시 자동 로그인 재시도
      _tryAutoLoginAfterNetwork();
    }
  }

  // 네트워크 연결 후 자동 로그인 재시도
  Future<void> _tryAutoLoginAfterNetwork() async {
    if (!mounted) return;
    
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    if (!userVM.isLoggedIn) {
      debugPrint('[NETWORK] 네트워크 연결 후 자동 로그인 재시도');
      await userVM.tryAutoLogin();
    }
  }

  void _showNetworkDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('인터넷 연결 없음'),
          content: const Text('인터넷이 연결되어 있지 않습니다.\n연결 후 다시 시도해주세요.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _checkInitialNetwork(); // 다시 시도
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<UserViewModel>().isLoggedIn;

    // 네트워크 체크가 완료되지 않았으면 스플래시 화면 표시
    if (!_networkChecked) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 로고 (있다면)
                // Image.asset(
                //   'assets/images/logoicon.png',
                //   width: 120,
                //   height: 120,
                // ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Color(0xFFFB5457),
                ),
                const SizedBox(height: 20),
                const Text(
                  '로딩 중...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 전역 폰트 적용
      theme: ThemeData(
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(height: 1.4),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      home: _hasInternet
          ? (isLoggedIn ? const MainScreen() : const LoginPage())
          : const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '인터넷 연결을 확인해주세요',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}