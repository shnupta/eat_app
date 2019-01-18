import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/vouchers.dart';

import 'package:snacc/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VouchersBloc extends Bloc<VouchersEvent, VouchersState> {
  VouchersState get initialState => VouchersState.initialising();

  @override
  Stream<VouchersState> mapEventToState(
      VouchersState state, VouchersEvent event) async* {
    if (event is InitialiseEvent) {
      // Load this user's voucher info, initialise the variables in the state
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      User user = User.fromFirebaseUser(firebaseUser);
      List<Voucher> vouchers = await user.loadAllVouchers();

      if (vouchers.isNotEmpty) {
        // Now split into two lists of current and expired vouchers
        List<Voucher> current = vouchers
            .where((voucher) => voucher.bookingTime.isAfter(DateTime.now())).toList();
        List<Voucher> expired = vouchers
            .where((voucher) => voucher.bookingTime.isBefore(DateTime.now())).toList();

        yield state.copyWith(currentVouchers: current, expiredVouchers: expired, isInitialising: false);
      } else {
        yield state.copyWith(isInitialising: false, noVouchers: true);
      }
    } else if(event is ViewVoucherEvent) {
      yield state.copyWith(viewVoucher: true, viewingVoucher: event.voucher);
    } else if (event is ClearViewingVoucherEvent) {
      yield state.copyWith(viewVoucher: false, viewingVoucher: null);
    }
  }

  void initialise() {
    dispatch(InitialiseEvent());
  }

  void viewVoucher(Voucher voucher) {
    dispatch(ViewVoucherEvent(voucher: voucher));
  }

  void clearViewing() {
    dispatch(ClearViewingVoucherEvent());
  }
}
