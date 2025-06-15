// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:football_app/constant/assets.dart';
// import 'package:football_app/constant/colors.dart';
// import 'package:football_app/constant/list.dart';
// import 'package:football_app/viewModel/team_controller.dart';
// import 'package:football_app/views/widgets/custom_button.dart';
// import 'package:football_app/views/widgets/custom_header.dart';
// import 'package:get/get.dart';

// class SelectLeague extends StatelessWidget {
//   SelectLeague({super.key});

//   final TeamController teamController = Get.find<TeamController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(ImageAssets.bgImg),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CustomHeader(text: 'Select League'),
//                 SizedBox(height: 8.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 500.h,
//                         child: ListView.separated(
//                           itemCount: listOfLeagueText.length,
//                           itemBuilder: (context, index) {
//                             return Obx(
//                               () => GestureDetector(
//                                 onTap: () => teamController.setLeague(
//                                   listOfLeagueText[index],
//                                   index,
//                                 ),
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w,
//                                     vertical: 10.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6.r),
//                                     color: AppColors.greyColor,
//                                     border:
//                                         teamController
//                                                 .selectedLeagueIndex
//                                                 .value ==
//                                             index
//                                         ? Border.all(
//                                             color: AppColors.aYellowColor,
//                                             width: 2,
//                                           )
//                                         : null,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           CircleAvatar(
//                                             backgroundImage: AssetImage(
//                                               listOfLeague[index],
//                                             ),
//                                           ),
//                                           SizedBox(width: 6.w),
//                                           Text(
//                                             listOfLeagueText[index],
//                                             style: TextStyle(
//                                               fontSize: 16.sp,
//                                               color: AppColors.whiteColor
//                                                   .withOpacity(0.7),
//                                               fontFamily: 'SegoeUI',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       if (teamController
//                                               .selectedLeagueIndex
//                                               .value ==
//                                           index)
//                                         Container(
//                                           padding: EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color: AppColors.aYellowColor,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             size: 14,
//                                             Icons.check,
//                                             color: AppColors.whiteColor,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(height: 10.h);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       GestureDetector(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: CustomButton(text: 'Continue'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
