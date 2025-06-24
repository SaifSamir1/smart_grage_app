


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constant.dart';

class DetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int placeId;

  const DetailsAppBar({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Place $placeId Details',
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
