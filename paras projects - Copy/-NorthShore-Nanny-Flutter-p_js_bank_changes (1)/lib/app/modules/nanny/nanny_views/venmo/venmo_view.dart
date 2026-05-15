import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/venmo/venmo_controller.dart';
import 'package:northshore_nanny_flutter/app/res/constants/assets.dart';
import 'package:northshore_nanny_flutter/app/res/theme/colors.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/res/theme/styles.dart';
import 'package:northshore_nanny_flutter/app/utils/translations/translation_keys.dart';
import 'package:northshore_nanny_flutter/app/widgets/app_text.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_app_bar.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_button.dart';

import '../../../../../navigators/routes_management.dart';

class VenmoView extends StatelessWidget {
  const VenmoView({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<VenmoController>(
        builder: (venmoController) => Scaffold(
          appBar: const CustomAppbarWidget(),
          body: Padding(
            padding: Dimens.edgeInsets16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height / 7,
                ),
                SvgPicture.asset(
                  Assets.iconsVenmo,
                  height: Dimens.hundred,
                  width: Dimens.hundred,
                ),
                Dimens.boxHeight20,
                AppText(
                  text: TranslationKeys.doYouHaveVenmo.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.ubBlack24W700,
                  maxLines: 1,
                ),
                Dimens.boxHeight16,
                SizedBox(
                  width: Get.width / 1.2,
                  child: AppText(
                    text: TranslationKeys.pleaseSelectBelowAction.tr,
                    textAlign: TextAlign.center,
                    style: AppStyles.ubGrey16W500,
                    maxLines: 2,
                  ),
                ),
                Dimens.boxHeight32,
                CustomButton(
                  title: TranslationKeys.yes.tr,
                  onTap: () {
                    RouteManagement.goToVenmoDetailView(isHaveVenmo: true);
                  },
                  backGroundColor: AppColors.navyBlue,
                ),
                Dimens.boxHeight16,
                CustomButton(
                  title: TranslationKeys.no.tr,
                  backGroundColor: AppColors.lightNavyBlue,
                  onTap: () {
                    RouteManagement.goToVenmoDetailView(isHaveVenmo: false);
                  },
                  titleStyle: AppStyles.ubNavyBlue15W600,
                ),
              ],
            ),
          ),
        ),
      );
}
