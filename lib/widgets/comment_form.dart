import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/comment.dart';

class CommentForm extends StatefulWidget {
  int challangeId;
  CommentForm(this.challangeId);
  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  String content = '';
  bool _isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit(int challangeId) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      WidgetsBinding.instance.addPostFrameCallback(
                                (_) => _commentController.clear());
      
      setState(() {
        _isLoading = true;
      });

      Provider.of<CommentNotifier>(context, listen: false)
          .addComment(challangeId, content)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

    @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // maxLines: 2,
              controller: _commentController,
              decoration: InputDecoration(
                  labelText: "Comment here",
                  fillColor: Colors.white,
                  suffixIcon: _isLoading
                      ? Container( padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),width: 10, height: 10,child: CircularProgressIndicator( ))
                      : IconButton(
                          focusColor: Colors.lightBlueAccent,
                          autofocus: true,
                          icon: Icon(Icons.send),
                          onPressed: () => _submit(widget.challangeId),
                        ),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.lightBlueAccent, width: 2))),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Comment must be at least 1 caracters';
                }

                return null;
              },
              onSaved: (value) {
                content = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
