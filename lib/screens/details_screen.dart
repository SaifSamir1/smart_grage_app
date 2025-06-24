import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../utils/constant.dart';
import '../widgets/details_app_bar.dart';
import '../widgets/place_details_card.dart';
import '../widgets/reverse_button.dart';



class DetailsScreen extends StatelessWidget {
  final PlaceModel place;

  const DetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(placeId: place.id),
      body: SafeArea(
        child: Container(
          color: AppColors.background,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlaceDetailsCard(place: place),
                  const SizedBox(height: 32),
                  ReserveButton(place: place),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
