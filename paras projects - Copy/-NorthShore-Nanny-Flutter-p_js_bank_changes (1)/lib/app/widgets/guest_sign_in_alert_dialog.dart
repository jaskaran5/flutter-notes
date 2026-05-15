import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../navigators/routes_management.dart';
import '../res/theme/colors.dart';
import '../res/theme/dimens.dart';
import '../res/theme/styles.dart';
import '../utils/translations/translation_keys.dart';
import 'app_text.dart';
import 'custom_button.dart';

class GuestSignInAlertDialog extends StatelessWidget {
  const GuestSignInAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(Dimens.twenty),
        color: AppColors.primaryColor,
        child: Container(
          padding: Dimens.edgeInsets10,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(Dimens.twenty),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                text: 'Sign in Alert',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.ubBlack24W700,
              ),
              Dimens.boxHeight16,
              SizedBox(
                width: 303,
                child: AppText(
                  text:
                      "To access this feature, please sign in or create an account.",
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.ubBlack16W600,
                ),
              ),
              Dimens.boxHeight16,
              CustomButton(
                title: 'Sign In',
                width: 291,
                height: 50,
                customPadding: Dimens.edgeInsets10,
                titleStyle: AppStyles.ubWhite14700,
                backGroundColor: AppColors.navyBlue,
                borderRadius: Dimens.eight,
                onTap: () async {
                  RouteManagement.goChooseBabySitter();
                },
              ),
              Dimens.boxHeight16,
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: AppText(
                  text: TranslationKeys.cancel.tr,
                  style: AppStyles.ubGrey15W500,
                ),
              ),
              Dimens.boxHeight10,
            ],
          ),
        ),
      ),
    );
  }
}
