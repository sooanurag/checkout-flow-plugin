import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FPlatformView extends StatelessWidget {
  const FPlatformView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AndroidView(
      viewType: 'card_form_view',
      layoutDirection: TextDirection.ltr,
      creationParams: null,
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}