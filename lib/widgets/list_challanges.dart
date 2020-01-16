import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/challange.dart';

class ListChallanges extends StatelessWidget {
  Future<void> _refreshChallanges(BuildContext context) async {
    await Provider.of<ChallangeNotifier>(context, listen: false)
        .fetchAndSetChallanges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshChallanges(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<ChallangeNotifier>(
              builder: (context, challangesData, _) => ListView.builder(
                itemCount: challangesData.challanges.length,
                itemBuilder: (context, i) => Dismissible(
                    key: ValueKey(challangesData.challanges[i].id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      color: Theme.of(context).errorColor,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
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
                                      Navigator.of(context).pop(true);
                                    },
                                  )
                                ],
                              ));
                    },
                    onDismissed: (direction) {
                      Provider.of<ChallangeNotifier>(context)
                          .removeChallange(challangesData.challanges[i].id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(challangesData.challanges[i].id.toString()),
                        ),
                        title: Text(challangesData.challanges[i].country),
                      ),
                    )),
              ),
            ),
    );
  }
}
