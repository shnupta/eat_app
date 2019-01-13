import 'package:snacc/models.dart';


class VouchersState {
  final bool isInitialising;
  final bool isLoading;
  final List<Voucher> vouchers;
  final List<Voucher> currentVouchers;
  final List<Voucher> expiredVouchers;

  VouchersState({
    this.isInitialising,
    this.isLoading,
    this.vouchers,
    this.currentVouchers,
    this.expiredVouchers
  });

  factory VouchersState.initialising() => VouchersState(
    isInitialising: true,
    isLoading: false,
  );

  VouchersState copyWith({bool isInitialising, bool isLoading, List<Voucher> vouchers,
  List<Voucher> currentVouchers, List<Voucher> expiredVouchers}) {
    return VouchersState(
      isInitialising: isInitialising ?? this.isInitialising,
      isLoading: isLoading ?? this.isLoading,
      vouchers: vouchers ?? this.vouchers,
      currentVouchers: currentVouchers ?? this.currentVouchers,
      expiredVouchers: expiredVouchers ?? this.expiredVouchers,
    );
  }
}