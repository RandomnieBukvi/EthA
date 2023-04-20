import 'package:flutter/material.dart';
import 'package:lets_go/constans.dart';

class Utils {
  static void showSnackBar(
      {required BuildContext context,
      required String text,
      required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  static void showDialogCustom(
      {required BuildContext context,
      required String title,
      required String content}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: const RoundedRectangleBorder(
            //side: BorderSide(color: kPrimaryColor, style: BorderStyle.solid, width: 10),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              //const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  content,
                  style: TextStyle(fontSize: 25),
                ),
              )
            ]),
      ),
    );
  }
}
