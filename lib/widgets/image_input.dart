import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageInput extends StatefulWidget {
//Function _startUpload;
  List<File> _images;

  ImageInput( this._images);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  /// Starts an upload task
/*   void _startUpload() async {
    /// Unique file name for the file
    // String filePath = 'images/${DateTime.now()}.png';

    //_uploadTask = _storage.ref().child(filePath).putFile(_storedImage);
    _images.forEach((image) async {
      String fileName = path.basename(image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      if (taskSnapshot != null) {
        setState(() {
          print("Profile Picture uploaded");
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Profile Picture Uploaded')));
        });
      }
    });
  } */

  Future<void> _takePicture() async {
    final imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 600);

    if (imageFile == null) return;

    setState(() {
      _storedImage = imageFile;
    });
    _cropImage();

    /* final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget._selectImage(savedImage); */
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _storedImage.path,
    );

    setState(() {
      _storedImage = croppedFile ?? _storedImage;
      widget._images.add(_storedImage);
    });

    // widget._startUpload(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          height: widget._images.isEmpty ? 0 : 200,
          enableInfiniteScroll: false,
          items: widget._images.map((img) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.amber),
                    child: widget._images.isNotEmpty
                        ? Image.file(
                            img,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Text('No Image taken', textAlign: TextAlign.center));
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 10,
        ),
        FlatButton.icon(
          icon: Icon(
            Icons.add_a_photo,
            size: 40,
          ),
          label: Text(
            '(${widget._images.length})',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            _takePicture();
          },
        )
      ],
    );
  }
}
