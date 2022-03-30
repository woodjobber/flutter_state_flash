import 'package:flutter/material.dart';

enum NetworkDataState {
  /// 初始状态，空闲
  idle,

  /// 等待数据
  waiting,

  /// 没有数据，服务器与客户端保持正常连接，服务端没有数据返回
  empty,

  /// 未知，有可能是服务器错误或网络错误，客户端不知道远端的数据情况
  unknown,

  /// 有数据
  some,
}

typedef IdleWidgetBuilder    = Widget Function(BuildContext);
typedef WaitingWidgetBuilder = Widget Function(BuildContext);
typedef EmptyWidgetBuilder   = Widget Function(BuildContext);
typedef UnknownWidgetBuilder = Widget Function(BuildContext);

class NetworkStateFlash extends StatefulWidget {
  const NetworkStateFlash(
      {Key? key,
      this.state = NetworkDataState.idle,
      required this.child,
      this.hintText,
      this.refreshTitle,
      this.idleBuilder,
      this.waitingBuilder,
      this.emptyBuilder,
      this.unknownBuilder,
      this.onRefresh})
      : super(key: key);

  /// 数据状态
  final NetworkDataState state;
  
  final Widget child;

  /// 提示文案
  final String? hintText;

  /// 刷新按钮标题
  final String? refreshTitle;

  /// 初始数据状态组件
  final IdleWidgetBuilder? idleBuilder;

  /// 等待数据状态组件
  final WaitingWidgetBuilder? waitingBuilder;

  /// 空数据状态组件
  final EmptyWidgetBuilder? emptyBuilder;

  /// 未知数据状态组件
  final UnknownWidgetBuilder? unknownBuilder;

  /// 刷新按钮事件回调
  final VoidCallback? onRefresh;

  @override
  State<StatefulWidget> createState() => _NetworkStateFlashState();
}

class _NetworkStateFlashState extends State<NetworkStateFlash> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      debugPrint(constraints.maxHeight.toString());
      return Container(
        color: Colors.red,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: _buildStateWidget(context),
      );
    });
  }

  Widget _buildStateWidget(BuildContext context) {
    Widget child = Container();
    switch (widget.state) {
      case NetworkDataState.idle:
        if (widget.idleBuilder != null) {
          child = widget.idleBuilder!(context);
        }
        break;
      case NetworkDataState.waiting:
        if (widget.waitingBuilder != null) {
          child = widget.waitingBuilder!(context);
        }
        break;
      case NetworkDataState.empty:
        if (widget.emptyBuilder != null) {
          child = widget.emptyBuilder!(context);
        } else {
          child = _emptyWidget();
        }
        break;
      case NetworkDataState.unknown:
        if (widget.unknownBuilder != null) {
          child = widget.unknownBuilder!(context);
        } else {
          child = _emptyWidget();
        }
        break;
      case NetworkDataState.some:
        child = widget.child;
        break;
    }
    return child;
  }

  Widget _emptyWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.hintText ?? '暂无数据',
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          widget.onRefresh == null
              ? Container()
              : ElevatedButton(
                  onPressed: widget.onRefresh,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue)),
                  child: Text(
                    widget.refreshTitle ?? '点击刷新',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )),
        ],
      ),
    );
  }
}
