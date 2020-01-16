import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Caroussel extends StatefulWidget {
  List photo;

  Caroussel(this.photo);
  @override
  _CarousselState createState() => _CarousselState();
}

class _CarousselState extends State<Caroussel> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider(
          height: widget.photo.isEmpty ? 0 : 200,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          aspectRatio: 2.0,
          enableInfiniteScroll: false,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
          items: widget.photo.map((img) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: Image.network(
                      img['path'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ));
              },
            );
          }).toList(),
        ),
        Positioned(
            top: 170.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.photo.asMap().entries.map((entry) {
                int index = entry.key;

                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: widget.photo.length == 1
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.white
                              : Color.fromRGBO(0, 0, 0, 0.4)),
                );
              }).toList(),
            )),
      ],
    );
  }
}
