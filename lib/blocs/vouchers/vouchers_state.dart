import 'package:snacc/models.dart';


class VouchersState {
  final bool isInitialising;
  final bool isLoading;
  final bool noVouchers;
  final List<Voucher> vouchers;
  final List<Voucher> currentVouchers;
  final List<Voucher> expiredVouchers;
  final Voucher viewingVoucher;
  final bool viewVoucher;
  final Stream<List<Voucher>> vouchersStream;
  final bool streamEnded;

  VouchersState({
    this.isInitialising,
    this.isLoading,
    this.vouchers,
    this.currentVouchers,
    this.expiredVouchers,
    this.noVouchers,
    this.viewingVoucher,
    this.viewVoucher,
    this.vouchersStream,
    this.streamEnded
  });

  factory VouchersState.initialising() => VouchersState(
    isInitialising: true,
    isLoading: false,
    noVouchers: false,
    viewVoucher: false,
    streamEnded: false,
  );

  VouchersState copyWith({bool isInitialising, bool isLoading, List<Voucher> vouchers,
  List<Voucher> currentVouchers, List<Voucher> expiredVouchers, bool noVouchers,
  bool viewVoucher, Voucher viewingVoucher, Stream<List<Voucher>> vouchersStream,
  bool streamEnded}) {
    return VouchersState(
      isInitialising: isInitialising ?? this.isInitialising,
      isLoading: isLoading ?? this.isLoading,
      vouchers: vouchers ?? this.vouchers,
      currentVouchers: currentVouchers ?? this.currentVouchers,
      expiredVouchers: expiredVouchers ?? this.expiredVouchers,
      noVouchers: noVouchers ?? this.noVouchers,
      viewVoucher: viewVoucher ?? this.viewVoucher,
      viewingVoucher:  viewingVoucher ?? this.viewingVoucher,
      vouchersStream: vouchersStream ?? this.vouchersStream,
      streamEnded: streamEnded ?? this.streamEnded
    );
  }
}