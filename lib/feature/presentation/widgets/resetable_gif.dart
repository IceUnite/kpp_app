import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResettableGif extends StatefulWidget {
  final String assetPath;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const ResettableGif({
    Key? key,
    required this.assetPath,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  @override
  State<ResettableGif> createState() => _ResettableGifState();
}

class _ResettableGifState extends State<ResettableGif> {
  late Future<Uint8List> _gifData;

  @override
  void initState() {
    super.initState();
    _loadGif();
  }

  void _loadGif() {
    _gifData = rootBundle.load(widget.assetPath).then((data) => data.buffer.asUint8List());
  }

  @override
  void didUpdateWidget(covariant ResettableGif oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _loadGif();
    } else {
      _loadGif(); // Обновляем в любом случае
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _gifData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
            gaplessPlayback: false,
          );
        } else {
          return SizedBox(
            height: widget.height,
            width: widget.width,
          );
        }
      },
    );
  }
}
