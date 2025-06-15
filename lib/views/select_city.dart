// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:football_app/constant/assets.dart';
// import 'package:football_app/constant/colors.dart';
// import 'package:football_app/constant/list.dart';
// import 'package:football_app/viewModel/team_controller.dart';
// import 'package:football_app/views/widgets/custom_header.dart';
// import 'package:get/get.dart';

// class SelectCity extends StatelessWidget {
//   SelectCity({super.key});
//   final TeamController teamController = Get.find<TeamController>();

//   // final List<String> listOfCityText = [
//   //   "New York (USA)",
//   //   "London (United Kingdom)",
//   //   "Tokyo (Japan)",
//   //   "Paris (France)",
//   //   "Sydney (Australia)",
//   //   "Dubai (United Arab Emirates)",
//   //   "Toronto (Canada)",
//   // ];

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
//                 CustomHeader(text: 'Select City'),
//                 SizedBox(height: 8.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12.w),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: 500.h,
//                         child: ListView.separated(
//                           itemCount: listOfCityText.length,
//                           itemBuilder: (context, index) {
//                             return Obx(
//                               () => GestureDetector(
//                                 onTap: () {
//                                   teamController.setCity(
//                                     listOfCityText[index],
//                                     index,
//                                   );
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 10.w,
//                                     vertical: 15.h,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(6.r),
//                                     color:
//                                         teamController
//                                                 .selectedCityIndex
//                                                 .value ==
//                                             index
//                                         ? AppColors.aYellowColor.withOpacity(
//                                             0.2,
//                                           )
//                                         : AppColors.greyColor,
//                                     border:
//                                         teamController
//                                                 .selectedCityIndex
//                                                 .value ==
//                                             index
//                                         ? Border.all(
//                                             color: AppColors.aYellowColor,
//                                             width: 1.5,
//                                           )
//                                         : null,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Row(
//                                           children: [
//                                             CircleAvatar(
//                                               backgroundImage: AssetImage(
//                                                 listOfLocalLeague[index],
//                                               ),
//                                             ),
//                                             SizedBox(width: 7.w),
//                                             Text(
//                                               listOfCityText[index],
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 color:
//                                                     teamController
//                                                             .selectedCityIndex
//                                                             .value ==
//                                                         index
//                                                     ? AppColors.aYellowColor
//                                                     : AppColors.whiteColor
//                                                           .withOpacity(0.7),
//                                                 fontFamily: 'SegoeUI',
//                                                 fontWeight:
//                                                     teamController
//                                                             .selectedCityIndex
//                                                             .value ==
//                                                         index
//                                                     ? FontWeight.w600
//                                                     : FontWeight.normal,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (teamController
//                                               .selectedCityIndex
//                                               .value ==
//                                           index)
//                                         Container(
//                                           padding: EdgeInsets.all(4.w),
//                                           decoration: BoxDecoration(
//                                             color: AppColors.aYellowColor,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Icon(
//                                             Icons.check,
//                                             size: 16.sp,
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
//                             return SizedBox(height: 12.h);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Obx(
//                         () => GestureDetector(
//                           onTap: () {
//                             if (teamController.selectedCityIndex.value != -1) {
//                               Get.back();
//                               Get.snackbar(
//                                 'City Selected',
//                                 'You have selected ${teamController.selectedCity.value}',
//                                 snackPosition: SnackPosition.BOTTOM,
//                                 backgroundColor: AppColors.aYellowColor
//                                     .withOpacity(0.8),
//                                 colorText: AppColors.whiteColor,
//                                 duration: Duration(seconds: 2),
//                               );
//                             } else {
//                               Get.snackbar(
//                                 'No Selection',
//                                 'Please select a city first',
//                                 snackPosition: SnackPosition.BOTTOM,
//                                 backgroundColor: Colors.red.withOpacity(0.8),
//                                 colorText: AppColors.whiteColor,
//                                 duration: Duration(seconds: 2),
//                               );
//                             }
//                           },
//                           child: Container(
//                             width: double.infinity,
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                             decoration: BoxDecoration(
//                               color:
//                                   teamController.selectedCityIndex.value != -1
//                                   ? AppColors.aYellowColor
//                                   : AppColors.greyColor.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(8.r),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Continue',
//                                 style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color:
//                                       teamController.selectedCityIndex.value !=
//                                           -1
//                                       ? AppColors.whiteColor
//                                       : AppColors.whiteColor.withOpacity(0.5),
//                                   fontFamily: 'SegoeUI',
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
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
