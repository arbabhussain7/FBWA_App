import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/views/player_manage_screen.dart';
import 'package:football_app/views/team_manage_screen.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailTeamScreen extends StatelessWidget {
  const DetailTeamScreen({super.key});

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
              CustomHeader(text: 'Detail Team/Player'),
              SizedBox(height: 22.h),
              // Select Club
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => TeamManageScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 26.w,
                          vertical: 30.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aYellowColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' Team Details ',
                              style: GoogleFonts.podkova(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBlueColor.withOpacity(0.7),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 29,
                              color: AppColors.darkBlueColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => PlayerManageScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 26.w,
                          vertical: 30.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.aYellowColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' Players Details ',
                              style: GoogleFonts.podkova(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.darkBlueColor.withOpacity(0.7),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 29,
                              color: AppColors.darkBlueColor,
                            ),
                          ],
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
    );
  }
}
