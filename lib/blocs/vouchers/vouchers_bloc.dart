import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/vouchers.dart';

class VouchersBloc extends Bloc<VouchersEvent, VouchersState> {

  VouchersState get initialState => VouchersState();

  @override
    Stream<VouchersState> mapEventToState(VouchersState state, VouchersEvent event) async* {
      if(event is InitialiseEvent) {
        // Load this user's voucher info, initialise the variables in the state
      }
    }


  void initialise() {
    dispatch(InitialiseEvent());
  }

}