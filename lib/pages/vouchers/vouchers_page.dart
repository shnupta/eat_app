import 'package:flutter/material.dart';

import 'package:snacc/blocs/vouchers.dart';
import 'package:snacc/models.dart';

import 'package:snacc/pages/vouchers/voucher_tile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:date_utils/date_utils.dart' as du;

/// The [VouchersPage] is the page that shows the user all of their upcoming and expired vouchers.
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
                  state.streamEnded
                      ? _buildCurrentVouchers(state, vouchersBloc)
                      : _buildCurrentVouchersStream(state, vouchersBloc),
                  state.streamEnded
                      ? _buildExpiredVouchers(state, vouchersBloc)
                      : _buildExpiredVouchersStream(state, vouchersBloc),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      '${state.viewingVoucher.bookingDay[0].toUpperCase()}${state.viewingVoucher.bookingDay.substring(1)} ${state.viewingVoucher.bookingTime.day} ${du.Utils.formatMonth(state.viewingVoucher.bookingTime)}',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Table for ${state.viewingVoucher.numberOfPeople} at ${state.viewingVoucher.bookingTime.hour}:${state.viewingVoucher.bookingTime.minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Discount: ${state.viewingVoucher.discount}%',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Upon arrival, inform the restaurant\nof your booking through the app\nand make sure they scan the QR code.',
                      textAlign: TextAlign.center,
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
                  state.streamEnded
                      ? _buildCurrentVouchers(state, vouchersBloc)
                      : _buildCurrentVouchersStream(state, vouchersBloc),
                  state.streamEnded
                      ? _buildExpiredVouchers(state, vouchersBloc)
                      : _buildExpiredVouchersStream(state, vouchersBloc),
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
      List<GestureDetector> tiles = state.currentVouchers
          .map((voucher) => GestureDetector(
                onTap: () => vouchersBloc.viewVoucher(voucher),
                child: VoucherTile(
                  voucher: voucher,
                ),
              ))
          .toList();
      // Order the vouchers so the ones closest are at the top
      tiles.sort((one, two) => (one.child as VoucherTile)
          .voucher
          .bookingTime
          .compareTo((two.child as VoucherTile).voucher.bookingTime));
      return ListView(
        children: tiles,
      );
    }
  }

  Widget _buildCurrentVouchersStream(
      VouchersState state, VouchersBloc vouchersBloc) {
    return StreamBuilder(
      initialData: List<Voucher>(),
      stream: state.vouchersStream,
      builder: (BuildContext context, AsyncSnapshot<List<Voucher>> snapshot) {
        if (snapshot.data.isEmpty) {
          return Center(
            child: Text('Loading...'),
          );
        }
        List<Voucher> currentVouchers = snapshot.data
            .where((voucher) => voucher.bookingTime.isAfter(DateTime.now()))
            .toList();
        List<GestureDetector> tiles = currentVouchers
            .map((voucher) => GestureDetector(
                  onTap: () => vouchersBloc.viewVoucher(voucher),
                  child: VoucherTile(
                    voucher: voucher,
                  ),
                ))
            .toList();
        if (tiles.isEmpty) {
          return Center(child: Text('Loading...'));
        }
        // Order the vouchers so the ones closest are at the top
        tiles.sort((one, two) => (one.child as VoucherTile)
            .voucher
            .bookingTime
            .compareTo((two.child as VoucherTile).voucher.bookingTime));
        return ListView(
          children: tiles,
        );
      },
    );
  }

  Widget _buildExpiredVouchersStream(
      VouchersState state, VouchersBloc vouchersBloc) {
    return StreamBuilder(
      initialData: List<Voucher>(),
      stream: state.vouchersStream,
      builder: (BuildContext context, AsyncSnapshot<List<Voucher>> snapshot) {
        if (snapshot.data.isEmpty) {
          return Center(
            child: Text('Loading...'),
          );
        }
        List<Voucher> expiredVouchers = snapshot.data
            .where((voucher) => voucher.bookingTime.isBefore(DateTime.now()))
            .toList();
        List<GestureDetector> tiles = expiredVouchers
            .map((voucher) => GestureDetector(
                  onTap: () => vouchersBloc.viewVoucher(voucher),
                  child: VoucherTile(
                    voucher: voucher,
                  ),
                ))
            .toList();

        if (tiles.isEmpty) {
          return Center(child: Text('Loading...'));
        }
        // Order the vouchers so the ones closest are at the top
        tiles.sort((one, two) => (one.child as VoucherTile)
            .voucher
            .bookingTime
            .compareTo((two.child as VoucherTile).voucher.bookingTime));
        return ListView(
          children: tiles,
        );
      },
    );
  }

  Widget _buildExpiredVouchers(VouchersState state, VouchersBloc vouchersBloc) {
    if (state.expiredVouchers.isEmpty) {
      return Center(
        child: Text('You have no expired vouchers'),
      );
    } else {
      List<GestureDetector> tiles = state.expiredVouchers
          .map((voucher) => GestureDetector(
                onTap: () => vouchersBloc.viewVoucher(voucher),
                child: VoucherTile(
                  voucher: voucher,
                ),
              ))
          .toList();
      tiles.sort((one, two) => (one.child as VoucherTile)
          .voucher
          .bookingTime
          .compareTo((two.child as VoucherTile).voucher.bookingTime));
      return ListView(
        children: tiles,
      );
    }
  }
}
