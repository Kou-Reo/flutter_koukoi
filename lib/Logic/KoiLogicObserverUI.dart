import 'package:flutter/material.dart';
import 'KoiLogic.dart';
import 'KoiLogicObserver.dart';

class KoiLogicObserverUI<T> extends StatefulWidget {
  const KoiLogicObserverUI({super.key, required this.logic, this.child= null, required this.builder});

  final KoiLogic<T> logic;
  final Widget? child;
  final Widget Function(BuildContext context, T data, Widget? child) builder;

  @override
  State<KoiLogicObserverUI<T>> createState() => _KoiLogicObserverUIState<T>();
}

class _KoiLogicObserverUIState<T> extends State<KoiLogicObserverUI<T>> {

  late KoiLogicObserver<T> myobserver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myobserver = widget.logic.observe(onUpdate: (KoiLogic<T> logic){
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.logic.observerRemove(myobserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.logic.data, widget.child);
  }
}
