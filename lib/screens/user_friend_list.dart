import 'dart:math';

import 'package:flutter/material.dart';

class UserFriendList extends StatelessWidget {
  static const routeName = '/user-friend-list';

  final List<String> _myFriend = ['Benali Djamel', 'Ayat Amine', 'Smail Mostapha'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My challanges'),
      ),
      body: ListView.builder(
        itemCount: _myFriend.length,
        itemBuilder: (context, i) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Image.asset('assets/images/u.png'),
          ),
          title: Text(_myFriend[i]),
        subtitle: Text('${ Random().nextInt(15) + i} challanges'),
        ),
      ),
    );
  }
}
