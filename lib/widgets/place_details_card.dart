import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place_model.dart';
import '../utils/constant.dart';

class PlaceDetailsCard extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetailsCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.lightBlue,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                place.status == 'Empty'
                    ? Icons.lock_open
                    : place.status == 'Booked'
                    ? Icons.event_available
                    : Icons.lock,
                color: AppColors.white,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Place ${place.id}',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${place.status}',
                style: GoogleFonts.poppins(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
              if (place.plateNumber != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Plate: ${place.plateNumber}',
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
