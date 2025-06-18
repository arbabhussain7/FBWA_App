import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/viewModel/team_controller.dart';
import 'package:football_app/views/home_screen.dart';
import 'package:football_app/views/widgets/custom_button.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateTeamScreen extends StatelessWidget {
  CreateTeamScreen({super.key});

  final TeamController teamController = Get.put(TeamController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController leagueController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        teamController.setTeamImage(image.path);
        Get.snackbar('Success', 'Image selected successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _createTeam() async {
    teamController.setTeamName(nameController.text.trim());
    teamController.setUserEnteredLeague(
      leagueController.text.trim(),
    ); // Set user-entered league
    bool success = await teamController.saveTeam();
    if (success) {
      Get.offAll(() => HomeScreen());
    }
  }

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
                CustomHeader(text: 'Create New Team'),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Obx(
                          () => Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CircleAvatar(
                                  maxRadius: 66,
                                  backgroundImage:
                                      teamController.teamImage.value.isNotEmpty
                                      ? FileImage(
                                          File(teamController.teamImage.value),
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
                      SizedBox(height: 12.h),

                      // Team Name TextField
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'SegoeUI',
                            color: AppColors.whiteColor.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12.w),
                            hintText: 'Enter Team Name',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SegoeUI',
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // League TextField (User Input)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: TextFormField(
                          controller: leagueController,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'SegoeUI',
                            color: AppColors.whiteColor.withOpacity(0.7),
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 12.w),
                            hintText: 'Enter League Name',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'SegoeUI',
                              color: AppColors.whiteColor.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Select Club
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(() => SelectClub());
                      //   },
                      //   child: Obx(
                      //     () => Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 12.w,
                      //         vertical: 10.h,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.greyColor,
                      //       ),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             teamController.clubDisplayText,
                      //             style: TextStyle(
                      //               fontSize: 14.sp,
                      //               fontFamily: 'SegoeUI',
                      //               color: AppColors.whiteColor.withOpacity(
                      //                 0.7,
                      //               ),
                      //             ),
                      //           ),
                      //           SvgPicture.asset(ImageAssets.forwardIcon),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 300.h),

                      GestureDetector(
                        onTap: _createTeam,
                        child: CustomButton(text: 'Create Team'),
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
