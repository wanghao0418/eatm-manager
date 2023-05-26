import 'package:flutter/foundation.dart';

class SignedInModel extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  set isSignedIn(bool isSignedIn) {
    _isSignedIn = isSignedIn;
    notifyListeners();
  }
}
