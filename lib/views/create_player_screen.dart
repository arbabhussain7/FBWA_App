import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/viewModel/player_controller.dart';
import 'package:football_app/views/widgets/custom_button.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:get/get.dart';

class CreatePlayerScreen extends StatelessWidget {
  CreatePlayerScreen({super.key});
  final PlayerController controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshTeams();
    });

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.bgImg),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomHeader(text: 'Create New Player'),
                SizedBox(height: 22.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: controller.pickImageFromGallery,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CircleAvatar(
                                  maxRadius: 66,
                                  backgroundImage:
                                      controller
                                          .selectedImagePath
                                          .value
                                          .isNotEmpty
                                      ? FileImage(
                                          File(
                                            controller.selectedImagePath.value,
                                          ),
                                        )
                                      : AssetImage(ImageAssets.userImg)
                                            as ImageProvider,
                                ),
                              ),
                              Positioned(
                                left: 91.w,
                                top: 77.h,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    ImageAssets.cameraIcon,
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 17.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: TextFormField(
                          controller: controller.playerNameController,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'SegoeUI',
                            color: AppColors.whiteColor.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12.w),
                            hintText: 'Enter Player Name',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SegoeUI',
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: TextFormField(
                          controller: controller.jerseyNumberController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'SegoeUI',
                            color: AppColors.whiteColor.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12.w),
                            hintText: '- Jersey Number -',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SegoeUI',
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: TextFormField(
                          controller: controller.positionController,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'SegoeUI',
                            color: AppColors.whiteColor.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12.w),
                            hintText: '- Position -',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SegoeUI',
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      // Team Selection Dropdown with Refresh Button
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Obx(
                          () => controller.isLoadingTeams.value
                              ? Container(
                                  height: 48.h,
                                  child: Center(
                                    child: SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.whiteColor.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        value:
                                            controller.selectedTeam.value?.sNo,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                            left: 12.w,
                                            right: 8.w,
                                          ),
                                          hintText: controller.teamDisplayText,
                                          hintStyle: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: 'SegoeUI',
                                            color: AppColors.whiteColor
                                                .withOpacity(0.7),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        dropdownColor: AppColors.greyColor,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'SegoeUI',
                                          color: AppColors.whiteColor
                                              .withOpacity(0.7),
                                        ),
                                        icon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: AppColors.whiteColor
                                              .withOpacity(0.7),
                                        ),
                                        items: [
                                          DropdownMenuItem<int>(
                                            value: null,
                                            child: Text(
                                              '- Select Team -',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'SegoeUI',
                                                color: AppColors.whiteColor
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                          ...controller.allTeams.map((team) {
                                            return DropdownMenuItem<int>(
                                              value: team.sNo,
                                              child: Text(
                                                team.tName,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: 'SegoeUI',
                                                  color: AppColors.whiteColor
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                        onChanged: (int? value) {
                                          if (value == null) {
                                            controller.setSelectedTeam(null);
                                          } else {
                                            final selectedTeam = controller
                                                .allTeams
                                                .firstWhere(
                                                  (team) => team.sNo == value,
                                                );
                                            controller.setSelectedTeam(
                                              selectedTeam,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // ADD REFRESH BUTTON
                                    IconButton(
                                      onPressed: () {
                                        controller.refreshTeams();
                                        Get.snackbar(
                                          'Info',
                                          'Teams refreshed!',
                                          duration: Duration(seconds: 1),
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: AppColors.whiteColor.withOpacity(
                                          0.7,
                                        ),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 185.h,
                      ), // Reduced height to accommodate dropdown
                      Obx(
                        () => GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.createPlayer,
                          child: CustomButton(
                            text: controller.isLoading.value
                                ? 'Creating...'
                                : 'Create Player',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
