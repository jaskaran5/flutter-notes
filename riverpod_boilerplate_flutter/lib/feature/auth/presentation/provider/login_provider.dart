import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data_source/auth_data_source.dart';
import '../../data/repositories/auth_repo_implementation.dart';
import '../../domain/usecases/get_auth.dart';
import 'state_notifiers/login_notifiers.dart';
import 'states/auth_states.dart';

// Define a Provider for AuthDataSource
final authDataProvider = Provider.autoDispose<AuthDataSource>((ref) => AuthDataSourceImpl());

// Define a Provider for AuthRepository
final authRepoProvider = Provider.autoDispose<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataProvider);
  return AuthRepoImpl(dataSource: dataSource);
});

// Define a Provider for AuthUseCase
final authUseCaseProvider = Provider.autoDispose<AuthUseCase>((ref) {
  final repository = ref.watch(authRepoProvider);
  return AuthUseCaseImpl(repository: repository);
});

// Define a StateNotifierProvider for LoginNotifier
final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) {
  final authUseCase = ref.watch(authUseCaseProvider);
  return LoginNotifier(authUseCase: authUseCase);
});
