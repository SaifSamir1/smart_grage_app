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
    return ElevatedButton(
      onPressed:
          place.status == Status.empty
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(place: place),
                  ),
                );
              }
              : null, // Disable button if not Empty
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'Reserve Now',
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
