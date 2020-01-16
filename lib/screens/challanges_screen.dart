import 'package:flutter/material.dart';
import 'package:trash_app/widgets/list_challanges.dart';
import 'package:trash_app/widgets/map_challange.dart';
import 'package:trash_app/widgets/my-drawer.dart';

class ChallangesScreen extends StatelessWidget {
  static const routeName = '/challanges';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Challanges'),
          bottom: TabBar(
            indicatorColor: Colors.yellow,
            tabs: <Widget>[Text('Map'), Text('List')],
          ),
        ),
        body: TabBarView(
          children: <Widget>[MapChallange(), ListChallanges()],
        ),
      ),
    );
  }
}
