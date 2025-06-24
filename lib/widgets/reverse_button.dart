



import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place_model.dart';
import '../screens/payment_screen.dart';
import '../utils/constant.dart';

class ReserveButton extends StatelessWidget {
  final PlaceModel place;

  const ReserveButton({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    if (place.status != 'Empty') return const SizedBox.shrink();

    return BounceInDown(
      duration: const Duration(milliseconds: 800),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(place: place),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_add, size: 24),
            const SizedBox(width: 8),
            Text(
              'Reserve Now',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
