



import 'package:flutter_bloc/flutter_bloc.dart';
import 'details_state.dart';





class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(DetailsState());

  void updateCardDetails({
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    bool? isCvvFocused,
    String? plateNumber,
  }) {
    emit(state.copyWith(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      isCvvFocused: isCvvFocused,
      plateNumber: plateNumber,
    ));
  }

  void startLoading() {
    emit(state.copyWith(isLoading: true));
  }

  void stopLoading() {
    emit(state.copyWith(isLoading: false));
  }
}