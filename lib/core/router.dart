import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/children_page.dart';
import '../features/auth/login_page.dart';
import '../features/exercises/quiz_page.dart';
import '../features/home/home_page.dart';
import '../features/lessons/chapters_page.dart';
import '../features/lessons/lesson_page.dart';
import '../features/parent/parent_page.dart';
import 'models.dart';

/// Rafraîchit le routeur à chaque changement de session (connexion / déconnexion).
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Stream<AuthState> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = Supabase.instance.client.auth;

  return GoRouter(
    initialLocation: '/children',
    refreshListenable: _AuthRefresh(auth.onAuthStateChange),
    redirect: (context, state) {
      final loggedIn = auth.currentSession != null;
      final onLogin = state.matchedLocation == '/login';
      if (!loggedIn) return onLogin ? null : '/login';
      if (onLogin) return '/children';
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/login'),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/children', builder: (_, __) => const ChildrenPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(path: '/parent', builder: (_, __) => const ParentPage()),
      GoRoute(
        path: '/subject',
        builder: (_, s) => ChaptersPage(subject: s.extra as Subject),
      ),
      GoRoute(
        path: '/lesson',
        builder: (_, s) => LessonPage(chapter: s.extra as Chapter),
      ),
      GoRoute(
        path: '/quiz',
        builder: (_, s) => QuizPage(chapter: s.extra as Chapter),
      ),
    ],
  );
});
