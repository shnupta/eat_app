import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:snacc/pages/home.dart';
import 'package:snacc/pages/settings.dart';
import 'package:snacc/pages/find_a_restaurant.dart';

import 'package:snacc/blocs/news.dart';
import 'package:snacc/blocs/find_a_restaurant.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/widgets.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

// This page will be responsible for initialising the blocs that will be needed by child pages.
// It will also act as a kind of container around all the other pages that can be visited when
// a user is logged in.

class HomeContainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeContainerPageState();
  }
}

class _HomeContainerPageState extends State<HomeContainerPage> {
  NewsBloc newsBloc = NewsBloc();
  FindARestaurantBloc findARestaurantBloc = FindARestaurantBloc();

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId('sq0idp-dM3l69cCh00A0bdqtMEPOw');
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  /**
  * Callback when card entry is cancelled and UI is closed
  */
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  /**
  * Callback when successfully get the card nonce details for processig
  * card entry is still open and waiting for processing card nonce details
  */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.message);
    }
  }

  /**
  * Callback when the card entry is closed after call 'completeCardEntry'
  */
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }

  @override
  Widget build(BuildContext context) {
    _initSquarePayment();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            BlocProvider(
              bloc: newsBloc,
              child: HomePage(),
            ),
            BlocProvider(
                bloc: findARestaurantBloc, child: FindARestaurantPage()),
            Container(
              child: Center(
                child: StandardFilledButton(
                  text: 'Launch Square Card Input',
                  onPressed: () => _onStartCardEntryFlow(),
                ),
              ),
            ),
            SettingsPage(),
          ],
        ),
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Colors.blueGrey[300],
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.receipt),
              ),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}
