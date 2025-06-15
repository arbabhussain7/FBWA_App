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
                      SizedBox(height: 239.h),
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
