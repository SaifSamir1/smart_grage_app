class DetailsState {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isCvvFocused;
  final bool isLoading;
  final String plateNumber; // Added for car plate number

  DetailsState({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
    this.isCvvFocused = false,
    this.isLoading = false,
    this.plateNumber = '',
  });

  DetailsState copyWith({
    String? cardNumber,
    String? expiryDate,
    String? cardHolderName,
    String? cvvCode,
    bool? isCvvFocused,
    bool? isLoading,
    String? plateNumber,
  }) {
    return DetailsState(
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvvCode: cvvCode ?? this.cvvCode,
      isCvvFocused: isCvvFocused ?? this.isCvvFocused,
      isLoading: isLoading ?? this.isLoading,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}