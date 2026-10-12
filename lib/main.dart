import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/offline_cache.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/theme.dart';

// Lancer avec :
// flutter run --dart-define=SUPABASE_URL=https://xxxx.supabase.co --dart-define=SUPABASE_ANON_KEY=ta_cle_publishable
const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://cnmhgpjotjebxwbpyzfm.supabase.co',
);
const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue: 'sb_publishable_rqDZb2tsseFJVLnxElzPMw_Laqm9Rcv',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final offlineCache = await OfflineCache.open();
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );
  runApp(
    ProviderScope(
      overrides: [
        offlineCacheProvider.overrideWithValue(offlineCache),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Mon École',
      debugShowCheckedModeBanner: false,
      theme: kidsTheme,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
