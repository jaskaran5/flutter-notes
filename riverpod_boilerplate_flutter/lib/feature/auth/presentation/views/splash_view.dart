import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_boilerplate_flutter/config/helper.dart';
import 'package:riverpod_boilerplate_flutter/feature/common_widgets/custom_toast.dart';
import '../../../../core/utils/routing/routes.dart';
import '../../../common_widgets/app_text.dart';
import '../provider/login_provider.dart';
import '../provider/states/auth_states.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final loginData = ref.read(loginProvider.notifier);
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        offAllNamed(context, Routes.home);
       // toNamed(context, Routes.home);
      /*  final userModel = Getters.getLocalStorage.getLoginUser();
        if (userModel?.isComplete == 1) {
          offAllNamed(context, Routes.bottomNavbar);
        } else {
          toNamed(context, Routes.addPersonalData);
          //  Navigator.of(context).pushReplacementNamed(Routes.addPersonalData);
        }*/
      } else if (next is LoginFailed) {
        toast(msg: next.error,isError: true);
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppText(text: "Splash View"),
              yHeight(20),
              ElevatedButton(
                  onPressed: () {
                    final loginState = ref.watch(loginProvider);
                    if(loginState is LoginApiLoading){
                      return;
                    }
                    loginData.login();
                  }, child: const AppText(text: "Log In")),
              yHeight(20),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final loginState = ref.watch(loginProvider);
                  return Visibility(
                    visible: loginState is LoginApiLoading,
                    child: const CircularProgressIndicator(
                      color: AppColor.primary,

                    ),
                  );
                },

              )
            ]),
      ),
    );
  }
}
