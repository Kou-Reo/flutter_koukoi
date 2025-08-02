import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';

import 'KoiLiveResult.dart';

class KoiLiveWg<T> extends StatefulWidget {
  const KoiLiveWg({
    super.key,
    required this.data,
    required this.renderWidget,
    required this.renderOnError,
    required this.renderOnLoad,
  });

  final KoiLogic<KoiLiveResult<T>> data;
  final Widget Function(T) renderWidget;
  final Widget Function(List<Error>) renderOnError;
  final Widget Function() renderOnLoad;

  @override
  State<KoiLiveWg<T>> createState() => _KoiLiveWgState<T>();
}

class _KoiLiveWgState<T> extends State<KoiLiveWg<T>> {
  @override
  void initState() {
    super.initState();
    widget.data.observe(onUpdate: (newData) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.data.status == KoiLiveResultStatus.Loading) {
      return widget.renderOnLoad();
    } else if (widget.data.data.status == KoiLiveResultStatus.Error) {
      return widget.renderOnError(widget.data.data.errors);
    }

    if(widget.data.data.data != null){
      return widget.renderWidget(widget.data.data.data!);
    }

    return widget.renderOnError([
      AssertionError("No data to show")
    ]);
  }
}
