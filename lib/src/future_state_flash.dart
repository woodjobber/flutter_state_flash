import 'package:flutter/material.dart';

import 'network_state_flash.dart';

class FutureStateFlash extends StatefulWidget {
  const FutureStateFlash(
      {Key? key,
      this.future,
      required this.child,
      this.hintText,
      this.idleBuilder,
      this.waitingBuilder,
      this.emptyBuilder,
      this.unknownBuilder,
      this.onRefresh})
      : super(key: key);

  final Future? future;
  final Widget child;
  final String? hintText;
  final IdleWidgetBuilder? idleBuilder;
  final WaitingWidgetBuilder? waitingBuilder;
  final EmptyWidgetBuilder? emptyBuilder;
  final UnknownWidgetBuilder? unknownBuilder;
  final VoidCallback? onRefresh;

  @override
  State<FutureStateFlash> createState() => _FutureStateFlashState();
}

class _FutureStateFlashState extends State<FutureStateFlash> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            NetworkDataState state = NetworkDataState.empty;
            if (snapshot.hasData) {
              state = NetworkDataState.idle;
            } else if (snapshot.hasError) {
              state = NetworkDataState.unknown;
            }
            return NetworkStateFlash(
              child: widget.child,
              hintText: widget.hintText,
              state: state,
              onRefresh: widget.onRefresh,
              idleBuilder: widget.idleBuilder,
              emptyBuilder: widget.emptyBuilder,
              unknownBuilder: widget.unknownBuilder,
              waitingBuilder: widget.waitingBuilder,
            );
          }
          return NetworkStateFlash(
            child: widget.child,
            hintText: widget.hintText,
            state: NetworkDataState.waiting,
            onRefresh: widget.onRefresh,
            idleBuilder: widget.idleBuilder,
            emptyBuilder: widget.emptyBuilder,
            unknownBuilder: widget.unknownBuilder,
            waitingBuilder: widget.waitingBuilder,
          );
        });
  }
}
