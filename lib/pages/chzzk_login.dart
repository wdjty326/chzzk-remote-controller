import 'package:chzzk_remote_controller/widgets/window_titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_windows/webview_windows.dart';

class ChzzkLogin extends StatefulWidget {
  static final route = '/';
  const ChzzkLogin({super.key});

  @override
  State<ChzzkLogin> createState() => _ChzzkLoginState();
}

class _ChzzkLoginState extends State<ChzzkLogin> {
  final webviewController = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      await webviewController.initialize();

      await webviewController.setBackgroundColor(Colors.transparent);
      await webviewController
          .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await webviewController.loadUrl(
          'https://nid.naver.com/nidlogin.login?url=https://chzzk.naver.com/');

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  Widget compositeView() {
    if (!webviewController.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Webview(
              webviewController,
              permissionRequested: _onPermissionRequested,
            ),
            StreamBuilder<LoadingState>(
                stream: webviewController.loadingState,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data == LoadingState.loading) {
                    return LinearProgressIndicator();
                  } else {
                    return SizedBox();
                  }
                }),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WindowTitlebar(),
      body: Center(
        child: compositeView(),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }
}
