import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/modules/nanny/nanny_views/venmo/venmo_controller.dart';
import 'package:northshore_nanny_flutter/app/res/constants/assets.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_app_bar.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_button.dart';

import '../../../../res/theme/colors.dart';
import '../../../../res/theme/dimens.dart';
import '../../../../res/theme/styles.dart';
import '../../../../utils/phone_number_formate.dart';
import '../../../../utils/translations/translation_keys.dart';
import '../../../../widgets/custom_text_field.dart';

class VenmoAndGuardianDetailsView extends StatelessWidget {
  VenmoAndGuardianDetailsView({super.key});

  final bool isHaveVenmo = Get.arguments["isHaveVenmo"] ?? false;
  final bool isComeFromEdit = Get.arguments["isComeFromEdit"] ?? false;

  @override
  Widget build(BuildContext context) => GetBuilder<VenmoController>(
        initState: (_) {
          var controller = Get.find<VenmoController>();
          if (isComeFromEdit) {
            controller.getVenmoAndGuardianDetail();
          }
        },
        builder: (venmoController) => Scaffold(
          appBar: CustomAppbarWidget(
            title: isHaveVenmo && isComeFromEdit
                ? "Edit ${TranslationKeys.venmoDetails.tr}"
                : isHaveVenmo && !isComeFromEdit
                    ? TranslationKeys.venmoDetails.tr
                    : !isHaveVenmo && isComeFromEdit
                        ? "Edit ${TranslationKeys.guardianDetails.tr}"
                        : TranslationKeys.guardianDetails.tr,
            centerTitle: true,
          ),
          body: Padding(
            padding: Dimens.edgeInsets16,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller:
                            venmoController.userNameTextEditingController,
                        maxLines: 1,
                        minLines: 1,
                        maxLength: 18,
                        decoration: customFieldDeco(
                          hintText: isHaveVenmo
                              ? TranslationKeys.venmoUserName.tr
                              : TranslationKeys.guardianVenmoUserName.tr,
                          prefixWidget: Padding(
                            padding: Dimens.edgeInsets12,
                            child: SvgPicture.asset(
                              Assets.iconsSmallProfile,
                              height: Dimens.ten,
                              width: Dimens.ten,
                            ),
                          ),
                        ),
                        cursorColor: AppColors.blackColor,
                        cursorWidth: Dimens.one,
                        style: AppStyles.ubBlack15W600,
                        keyboardType: TextInputType.text,
                      ),
                      if (!isHaveVenmo) ...[
                        Dimens.boxHeight20,
                        TextField(
                          controller:
                              venmoController.guardianNameTextEditingController,
                          maxLines: 1,
                          minLines: 1,
                          maxLength: 18,
                          decoration: customFieldDeco(
                            hintText: TranslationKeys.guardianUserName.tr,
                            prefixWidget: Padding(
                              padding: Dimens.edgeInsets12,
                              child: SvgPicture.asset(
                                Assets.iconsSmallProfile,
                                height: Dimens.ten,
                                width: Dimens.ten,
                              ),
                            ),
                          ),
                          cursorColor: AppColors.blackColor,
                          cursorWidth: Dimens.one,
                          style: AppStyles.ubBlack15W600,
                          keyboardType: TextInputType.text,
                        ),
                        Dimens.boxHeight20,
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(14),
                            PhoneNumberFormatter(),
                          ],
                          controller:
                              venmoController.phoneNumberTextEditingController,
                          maxLines: 1,
                          minLines: 1,
                          maxLength: 18,
                          decoration: customFieldDeco(
                            hintText: TranslationKeys.phoneNumber.tr,
                            prefixWidget: Padding(
                              padding: Dimens.edgeInsets12,
                              child: SvgPicture.asset(
                                Assets.iconsPhone,
                                height: Dimens.ten,
                                width: Dimens.ten,
                              ),
                            ),
                          ),
                          cursorColor: AppColors.blackColor,
                          cursorWidth: Dimens.one,
                          style: AppStyles.ubBlack15W600,
                          keyboardType: TextInputType.phone,
                        ),
                      ]
                    ],
                  ),
                ),
                CustomButton(
                  title: TranslationKeys.submit.tr,
                  backGroundColor: AppColors.navyBlue,
                  onTap: () {
                    venmoController.venmoValidator(
                        isVenmo: isHaveVenmo, isFromEdit: isComeFromEdit);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
