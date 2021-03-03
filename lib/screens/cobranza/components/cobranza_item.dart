import 'package:flutter/material.dart';
import 'package:microbank_app/models/cobranza.dart';
import 'package:microbank_app/screens/credito/extornar_credito_screen.dart';
import 'package:microbank_app/screens/credito/pagar_credito_screen.dart';
import 'package:microbank_app/utils/constans.dart';
import 'package:microbank_app/utils/utils.dart';

class CobranzaItem extends StatelessWidget {
  final TipoCobranza type;
  final Cobranza cobranza;
  CobranzaItem({this.type, this.cobranza});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (type == TipoCobranza.pendiente) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PagarCreditoScreen(
                idCredito: cobranza.idCredito,
                nombre: cobranza.nombres,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExtornarCreditoScreen(
                nombre: cobranza.nombres,
                idKardex: cobranza.idKardex,
                idCredito: cobranza.idCredito,
              ),
            ),
          );
        }
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          toTitleCase(cobranza.nombres),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          type == TipoCobranza.pendiente
                              ? (cobranza.diasAtraso.toString() +
                                  ' días atrasados')
                              : cobranza.hora,
                          style: type == TipoCobranza.pendiente
                              ? TextStyle(color: Colors.red)
                              : TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'S/ ' +
                        (type == TipoCobranza.pendiente
                            ? cobranza.montoDeuda.toStringAsFixed(2)
                            : cobranza.montoPagado.toStringAsFixed(2)),
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
