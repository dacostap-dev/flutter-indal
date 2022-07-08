import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indal/data/repository/local/auth_local_impl.dart';
import 'package:indal/domain/repository/auth_repository.dart';

final authRepository = Provider<AuthRepository>((ref){
  return AuthLocalImplementation();
});
