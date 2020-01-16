import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParticipantStack extends StatelessWidget {
  void _onButtonPressed(int id, context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: double.infinity,
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

  List<Widget> participant() {
    List<Widget> list = [];
    for (var i = 0; i < 20; i++) {
      list.add(
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
          ),
          title: Text(
            'Ayat Amine $i',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: OutlineButton(
            child: Text(
              'See profile',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400, color: Colors.lightBlue),
            ),
            onPressed: () {},
            color: Colors.lightBlue,
          ),
          subtitle: Text(
            "Particip 12 chalange",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),
          ),
          onTap: () {
            print('editing...');
          },
        ),
      );
    }

    return list;
  }

  ListView _buildBottomNavigationMenu(int id) {
    return ListView(children: participant());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 50.0,
      width: 150.0,
      // alignment: FractionalOffset.center,
      child: GestureDetector(
        onTap: () {
          print('list of participants');
          _onButtonPressed(1, context);
        },
        child: Stack(
          //alignment: Alignment(x, y)
          children: <Widget>[
            Container(
              height: 25,
              width: 25,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
              ),
            ),
            Positioned(
                left: 20.0,
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
                  ),
                )),
            Positioned(
                left: 40.0,
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
                  ),
                )),
            Positioned(
                left: 60.0,
                child: Container(
                  height: 25,
                  width: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/trash-ec2ff.appspot.com/o/image_cropper_1578739301230.jpg?alt=media&token=9a12d4d0-427e-42f5-887d-5d18281e2e75"),
                  ),
                )),
            Positioned(
              left: 80.0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Color(0xff535353)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Icon(Icons.add, size: 12.0, color: Colors.white),
                    Text(
                      '+9',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          fontSize: 12,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
