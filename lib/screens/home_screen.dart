

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_state.dart';
import '../models/place_model.dart';
import '../utils/constant.dart';
import 'details_screen.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.directions_car, color: AppColors.white),
          const SizedBox(width: 8),
          Text(
            'Smart Garage',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// PlaceCard Widget
class PlaceCardWidget extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback onTap;

  const PlaceCardWidget({super.key, required this.place, required this.onTap});

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

    return FadeInUp(
      duration: Duration(milliseconds: 500 + (place.id * 100)),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: AppColors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Place ${place.id}',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        place.status,
                        style: GoogleFonts.poppins(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      if (place.plateNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Plate: ${place.plateNumber}',
                          style: GoogleFonts.poppins(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (place.status == 'Empty')
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.greenAccent,
                      size: 24,
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

// PlacesGrid Widget
class PlacesGridWidget extends StatelessWidget {
  final List<PlaceModel> places;

  const PlacesGridWidget({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return PlaceCardWidget(
          place: place,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(place: place),
              ),
            );
          },
        );
      },
    );
  }
}

// HomeScreen Widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        appBar: const AppBarWidget(),
        body: SafeArea(
          child: Container(
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return PlacesGridWidget(places: state.places);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}