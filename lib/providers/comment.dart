import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_app/providers/api.dart';
import 'package:http/http.dart' as http;
import 'package:trash_app/providers/auth.dart';

class Comment {
  final int id;
  final int challangeId;
  final String content;
  final String createdAt;

  Comment({this.id, this.challangeId, this.content, this.createdAt});
}

class CommentNotifier with ChangeNotifier {
  List<Comment> _comments = [];
  String authToken;
  int userId;

  CommentNotifier(this.authToken, this.userId, this._comments);

  List<Comment> get comments {
    return [..._comments];
  }

  Future<void> fetchAndSetComments(int challangeId) async {
    print('call comments');
    try {
      final response = await http.get(
          '${Api.url}/api/comment/comments/$challangeId',
          headers: {'Authorization': authToken});

      if (400 <= response.statusCode) {
        print('error code ${response.statusCode}');
        return;
      }
      final responseData = json.decode(response.body) as List<dynamic>;
      List<Comment> loadedComment = [];

      responseData.forEach((comment) {
        loadedComment.add(new Comment(
            id: comment['id'],
            challangeId: comment['challange_id'],
            content: comment['content'],
            createdAt: comment['created_at']));
      });

      _comments = loadedComment;
      _comments.forEach((comment) => print('${comment.content}'));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addComment(int challangeId, String content) async {
    try {
      final response = await http.post(
          '${Api.url}/api/comment/store/$challangeId',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': authToken
          },
          body: json.encode({'content': content}));

      if (400 <= response.statusCode) {
        print('error code ${response.statusCode}');
        return;
      }
      final responseData = json.decode(response.body);
      print(responseData['id']);

      _comments.insert(
          0,
          new Comment(
              id: responseData['id'],
              challangeId: challangeId,
              content: responseData['content'],
              createdAt: responseData['created_at']));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeComment(int id) async {
    final response = await http.delete('${Api.url}/api/comment/comments/delete/$id',
        headers: {'Authorization': authToken});

    if (response.statusCode >= 400) {
      print(response.statusCode);
      return;
    }

    _comments.removeWhere((comment) => comment.id == id);
    notifyListeners();

    print('-----------------${response.body}');
  }
}
