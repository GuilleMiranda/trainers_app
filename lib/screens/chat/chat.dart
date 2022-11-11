import 'package:flutter/material.dart';
import 'package:trainers_app/model/entrenador.dart';

class Chat extends StatelessWidget {
  static const routeName = '/chat';

  late Entrenador entrenador;

  @override
  Widget build(BuildContext context) {
    entrenador = ModalRoute.of(context)!.settings.arguments as Entrenador;
    return Scaffold(
      appBar: AppBar(
        title: Text(entrenador.nombreMostrado),
      ),
      body: null,
    );
  }

  // Widget buildInput() {
  //   return Container(
  //       child: Row(
  //         children: <Widget>[
  //           // Button send image
  //           Material(
  //             child: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 1),
  //               child: IconButton(
  //                 icon: Icon(Icons.image),
  //                 onPressed: getImage,
  //                 color: ColorConstants.primaryColor,
  //               ),
  //             ),
  //             color: Colors.white,
  //           ),
  //           Material(
  //             child: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 1),
  //               child: IconButton(
  //                 icon: Icon(Icons.face),
  //                 onPressed: getSticker,
  //                 color: ColorConstants.primaryColor,
  //               ),
  //             ),
  //             color: Colors.white,
  //           ),
  //
  //           // Edit text
  //           Flexible(
  //             child: Container(
  //               child: TextField(
  //                 onSubmitted: (value) {
  //                   onSendMessage(textEditingController.text, TypeMessage.text);
  //                 },
  //                 style: TextStyle(color: ColorConstants.primaryColor, fontSize: 15),
  //                 controller: textEditingController,
  //                 decoration: InputDecoration.collapsed(
  //                   hintText: 'Type your message...',
  //                   hintStyle: TextStyle(color: ColorConstants.greyColor),
  //                 ),
  //                 focusNode: focusNode,
  //                 autofocus: true,
  //               ),
  //             ),
  //           ),
  //
  //           // Button send message
  //           Material(
  //             child: Container(
  //               margin: EdgeInsets.symmetric(horizontal: 8),
  //               child: IconButton(
  //                 icon: Icon(Icons.send),
  //                 onPressed: () => null,
  //
  //               ),
  //             ),
  //             color: Colors.white,
  //           ),
  //         ],
  //       ),
  //       width: double.infinity,
  //       height: 50,
  //       decoration: BoxDecoration(
  //   border: Border(top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)), color: Colors.white),
  //   );
  // }


}
