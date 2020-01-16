import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/screens/challanges_screen.dart';
import 'package:trash_app/screens/user_challange.dart';
import 'package:trash_app/screens/user_friend_list.dart';
import '../providers/auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      child: Image.asset('assets/images/u.png'),
                    )),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Benali Djamel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Djamel.benali@gmail.com',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.white),
          ),
//Divider(),
          ListTile(
            leading: Icon(Icons.trending_up),
            title: Text('Challanges'),
            onTap: () {
              print('challanges');
              // to close the  drawer
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ChallangesScreen.routeName);
            },
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My challenges'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserChallange.routeName);
            },
          ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('My friends'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserFriendList.routeName);
            },
          ),
          //  Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              print('challanges');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              _auth.logout();
            },
          )
        ],
      ),
    );
  }
}
