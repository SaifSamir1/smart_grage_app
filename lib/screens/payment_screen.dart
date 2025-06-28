import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_garage/cubits/details_cubit/details_cubit.dart';
import 'package:smart_garage/cubits/details_cubit/details_state.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../models/place_model.dart';
import '../utils/constant.dart';
import 'home_screen.dart';

class PaymentScreen extends StatelessWidget {
  final PlaceModel place;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _plateNumberController = TextEditingController();

  PaymentScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    // Reset card details when the screen is built
    context.read<DetailsCubit>().resetCardDetails();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment for Place ${place.id}',
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
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.background,
          child: BlocConsumer<DetailsCubit, DetailsState>(
            listener: (context, state) {
              // لو عايز تضيف أي listener actions لما الـ state يتغير
            },
            builder: (context, state) {
              final cubit = context.read<DetailsCubit>();

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // جزء بطاقة الدفع
                  FadeInDown(
                    child: CreditCardWidget(
                      cardNumber: state.cardNumber,
                      expiryDate: state.expiryDate,
                      cardHolderName: state.cardHolderName,
                      cvvCode: state.cvvCode,
                      showBackView: state.isCvvFocused,
                      cardBgColor: AppColors.primaryBlue,
                      enableFloatingCard: true,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      height: 200,
                      textStyle: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      onCreditCardWidgetChange: (brand) {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeIn(
                    child: CreditCardForm(
                      formKey: formKey,
                      cardNumber: state.cardNumber,
                      expiryDate: state.expiryDate,
                      cardHolderName: state.cardHolderName,
                      cvvCode: state.cvvCode,
                      onCreditCardModelChange: (model) {
                        cubit.updateCardDetails(
                          cardNumber: model.cardNumber,
                          expiryDate: model.expiryDate,
                          cardHolderName: model.cardHolderName,
                          cvvCode: model.cvvCode,
                          isCvvFocused: model.isCvvFocused,
                        );
                      },
                      obscureCvv: true,
                      obscureNumber: false,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      inputConfiguration: InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Card Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue.withOpacity(0.6),
                          ),
                        ),
                        expiryDateDecoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue.withOpacity(0.6),
                          ),
                        ),
                        cvvCodeDecoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue.withOpacity(0.6),
                          ),
                        ),
                        cardHolderDecoration: InputDecoration(
                          labelText: 'Card Holder',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue,
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.primaryBlue.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // حقل إدخال رقم لوحة العربية
                  FadeIn(
                    child: TextFormField(
                      controller: _plateNumberController,
                      decoration: InputDecoration(
                        labelText: 'Car Plate Number',
                        hintText: 'e.g., ABC123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelStyle: GoogleFonts.poppins(
                          color: AppColors.primaryBlue,
                        ),
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.primaryBlue.withOpacity(0.6),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car plate number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // زر الدفع
                  BlocBuilder<DetailsCubit, DetailsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        );
                      }
                      return BounceInUp(
                        duration: const Duration(milliseconds: 800),
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              if (_plateNumberController.text.isNotEmpty) {
                                cubit.startLoading();
                                // عملية الحجز
                                context.read<HomeCubit>().bookPlace(
                                  place.id,
                                  _plateNumberController.text,
                                );
                                // إيقاف الـ loading
                                cubit.stopLoading();
                                // إعادة تعيين بيانات البطاقة
                                cubit.resetCardDetails();
                                // تنظيف حقل لوحة العربية
                                _plateNumberController.clear();
                                // الرجوع للشاشة الرئيسية
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                                // إظهار رسالة تأكيد في الـ HomeScreen
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Place ${place.id} Reserved!',
                                      ),
                                      backgroundColor: AppColors.primaryBlue,
                                    ),
                                  );
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a plate number',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Pay Now',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
