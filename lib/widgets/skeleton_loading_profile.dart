
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoadingProfile extends StatelessWidget {
  const SkeletonLoadingProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 55, left: 20, right: 20),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildSkeletonRow(),
              const SizedBox(height: 20),
              _buildSkeletonRow(),
              const SizedBox(height: 20),
              _buildSkeletonRow(),
              const SizedBox(height: 20),
              _buildSkeletonRow(),
              const SizedBox(height: 20),
              _buildSkeletonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Container(
        margin:const  EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 5),
                Container(
                  width: 150,
                  height: 14,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}