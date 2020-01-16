import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/comment.dart';
import 'package:trash_app/widgets/comment_form.dart';

class Comments extends StatefulWidget {
  static const routeName = "/comments";

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {




  
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
                    Provider.of<CommentNotifier>(context)
                        .removeComment(id)
                        .then((_) {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ));
  }

  Column _buildBottomNavigationMenu(int id) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit',
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
            'Hide from challange',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text('This comment will not be shown'),
          onTap: () {
            print('disabling...');
          },
        ),
      ],
    );
  }

 

  @override
  Widget build(BuildContext context) {
    // Provider.of<CommentNotifier>(context, listen: false).fetchAndSetComments(41);
    int challangeId = ModalRoute.of(context).settings.arguments;
    print('--------------$challangeId');
    return Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: FutureBuilder(
          future: Provider.of<CommentNotifier>(context, listen: false)
              .fetchAndSetComments(challangeId),
          builder: (context, snapashoot) => snapashoot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text("All Comments"),
                    Consumer<CommentNotifier>(
                      builder: (context, commentsData, _) => Expanded(
                        child: ListView.builder(
                          itemCount: commentsData.comments.length,
                          itemBuilder: (context, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showOptionBottomSheet(commentsData.comments[i].id);
                              },
                            ),
                            title: Text(
                              commentsData.comments[i].challangeId.toString(),
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: Text(
                              commentsData.comments[i].content,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400),
                            ),
                            onTap: () {
                              print('editing...');
                            },
                          ),
                        ),
                      ),
                    ),
                    CommentForm(challangeId)
                  ],
                ),
        ));
  }
}
