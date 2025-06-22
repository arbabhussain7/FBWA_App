import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/model/player_model.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePlayerDetailScreen extends StatelessWidget {
  final Player player;

  const SinglePlayerDetailScreen({super.key, required this.player});

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
              CustomHeader(text: 'Player Details'),
              SizedBox(height: 12.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Player Image
                      CircleAvatar(
                        maxRadius: 72.r,
                        backgroundColor: AppColors.whiteColor.withOpacity(0.2),
                        backgroundImage: _getPlayerImage(),
                        child: _getPlayerImage() == null
                            ? Icon(
                                Icons.person,
                                size: 60.r,
                                color: AppColors.whiteColor.withOpacity(0.7),
                              )
                            : null,
                      ),
                      SizedBox(height: 12.h),

                      // Player Name
                      Text(
                        player.pName ?? 'Unknown Player',
                        style: GoogleFonts.manuale(
                          fontSize: 29.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),

                      // Team Name
                      Text(
                        player.teamName ?? 'No Team',
                        style: GoogleFonts.manuale(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // Jersey Number
                      Text(
                        '${player.jNumber.toString() ?? 'N/A'}',
                        style: GoogleFonts.manuale(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor.withOpacity(0.9),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Position Container
                      Container(
                        width: 299.w,
                        constraints: BoxConstraints(minHeight: 172.h),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.h),
                              Text(
                                player.pPosition ?? 'Not Specified',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navyBlueColor,
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getPlayerImage() {
    if (player.pImg != null && player.pImg!.isNotEmpty) {
      final file = File(player.pImg!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return null;
  }
}
