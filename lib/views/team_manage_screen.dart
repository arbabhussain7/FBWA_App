import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/viewModel/team_controller.dart';
import 'package:football_app/views/create_team_screen.dart';
import 'package:football_app/views/widgets/custom_button.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:get/get.dart';

class TeamManageScreen extends StatelessWidget {
  const TeamManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.put(TeamController());

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
                CustomHeader(text: 'Team Manage'),
                SizedBox(height: 22.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(color: AppColors.greyColor),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => CreateTeamScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create a new team',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor.withOpacity(0.7),
                                  fontFamily: 'SegoeUI',
                                ),
                              ),
                              SvgPicture.asset(ImageAssets.addIcon),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'My Teams History',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.whiteColor.withOpacity(0.7),
                          fontFamily: 'SegoeUI',
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Teams List
                      Obx(() {
                        if (teamController.isLoading.value) {
                          return SizedBox(
                            height: 410.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                              ),
                            ),
                          );
                        }

                        if (teamController.allTeams.isEmpty) {
                          return SizedBox(
                            height: 410.h,
                            child: Center(
                              child: Text(
                                'No teams found.\nCreate your first team!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.whiteColor.withOpacity(0.7),
                                  fontFamily: 'SegoeUI',
                                ),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 410.h,
                          child: ListView.separated(
                            itemCount: teamController.allTeams.length,
                            itemBuilder: (context, index) {
                              final team = teamController.allTeams[index];
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor,
                                ),
                                child: Row(
                                  children: [
                                    // Team Image
                                    CircleAvatar(
                                      backgroundImage:
                                          (team.tImg != null &&
                                              team.tImg!.isNotEmpty)
                                          ? FileImage(File(team.tImg!))
                                          : AssetImage(ImageAssets.arsenalImg)
                                                as ImageProvider,
                                    ),
                                    SizedBox(width: 6.w),

                                    // Team Name
                                    Expanded(
                                      child: Text(
                                        team.tName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.whiteColor
                                              .withOpacity(0.7),
                                          fontFamily: 'SegoeUI',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Delete Button
                                    GestureDetector(
                                      onTap: () {
                                        // Show confirmation dialog
                                        Get.dialog(
                                          AlertDialog(
                                            backgroundColor:
                                                AppColors.greyColor,
                                            title: Text(
                                              'Delete Team',
                                              style: TextStyle(
                                                color: AppColors.whiteColor,
                                                fontFamily: 'SegoeUI',
                                              ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete "${team.tName}"?',
                                              style: TextStyle(
                                                color: AppColors.whiteColor
                                                    .withOpacity(0.7),
                                                fontFamily: 'SegoeUI',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontFamily: 'SegoeUI',
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back(); // Close dialog
                                                  teamController.deleteTeam(
                                                    team.sNo!,
                                                  );
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: AppColors.redColor,
                                                    fontFamily: 'SegoeUI',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          ImageAssets.deteleImg,
                                          color: AppColors.redColor,
                                          width: 15.w,
                                          height: 15.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12.h);
                            },
                          ),
                        );
                      }),

                      SizedBox(height: 12.h),
                      CustomButton(text: 'Manage'),
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
