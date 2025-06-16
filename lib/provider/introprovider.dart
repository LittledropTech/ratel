import 'package:flutter/cupertino.dart';

class Loadingprovider with ChangeNotifier{

  bool _isloading =true;
  bool get isloading => _isloading;


    Loadingprovider(){
      loader();
    }

   Future<void>loader ()async{
     await Future.delayed(Duration(seconds: 5),);
     _isloading=false;
    notifyListeners();
   }
}