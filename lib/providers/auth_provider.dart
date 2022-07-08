import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:indal/presentation/notifiers/auth/auth_notifier.dart';
import 'package:indal/providers/dependencies_provider.dart';

final authCubit = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  //O pasar directamente el ref para que busque los repositorios que necesita

  return AuthNotifier(ref.read(authRepository))..init();
});
