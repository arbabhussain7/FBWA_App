import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/viewModel/player_controller.dart';
import 'package:football_app/viewModel/team_controller.dart';
import 'package:football_app/views/player_manage_screen.dart';
import 'package:football_app/views/team_manage_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PlayerController controller = Get.put(PlayerController());
  final TeamController teamController = Get.put(TeamController());
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
          body: Column(
            children: [
              SizedBox(height: 55.h),
              Center(
                child: Text(
                  'Welcom to Team Roast',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: "SegeoUI",
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'We will help you to achieve your target.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "Segoe UI Regular",
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: 33.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 164.w,
                    height: 81.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        bottomLeft: Radius.circular(14.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xff4382F5), Color(0xff713CF6)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            teamController.formattedTotalCount,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                              fontFamily: 'SegeoUI',
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Teams',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                            fontFamily: 'SegeoUI',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 164.w,
                    height: 81.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(14.r),
                        bottomRight: Radius.circular(14.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffF16E5F), Color(0xffF8BC6A)],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalPlayersCount.value
                                .toString()
                                .padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.whiteColor,
                              fontFamily: 'SegeoUI',
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Players',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.whiteColor,
                            fontFamily: 'SegeoUI',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  Get.to(TeamManageScreen());
                },
                child: Container(
                  width: 321.w,
                  height: 138.h,
                  padding: EdgeInsets.only(bottom: 33.h, left: 12.w),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.mTeamImg),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Manage \nTeams',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.whiteColor,
                        fontFamily: 'SegeoUI',
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => PlayerManageScreen());
                },
                child: Container(
                  width: 321.w,
                  height: 118.h,
                  padding: EdgeInsets.only(bottom: 22.h, left: 12.w),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.mPlayerImg),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Manage \nPlayers',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppColors.whiteColor,
                        fontFamily: 'SegeoUI',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
