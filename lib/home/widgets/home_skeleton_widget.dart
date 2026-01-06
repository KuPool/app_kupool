import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeletonWidget extends StatelessWidget {
  const HomeSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      margin: EdgeInsets.only(top: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(width: 100, height: 20, color: Colors.white),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: List.generate(3, (index) => Expanded(child: Container(height: 14, color: Colors.white, margin: EdgeInsets.only(left: index == 0 ? 0 : 10)))),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  const CircleAvatar(radius: 16, backgroundColor: Colors.white),
                  SizedBox(width: 8.w),
                  Expanded(flex: 3, child: Container(height: 20, color: Colors.white)),
                  const Spacer(flex: 1),
                  Expanded(flex: 2, child: Container(height: 20, color: Colors.white)),
                  const Spacer(flex: 1),
                  Expanded(flex: 2, child: Container(height: 20, color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 16, color: Colors.white),
                  SizedBox(height: 16.h),
                  Container(width: double.infinity, height: 16, color: Colors.white),
                  SizedBox(height: 12.h),
                  Container(width: double.infinity, height: 16, color: Colors.white),
                  SizedBox(height: 16.h),
                  Container(width: 200, height: 14, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
