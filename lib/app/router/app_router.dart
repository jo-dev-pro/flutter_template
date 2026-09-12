import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 💡 Riverpod Generator가 자동으로 생성할 파일명을 지정합니다. (파일명.g.dart)
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/', // 앱이 켜졌을 때 처음 보여줄 경로
    
    // 💡 라우트 경로 정의
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // 하위 라우트로 상세 페이지 등록 (이동 시 /detail 구조가 됨)
          GoRoute(
            path: 'detail',
            name: 'detail',
            builder: (context, state) => const DetailScreen(),
          ),
        ],
      ),
    ],

    // 💡 [실무 팁] 로그인 여부에 따른 페이지 리다이렉트 처리가 필요할 때 사용합니다.
    redirect: (context, state) {
      // 여기에 유저 로그인 상태 프로바이더를 watch(구독)하여 
      // 로그인 안 된 유저를 /login 페이지로 강제 이동시키는 로직을 넣을 수 있습니다.
      return null; 
    },
  );
}

// ----------------------------------------------------
// ⚠️ 테스트를 위한 임시 화면 위젯 (나중에 실제 화면 파일로 분리하세요)
// ----------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.goNamed('detail'), // GoRouter 이동 방식
          child: const Text('상세 페이지로 이동'),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세 화면')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.goNamed('home'),
          child: const Text('홈으로 돌아가기'),
        ),
      ),
    );
  }
}
