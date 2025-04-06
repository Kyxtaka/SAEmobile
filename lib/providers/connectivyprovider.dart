import 'package:flutter/material.dart';
import 'package:internet_connection_control_alert/internet_connection_control_alert.dart';

class ConnectivityProvider {

  static void checkConnectovity(BuildContext context) {
    Internet.delayStart(
        context: context,
        delay: 1500,
        barrier: false,
        alert: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),
          content: Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: [
                Icon(Icons.wifi_off_rounded, size: 50),
                Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  "Internet n'est pas disponible pour le moment. Verifier votre connection internet et réessayer.",
                )
              ],
            ),
          ),
        )
    );
  }

  static void checkAndHandleRequiredConnectivity(BuildContext context, bool barrier) {
    Internet.start(
      context: context,
      barrier: barrier,
      alert: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        content: Container(
          height: 200,
          padding: const EdgeInsets.all(25),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20,
            children:
            [
              Icon(Icons.wifi_off_rounded, size: 50),
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
                "Connection internet perdu, verifier la s'il vous plait",
              )
            ],
          ),
        ),
      ),
    );
  }
}