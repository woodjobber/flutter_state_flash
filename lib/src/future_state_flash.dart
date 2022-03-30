import 'package:flutter/material.dart';

import 'network_state_flash.dart';

class FutureStateFlash extends StatefulWidget {
  /// Creates a widget that builds itself based on the latest snapshot of
  /// interaction with a [Future].
  ///
  /// The [child] must not be null.
  ///
  const FutureStateFlash(
      {Key? key,
      this.future,
      required this.child,
      this.hintText,
      this.refreshTitle,
      this.idleBuilder,
      this.waitingBuilder,
      this.emptyBuilder,
      this.unknownBuilder,
      this.onRefresh})
      : super(key: key);

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null.
  ///
  /// If no future has yet completed, including in the case where [future] is
  /// null, the [NetworkDataState] is [NetworkDataState.empty].
  final Future? future;
  
  final Widget child;

  /// The placeholder text
  final String? hintText;

  /// The refresh button title
  final String? refreshTitle;
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
          var state = NetworkDataState.waiting;
          if (snapshot.connectionState == ConnectionState.none) {
            state = NetworkDataState.idle;
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              state = NetworkDataState.some;
            } else if (snapshot.hasError) {
              state = NetworkDataState.unknown;
            } else {
              state = NetworkDataState.empty;
            }
          }
          return NetworkStateFlash(
            child: widget.child,
            hintText: widget.hintText,
            refreshTitle: widget.refreshTitle,
            state: state,
            onRefresh: widget.onRefresh,
            idleBuilder: widget.idleBuilder,
            emptyBuilder: widget.emptyBuilder,
            unknownBuilder: widget.unknownBuilder,
            waitingBuilder: widget.waitingBuilder,
          );
        });
  }
}
