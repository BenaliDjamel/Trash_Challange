import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/screens/Comments.dart';
import 'package:trash_app/screens/add_challange_form.dart';

import 'package:trash_app/widgets/caroussel.dart';
import 'package:trash_app/widgets/stack.dart';
import '../providers/challange.dart';
import 'package:jiffy/jiffy.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChallange extends StatefulWidget {
  static const routeName = '/user-challanges';

  @override
  _UserChallangeState createState() => _UserChallangeState();
}

class _UserChallangeState extends State<UserChallange> {
  Future<void> _refreshChallanges(BuildContext context) async {
    await Provider.of<ChallangeNotifier>(context, listen: false)
        .fetchAndSetUserChallange();
  }

  void _confirmDeletion(int id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure !'),
              content: Text('Do you want to delete chalange'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Provider.of<ChallangeNotifier>(context)
                        .removeChallange(id)
                        .then((_) {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ));
  }

  void _showOptionBottomSheet(int id) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 200,
            child: Container(
              child: _buildBottomNavigationMenu(id),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
    //_buildBottomNavigationMenu(id);
  }

  Column _buildBottomNavigationMenu(int id) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit Challange',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
              )),
          onTap: () {
            print('editing...');
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
              )),
          onTap: () {
            _confirmDeletion(id);
          },
        ),
        ListTile(
          leading: Icon(Icons.block),
          title: Text(
            'Disable Challange',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text('This challange will not be shown'),
          onTap: () {
            print('disabling...');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My challanges'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddChallangeForm.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshChallanges(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshChallanges(context),
                child: Consumer<ChallangeNotifier>(
                  builder: (context, challangesData, _) => ListView.builder(
                      itemCount: challangesData.challanges.length,
                      itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 6),
                            child: Card(
                              elevation: 5,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.all(5),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          challangesData.challanges[i].photos[0]
                                              ['path']),
                                    ),
                                    title: Text('Benali Djamel',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                        )),
                                    subtitle: Text(
                                        Jiffy(
                                          challangesData
                                              .challanges[i].created_at,
                                        ).fromNow(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w400,
                                        )),
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_horiz),
                                      onPressed: () {
                                        _showOptionBottomSheet(
                                            challangesData.challanges[i].id);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Machine Learning Beginner course (MLBC) is a course devoted to beginners in the domain of machine learning, this course will reveal the idea behind machine learning and its philosophy, the types, techniques, and tools to know as newcomers.',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              height: 1.5),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Sunday, January 19, 2020 ',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey.shade600),
                                        ),
                                        Text('12:30 PM to 2:00 PM',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  ),
                                  Caroussel(
                                      challangesData.challanges[i].photos),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ParticipantStack(),
                                      FlatButton.icon(
                                        // color: Colors.black12,
                                        icon: Icon(Icons.comment,
                                            color: Colors.grey.shade600),
                                        label: Text(
                                          '21 comments',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey.shade600),
                                        ),

                                        onPressed: () {
                                         // _showCommentsBottomSheet(1);
                                            Navigator.of(context).pushNamed(
                                              Comments.routeName,
                                              arguments: challangesData.challanges[i].id); 
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          )),
                ),
              ),
      ),
    );
  }
}
