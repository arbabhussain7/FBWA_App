import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:football_app/constant/assets.dart';
import 'package:football_app/constant/colors.dart';
import 'package:football_app/model/team_model.dart';
import 'package:football_app/model/player_model.dart';
import 'package:football_app/data/localDB/db_helper.dart';
import 'package:football_app/views/widgets/custom_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SingleTeamDatailScreen extends StatefulWidget {
  final Team team;

  const SingleTeamDatailScreen({super.key, required this.team});

  @override
  State<SingleTeamDatailScreen> createState() => _SingleTeamDatailScreenState();
}

class _SingleTeamDatailScreenState extends State<SingleTeamDatailScreen> {
  List<Player> teamPlayers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTeamPlayers();
  }

  Future<void> loadTeamPlayers() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get all players from database
      List<Player> allPlayers = await DatabaseHelper.getAllPlayers();

      // Filter players that belong to this team
      teamPlayers = allPlayers
          .where((player) => player.teamId == widget.team.sNo)
          .toList();
    } catch (e) {
      print('Error loading team players: $e');
      Get.snackbar('Error', 'Failed to load team players');
    } finally {
      setState(() {
        isLoading = false;
      });
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
                CustomHeader(text: 'Team Detail'),
                SizedBox(height: 22.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      // Team Image
                      CircleAvatar(
                        maxRadius: 72.r,
                        backgroundImage:
                            (widget.team.tImg != null &&
                                widget.team.tImg!.isNotEmpty)
                            ? FileImage(File(widget.team.tImg!))
                            : AssetImage(ImageAssets.engLeagueImg)
                                  as ImageProvider,
                      ),
                      SizedBox(height: 12.h),

                      // Team Name
                      Text(
                        widget.team.tName,
                        style: GoogleFonts.manuale(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.whiteColor.withOpacity(0.7),
                        ),
                      ),

                      // Team League (if available)
                      if (widget.team.tLeagues != null &&
                          widget.team.tLeagues!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            widget.team.tLeagues!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.whiteColor.withOpacity(0.5),
                              fontFamily: 'SegoeUI',
                            ),
                          ),
                        ),

                      SizedBox(height: 12.h),

                      // Players List
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Players (${teamPlayers.length})',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.whiteColor.withOpacity(0.8),
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      SizedBox(
                        height: 350.h,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                ),
                              )
                            : teamPlayers.isEmpty
                            ? Center(
                                child: Text(
                                  'No players found in this team.\nAdd players to this team!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.whiteColor.withOpacity(
                                      0.6,
                                    ),
                                    fontFamily: 'SegoeUI',
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: teamPlayers.length,
                                itemBuilder: (context, index) {
                                  final player = teamPlayers[index];
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.navyBlueColor
                                          .withOpacity(0.5),
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
                                            backgroundImage:
                                                (player.pImg != null &&
                                                    player.pImg!.isNotEmpty)
                                                ? FileImage(File(player.pImg!))
                                                : AssetImage(
                                                        ImageAssets.arsenalImg,
                                                      )
                                                      as ImageProvider,
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

                                        // Jersey Number
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
                                                  topRight: Radius.circular(
                                                    4.r,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                '${player.jNumber}',
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
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 4.h);
                                },
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
