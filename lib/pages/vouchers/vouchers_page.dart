import 'package:flutter/material.dart';

import 'package:snacc/blocs/vouchers.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

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
            } else {
              return TabBarView(
                children: <Widget>[
                  _buildCurrentVouchers(state),
                  _buildExpiredVouchers(state),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCurrentVouchers(VouchersState state) {
    if (state.currentVouchers.isEmpty) {
      return Center(child: Text('You have no current vouchers'));
    } else {
      return ListView(
        children: state.currentVouchers
            .map(
              (voucher) => ListTile(
                    title: Text(voucher.id),
                    subtitle: Text(voucher.bookingTime.toString()),
                  ),
            )
            .toList(),
      );
    }
  }

  Widget _buildExpiredVouchers(VouchersState state) {
    if (state.expiredVouchers.isEmpty) {
      return Center(
        child: Text('You have no expired vouchers'),
      );
    } else {
      return ListView(
        children: state.expiredVouchers
            .map(
              (voucher) => ListTile(
                    title: Text(voucher.id),
                    subtitle: Text(voucher.bookingTime.toString()),
                  ),
            )
            .toList(),
      );
    }
  }
}
