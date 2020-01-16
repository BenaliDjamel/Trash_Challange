import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/auth.dart';
import 'package:trash_app/providers/challange.dart';
import 'package:trash_app/providers/comment.dart';
import 'package:trash_app/screens/Comments.dart';
import 'package:trash_app/screens/add_challange_form.dart';
import 'package:trash_app/screens/auth_screen.dart';
import 'package:trash_app/screens/challanges_screen.dart';
import 'package:trash_app/screens/main_screen.dart';
import 'package:trash_app/screens/user_challange.dart';
import 'package:trash_app/screens/user_friend_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ChallangeNotifier>(
            create: (context) => null,
            update: (context, auth, previouseChallanges) => ChallangeNotifier(
                auth.token,
                auth.userId,
                previouseChallanges == null
                    ? []
                    : previouseChallanges.challanges),
            //
          ),
          ChangeNotifierProxyProvider<Auth, CommentNotifier>(
            create: (context) => null,
            update: (context, auth, previousComments) => CommentNotifier(
                auth.token,
                auth.userId,
                previousComments == null ? [] : previousComments.comments),
          )

          /*     ChangeNotifierProvider(
            create: (context) => ChallangeNotifier(),
          ) */
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? MainScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator())
                            : AuthScreen(),
                  ),
            routes: {
              ChallangesScreen.routeName: (context) => ChallangesScreen(),
              UserChallange.routeName: (context) => UserChallange(),
              UserFriendList.routeName: (context) => UserFriendList(),
              AddChallangeForm.routeName: (context) => AddChallangeForm(),
              Comments.routeName: (context) => Comments()
            },
          ),
        ));
  }
}
