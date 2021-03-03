import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:microbank_app/utils/constans.dart';

class LoadingPage extends StatelessWidget {
  final Widget child;
  final bool isShowSpinner;
  LoadingPage({this.child, this.isShowSpinner = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          child,
          isShowSpinner
              ? Container(
                  color: Colors.black.withOpacity(0.8),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: SpinKitThreeBounce(
                      size: 25.0,
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.white : kPrimaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
