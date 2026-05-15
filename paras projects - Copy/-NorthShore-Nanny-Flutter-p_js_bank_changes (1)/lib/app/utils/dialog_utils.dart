import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/res/theme/colors.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/utils/translations/translation_keys.dart';
import 'package:northshore_nanny_flutter/app/widgets/app_text.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_button.dart';

import '../res/constants/assets.dart';
import '../res/theme/styles.dart';

class DialogUtils {
  DialogUtils._();

  /// used to show this dialog why we get your location.
  static openLocationDialog({
    VoidCallback? onAccept,
    required String title,
  }) async {
    await Get.dialog(
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(Dimens.twenty),
          color: AppColors.primaryColor,
          child: Container(
            width: 335,
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
                  text: 'Use Your Location',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.ubBlack24W700,
                ),
                Dimens.boxHeight16,
                SizedBox(
                  width: 303,
                  child: AppText(
                    text: title.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.ubBlack16W600,
                  ),
                ),
                Dimens.boxHeight16,
                SvgPicture.asset(
                  Assets.iconsMapLocation,
                  alignment: Alignment.center,
                ),
                Dimens.boxHeight16,
                CustomButton(
                  title: 'Enable Location',
                  width: 291,
                  height: 50,
                  customPadding: Dimens.edgeInsets10,
                  titleStyle: AppStyles.ubWhite14700,
                  backGroundColor: AppColors.navyBlue,
                  borderRadius: Dimens.eight,
                  onTap: onAccept,
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
      ),
    );
  }
}
