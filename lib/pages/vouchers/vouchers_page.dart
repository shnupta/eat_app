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
            return TabBarView(
              children: <Widget>[
                Center(
                  child: Text('current'),
                ),
                Center(
                  child: Text('expired'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
