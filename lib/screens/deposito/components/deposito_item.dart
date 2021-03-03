import 'package:flutter/material.dart';
import 'package:microbank_app/models/deposito.dart';
import 'package:microbank_app/screens/deposito/extornar_deposito_screen.dart';
import 'package:microbank_app/utils/constans.dart';

class DepositoItem extends StatelessWidget {
  final Deposito deposito;
  DepositoItem({this.deposito});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExtornarDepositoScreen(
              idKardex: deposito.idKardex,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deposito.banco,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        deposito.hora,
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                  Text(
                    'S/ ' + deposito.importe,
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
