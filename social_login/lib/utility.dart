import 'package:flutter/material.dart';

class Utility{

 showDialog(String message,BuildContext context ) {
   showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
     title: Text(message,style: const TextStyle(color: Colors.red),),
     actions: [
       InkWell(
         onTap: (){
           Navigator.pop(context);
         },
           child: const Text('Cancel')),
     ],
   ),);
  }
}