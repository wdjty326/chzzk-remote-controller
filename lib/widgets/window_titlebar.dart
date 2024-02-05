import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitlebar extends StatelessWidget {
  const WindowTitlebar([Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      height: 28,
      child: Row(
        children: [
          Expanded(child: GestureDetector(
            onTapDown: (detail) async {
              if (await windowManager.isFullScreen()) {
                /// TODO::눌렀던 위치 비율계산필요
                await windowManager.setFullScreen(false);
                await windowManager.setPosition(detail.localPosition);
              }
              await windowManager.startDragging();
            },
          )),
          IconButton(
              onPressed: () async {
                await windowManager.minimize();
              },
              icon: const Icon(
                Icons.horizontal_rule,
                size: 16,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () async {
                await windowManager.setFullScreen(true);
              },
              icon: const Icon(
                Icons.square_outlined,
                size: 16,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () async {
                await windowManager.close();
              },
              icon: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
