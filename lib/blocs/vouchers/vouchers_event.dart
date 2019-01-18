import 'package:flutter/material.dart';

import 'package:snacc/models.dart';


abstract class VouchersEvent {}

class InitialiseEvent extends VouchersEvent {}

class ViewVoucherEvent extends VouchersEvent {
  final Voucher voucher;

  ViewVoucherEvent({@required this.voucher});
}

class ClearViewingVoucherEvent extends VouchersEvent {}