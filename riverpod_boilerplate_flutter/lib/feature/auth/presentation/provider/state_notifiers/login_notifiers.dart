import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/helpers/all_getter.dart';
import '../../../domain/usecases/get_auth.dart';
import '../states/auth_states.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthUseCase authUseCase;
  final phoneController = TextEditingController(text: kDebugMode ? "9876543210" : "");
  final otpController = TextEditingController(text: kDebugMode ? "1234" : "");
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final referralController = TextEditingController();

  LoginNotifier({required this.authUseCase}) : super(LoginInitial());

  Future<void> login() async {
    state = LoginApiLoading();
    try {
      if (!(await Getters.networkInfo.isConnected)) {
        state = const LoginFailed(error: "No internet connection");
        return;
      }
      if (await Getters.networkInfo.isSlow) {

      }
      Map<String, dynamic> body = {
        "email": "dev@yopmail.com",
        "password": "Pass@123",
        "device_type": "android",
        "device_token": "No Token",
      };
      final result = await authUseCase.callLogin(body: body);
      state = result.fold((error) {
        return LoginFailed(error: error.message);
      }, (result) {
        return LoginSuccess();
      });
    } catch (e) {
      state = LoginFailed(error: e.toString());
    }
  }
}
