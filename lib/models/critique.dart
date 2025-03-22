import 'package:saemobile/models/restaurant.dart';
import 'package:saemobile/models/user.dart';

class Critique {
  final int _id;
  final String _message;
  final Restaurant _restaurant;
  final User _user;
  final String _date_test;
  final int _note;

  const Critique(
      this._id,
      this._message,
      this._restaurant,
      this._user,
      this._date_test,
      this._note);

  int get id => _id;

  String get message => _message;

  Restaurant get restaurant => _restaurant;

  User get user => _user;

  String get date_test => _date_test;

  int get note => _note;

  void debugPrint() {
    String critique = "id: $_id, message: $_message, restaurant: $_restaurant, user: $_user, date_test: $_date_test, note: $_note";
    print(critique);
  }

  Map<String, Object?> toMapLocal() {
    return {
      'id': _id,
      'message': _message,
      'note': _note
    };
  }

}