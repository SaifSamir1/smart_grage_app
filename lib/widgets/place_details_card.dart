


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
    IconData icon;
    Color cardColor;
    switch (place.status) {
      case 'Empty':
        icon = Icons.lock_open;
        cardColor = AppColors.lightBlue;
        break;
      case 'Busy':
        icon = Icons.lock;
        cardColor = AppColors.darkBlue;
        break;
      case 'Booked':
        icon = Icons.event_available;
        cardColor = AppColors.bookedBlue;
        break;
      default:
        icon = Icons.lock_open;
        cardColor = AppColors.lightBlue;
    }

    return ZoomIn(
      duration: const Duration(milliseconds: 600),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppColors.white,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Place ${place.id}',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${place.status}',
                style: GoogleFonts.poppins(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 20,
                ),
              ),
              if (place.plateNumber != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Plate: ${place.plateNumber}',
                  style: GoogleFonts.poppins(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 18,
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
