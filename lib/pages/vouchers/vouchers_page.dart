import 'package:flutter/material.dart';

import 'package:snacc/blocs/vouchers.dart';

import 'package:snacc/pages/vouchers/voucher_tile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:date_utils/date_utils.dart' as du;

class VouchersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VouchersBloc vouchersBloc = BlocProvider.of<VouchersBloc>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.grey[100],
          title: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(text: 'Current'),
              Tab(text: 'Expired'),
            ],
          ),
        ),
        body: BlocBuilder(
          bloc: vouchersBloc,
          builder: (BuildContext context, VouchersState state) {
            if (state.isInitialising) {
              vouchersBloc.initialise();

              return Center(
                child: Text('Initialising...'),
              );
            }

            if (state.noVouchers) {
              return Center(
                child: Text('You have no vouchers!'),
              );
            } else if (state.viewVoucher) {
              List<Widget> items = List();
              items.add(TabBarView(
                children: <Widget>[
                  _buildCurrentVouchers(state, vouchersBloc),
                  _buildExpiredVouchers(state, vouchersBloc),
                ],
              ));
              items.add(GestureDetector(
                  onTap: () => vouchersBloc.clearViewing(),
                  child: Container(
                    color: Colors.black.withAlpha(80),
                  )));

              items.add(Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    QrImage(
                      data: state.viewingVoucher.id,
                      size: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      state.viewingVoucher.restaurant.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                        '${state.viewingVoucher.bookingDay[0].toUpperCase()}${state.viewingVoucher.bookingDay.substring(1)} ${state.viewingVoucher.bookingTime.day} ${du.Utils.formatMonth(state.viewingVoucher.bookingTime)}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Table for ${state.viewingVoucher.numberOfPeople} at ${state.viewingVoucher.bookingTime.hour}:${state.viewingVoucher.bookingTime.minute}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Upon arrival, inform the restaurant\nof your booking through the app\nand make sure they scan the QR code.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ));

              return Stack(
                children: items,
              );
            } else {
              return TabBarView(
                children: <Widget>[
                  _buildCurrentVouchers(state, vouchersBloc),
                  _buildExpiredVouchers(state, vouchersBloc),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCurrentVouchers(VouchersState state, VouchersBloc vouchersBloc) {
    if (state.currentVouchers.isEmpty) {
      return Center(child: Text('You have no current vouchers'));
    } else {
      return ListView(
        children: state.currentVouchers
            .map((voucher) => GestureDetector(
                  onTap: () => vouchersBloc.viewVoucher(voucher),
                  child: VoucherTile(
                    voucher: voucher,
                  ),
                ))
            .toList(),
      );
    }
  }

  Widget _buildExpiredVouchers(VouchersState state, VouchersBloc vouchersBloc) {
    if (state.expiredVouchers.isEmpty) {
      return Center(
        child: Text('You have no expired vouchers'),
      );
    } else {
      return ListView(
        children: state.expiredVouchers
            .map((voucher) => GestureDetector(
                  onTap: () => vouchersBloc.viewVoucher(voucher),
                  child: VoucherTile(
                    voucher: voucher,
                  ),
                ))
            .toList(),
      );
    }
  }
}
