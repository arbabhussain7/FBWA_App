import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/viewModel/player_controller.dart';
import 'package:football_app/views/single_plyayer_detail_screen.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:get/get.dart';

class PlayerManageScreen extends StatelessWidget {
  PlayerManageScreen({super.key});
  final PlayerController controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPlayers();
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
                CustomHeader(text: 'Player Details'),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Container(
                            height: 400.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColors.yellowColor,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Loading players...',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.whiteColor.withOpacity(
                                        0.7,
                                      ),
                                      fontFamily: 'SegoeUI',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (controller.players.isEmpty) {
                          return Container(
                            height: 400.h,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sports_soccer,
                                    size: 64.r,
                                    color: AppColors.whiteColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No players found',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.whiteColor.withOpacity(
                                        0.7,
                                      ),
                                      fontFamily: 'SegoeUI',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Create Your Player First ',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.whiteColor.withOpacity(
                                        0.5,
                                      ),
                                      fontFamily: 'SegoeUI',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 400.h,
                          child: ListView.separated(
                            itemCount: controller.players.length,
                            itemBuilder: (context, index) {
                              final player = controller.players[index];

                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => SinglePlayerDetailScreen(
                                      player: player,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.yellowColor
                                                .withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 26.r,
                                          backgroundImage: _getPlayerImage(
                                            player.pImg,
                                          ),
                                          onBackgroundImageError:
                                              (exception, stackTrace) {
                                                print(
                                                  'Error loading image: $exception',
                                                );
                                              },
                                        ),
                                      ),
                                      SizedBox(width: 12.w),

                                      // Player info
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Team name (top, bold)
                                            if (player.teamName != null)
                                              Text(
                                                player.teamName!,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: AppColors.yellowColor,
                                                  fontFamily: 'SegoeUI',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            if (player.teamName != null)
                                              SizedBox(height: 2.h),

                                            // Player name
                                            Text(
                                              player.pName,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.whiteColor
                                                    .withOpacity(0.9),
                                                fontFamily: 'SegoeUI',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 2.h),

                                            // Position
                                            Text(
                                              player.pPosition,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.aGreyColor,
                                                fontFamily: 'SegoeUI',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.yellowColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                  4.r,
                                                ),
                                                topLeft: Radius.circular(4.r),
                                              ),
                                            ),
                                            child: Text(
                                              'ID',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.whiteColor,
                                                fontFamily: 'SegoeUI',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(
                                                  4.r,
                                                ),
                                                topRight: Radius.circular(4.r),
                                              ),
                                            ),
                                            child: Text(
                                              player.jNumber.toString(),
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.blackColor,
                                                fontFamily: 'SegoeUI',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 12.w),

                                      // Delete button
                                      GestureDetector(
                                        onTap: () =>
                                            _showDeleteConfirmation(player),
                                        child: Container(
                                          padding: EdgeInsets.all(6.r),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            ImageAssets.deteleImg,
                                            color: AppColors.redColor,
                                            width: 16.w,
                                            height: 16.h,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 12.h);
                            },
                          ),
                        );
                      }),
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

  ImageProvider _getPlayerImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return FileImage(imageFile);
      }
    }
    return AssetImage(ImageAssets.playerImg);
  }

  void _showDeleteConfirmation(player) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Delete Player',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontFamily: 'SegoeUI',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.yellowColor,
              size: 48.r,
            ),
            SizedBox(height: 16.h),
            Text(
              'Are you sure you want to delete ${player.pName}?',
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.8),
                fontFamily: 'SegoeUI',
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: AppColors.redColor.withOpacity(0.8),
                fontFamily: 'SegoeUI',
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deletePlayer(player.sNo!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
