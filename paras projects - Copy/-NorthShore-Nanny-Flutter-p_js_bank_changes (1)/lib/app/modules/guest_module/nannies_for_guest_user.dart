import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:northshore_nanny_flutter/app/res/constants/assets.dart';
import 'package:northshore_nanny_flutter/app/res/theme/colors.dart';
import 'package:northshore_nanny_flutter/app/res/theme/dimens.dart';
import 'package:northshore_nanny_flutter/app/res/theme/styles.dart';
import 'package:northshore_nanny_flutter/app/utils/translations/translation_keys.dart';
import 'package:northshore_nanny_flutter/app/widgets/custom_text_field.dart';
import 'package:northshore_nanny_flutter/navigators/app_routes.dart';
import 'package:northshore_nanny_flutter/navigators/routes_management.dart';

import '../../widgets/app_text.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/guest_sign_in_alert_dialog.dart';
import '../customer/home/widgets/custom_home_list.dart';
import 'guest_user_controller.dart';

class NanniesForGuestUser extends StatelessWidget {
  const NanniesForGuestUser({super.key});

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: GetBuilder<GuestUserController>(
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: Dimens.edgeInsets16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: AppText(
                      text: "Nanny List",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.pdBlack22W600,
                    ),
                  ),
                  Dimens.boxHeight20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //** SEARCH */
                      Expanded(
                        child: SizedBox(
                          height: Dimens.forty,
                          child: TextField(
                            controller: controller.searchTextEditingController,
                            onChanged: controller.searchNanny,
                            maxLines: 1,
                            minLines: 1,
                            decoration: customFieldDeco(
                              hintText: '${TranslationKeys.search.tr} ',
                              fillColor: AppColors.searchColor,
                              prefixWidget: Padding(
                                padding: Dimens.edgeInsets12,
                                child: SvgPicture.asset(
                                  Assets.iconsSearch,
                                  height: Dimens.ten,
                                  width: Dimens.ten,
                                ),
                              ),
                              suffix: (controller
                                      .searchTextEditingController.text.isEmpty)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        controller.searchTextEditingController
                                            .clear();
                                        controller.searchNanny('');
                                      },
                                      child: Padding(
                                        padding: Dimens.edgeInsets10,
                                        child: SvgPicture.asset(
                                          Assets.iconsRemove,
                                        ),
                                      ),
                                    ),
                              hintStyle: AppStyles.ubHintColor12W500,
                            ),
                            cursorColor: AppColors.blackColor,
                            cursorWidth: Dimens.one,
                            style: AppStyles.ubBlack14W600,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      Dimens.boxWidth12,

                      CustomButton(
                        width: 50,
                        height: 42,
                        title: TranslationKeys.signIn.tr,
                        textPadding: 2,
                        textSize: 12,
                        backGroundColor: AppColors.navyBlue,
                        onTap: () async {
                          RouteManagement.goChooseBabySitter();
                        },
                      ),
                    ],
                  ),
                  Dimens.boxHeight16,
                  (controller.homeNannyList.isEmpty ||
                              (controller.searchTextEditingController.text
                                      .isNotEmpty &&
                                  controller.searchedNannyList.isEmpty)) &&
                          !controller.isNannyDataLoading.value
                      ? Expanded(
                          child: Center(
                            child: AppText(
                              text: TranslationKeys.noResultFound.tr,
                              style: AppStyles.pdNavyBlue20W600,
                            ),
                          ),
                        )
                      :

                      //** SEARCH LIST */
                      Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller
                                    .searchTextEditingController.text.isNotEmpty
                                ? controller.searchedNannyList.length
                                : controller.homeNannyList.length,
                            itemBuilder: (context, index) {
                              final item = controller
                                      .searchTextEditingController
                                      .text
                                      .isNotEmpty
                                  ? controller.searchedNannyList[index]
                                  : controller.homeNannyList.reversed.toList()[index];
                              return GestureDetector(
                                onTap: () {
                                  log("selected Nanny id:-->>${item.id}");
                                  RouteManagement.goToGetNannyProfileView(
                                      argument: {
                                        "id": item.id,
                                        "from": Routes.nanniesForGuestUser
                                      });
                                },
                                child: HomeCustomListView(
                                  isGuest: true,
                                  distance:
                                      ((item.distance)?.toInt()).toString(),
                                  age: item.age.toString(),
                                  experience: (item.experience.toString())
                                      .split(' ')
                                      .first,
                                  description: item.aboutMe,
                                  image: item.image,
                                  name: item.name,
                                  rating: item.rating == 0.0
                                      ? '0'
                                      : item.rating?.toStringAsFixed(1) ?? '0',
                                  reviews: '${item.reviewCount}',
                                  isHeartTapped: item.isFavorite!,
                                  heartSvg: Assets.iconsHeartOutline,
                                  onTapHeartIcon: () {
                                    // controller.toggleFavouriteAndUnFavouriteApi(
                                    //     isFavourite: !controller
                                    //         .homeNannyList[index].isFavorite!,
                                    //     userId:
                                    //     item.id!);
                                  },
                                  onTapRating: () async {
                                    await Get.dialog(
                                      const GuestSignInAlertDialog(),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                ],
              ),
            ),
          );
        },
      ));
}
