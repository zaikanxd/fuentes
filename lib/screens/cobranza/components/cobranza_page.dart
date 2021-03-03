import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:microbank_app/components/custom_card.dart';
import 'package:microbank_app/models/cobranza.dart';
import 'package:microbank_app/screens/cobranza/components/cobranza_item.dart';
import 'package:microbank_app/utils/constans.dart';

class CobranzaPage extends StatelessWidget {
  final Future future;
  final Function onRefresh;
  final TipoCobranza type;
  final bool showHeader;
  final bool soloCobranzaAtrasada;
  CobranzaPage(
      {this.type,
      this.future,
      this.onRefresh,
      this.showHeader = true,
      this.soloCobranzaAtrasada});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: kAccentColor,
      displacement: 25.0,
      strokeWidth: 3.0,
      onRefresh: onRefresh,
      child: FutureBuilder<List<Cobranza>>(
        future: future,
        builder:
            (BuildContext context, AsyncSnapshot<List<Cobranza>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            List<Cobranza> cobranzas = snapshot.data;
            if (type == TipoCobranza.pendiente) {
              cobranzas.sort((before, after) =>
                  after.diasAtraso.compareTo(before.diasAtraso));
              if (soloCobranzaAtrasada) {
                cobranzas = cobranzas
                    .where((cobranza) => cobranza.diasAtraso >= 0)
                    .toList();
              }
            }
            children = <Widget>[
              showHeader
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: kHorizontalMarginSize * 1.5,
                          right: kHorizontalMarginSize * 1.5,
                          top: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                type == TipoCobranza.pendiente
                                    ? 'Cobranzas Pendientes'
                                    : 'Cobranzas Realizadas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 25.0),
                                child: Text(
                                  cobranzas.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              cobranzas.length > 0
                  ? Expanded(
                      child: CustomCard(
                        marginTop: 20.0,
                        child: ListView.builder(
                          itemCount: cobranzas.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CobranzaItem(
                                type: type, cobranza: cobranzas[index]);
                          },
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 20.0,
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error,
                size: 35.0,
                color: Colors.red,
              ),
              Text(
                'Ooopps!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Ocurrío un error. Intentelo nuevamente',
                style: TextStyle(color: Colors.black54),
              )
            ];
          } else {
            children = <Widget>[
              SpinKitCircle(
                size: 30.0,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                    ),
                  );
                },
              ),
            ];
          }
          return snapshot.hasData
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
        },
      ),
    );
  }
}
