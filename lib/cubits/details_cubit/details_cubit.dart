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
    emit(
      DetailsState(
        cardNumber: cardNumber ?? state.cardNumber,
        expiryDate: expiryDate ?? state.expiryDate,
        cardHolderName: cardHolderName ?? state.cardHolderName,
        cvvCode: cvvCode ?? state.cvvCode,
        isCvvFocused: isCvvFocused ?? state.isCvvFocused,
        isLoading: state.isLoading,
        plateNumber: plateNumber ?? state.plateNumber,
      ),
    );
  }

  void startLoading() {
    emit(
      DetailsState(
        cardNumber: state.cardNumber,
        expiryDate: state.expiryDate,
        cardHolderName: state.cardHolderName,
        cvvCode: state.cvvCode,
        isCvvFocused: state.isCvvFocused,
        isLoading: true,
        plateNumber: state.plateNumber,
      ),
    );
  }

  void stopLoading() {
    emit(
      DetailsState(
        cardNumber: state.cardNumber,
        expiryDate: state.expiryDate,
        cardHolderName: state.cardHolderName,
        cvvCode: state.cvvCode,
        isCvvFocused: state.isCvvFocused,
        isLoading: false,
        plateNumber: state.plateNumber,
      ),
    );
  }

  void resetCardDetails() {
    emit(
      DetailsState(
        cardNumber: '',
        expiryDate: '',
        cardHolderName: '',
        cvvCode: '',
        isCvvFocused: false,
        isLoading: false,
        plateNumber: '',
      ),
    );
  }
}
