import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 💡 Riverpod Generator가 자동으로 생성할 파일명 (build_runner 실행 필요)
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.homePath, // 시작 경로

    // 💡 라우트 경로 정의
    routes: [
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // 1. 상세 페이지 (Path Parameter :id 방식)
          GoRoute(
            path: AppRoutes.detailPath,
            name: AppRoutes.detailName,
            builder: (context, state) {
              // URL 경로의 :id 값 추출
              final id = state.pathParameters['id'] ?? 'unknown';
              return DetailScreen(id: id);
            },
          ),

          // 2. 세번째/추가 페이지 (Extra Object 또는 Query Parameter 방식)
          GoRoute(
            path: AppRoutes.secondPath,
            name: AppRoutes.secondName,
            builder: (context, state) {
              // extra 객체 수신
              final extraData = state.extra as String?;
              // query parameter 수신 (?from=...)
              final from = state.uri.queryParameters['from'];

              return SecondScreen(
                extraData: extraData,
                from: from,
              );
            },
          ),
        ],
      ),
    ],

    // 💡 로그인 여부에 따른 페이지 리다이렉트 처리
    redirect: (context, state) {
      return null;
    },
  );
}

// ----------------------------------------------------
// 📌 라우트 상수 정의 (한곳에서 관리)
// ----------------------------------------------------
abstract class AppRoutes {
  // Home
  static const String homePath = '/';
  static const String homeName = 'home';

  // Detail with Path Parameter (예: /detail/123)
  static const String detailPath = 'detail/:id';
  static const String detailName = 'detail';

  // Second Page with Extra / Query Parameter
  static const String secondPath = 'second';
  static const String secondName = 'second';
}

// ----------------------------------------------------
// ⚠️ 화면 위젯들 (실제 프로젝트에서는 각각의 파일로 분리)
// ----------------------------------------------------

/// 1. 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 화면')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. DetailScreen으로 이동 (Path Parameter 넘기기)
            ElevatedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.detailName,
                  pathParameters: {'id': '42'}, // ID 42 전달 -> /detail/42
                );
              },
              child: const Text('상세 페이지로 이동 (ID: 42)'),
            ),
            const SizedBox(height: 16),

            // 2. SecondScreen으로 이동 (Extra & Query Parameter 넘기기)
            ElevatedButton(
              onPressed: () {
                context.goNamed(
                  AppRoutes.secondName,
                  queryParameters: {'from': 'HomeScreen'}, // ?from=HomeScreen
                  extra: '전달할 데이터 객체 또는 텍스트', // extra 데이터 전달
                );
              },
              child: const Text('두 번째 페이지로 이동 (Extra/Query)'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. 상세 화면 (ID 전달 받음)
class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상세 화면 (ID: $id)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '전달받은 ID: $id',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.homeName),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. 두 번째 화면 (Extra 및 Query Parameter 전달 받음)
class SecondScreen extends StatelessWidget {
  final String? extraData;
  final String? from;

  const SecondScreen({
    super.key,
    this.extraData,
    this.from,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('두 번째 화면')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Query (from): ${from ?? "없음"}'),
            const SizedBox(height: 8),
            Text('Extra Data: ${extraData ?? "없음"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.homeName),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}