import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../../../core/utils/logging/logger.dart';

/// Plays a local voice recording through WebView HTML5 audio.
/// Used because `audioplayers` is not in the currently running native build
/// until a full app restart.
class LocalVoicePlayer extends StatefulWidget {
  final String filePath;
  final bool isPlaying;
  final VoidCallback onCompleted;
  final VoidCallback? onError;

  const LocalVoicePlayer({
    super.key,
    required this.filePath,
    required this.isPlaying,
    required this.onCompleted,
    this.onError,
  });

  @override
  State<LocalVoicePlayer> createState() => _LocalVoicePlayerState();
}

class _LocalVoicePlayerState extends State<LocalVoicePlayer> {
  WebViewController? _controller;
  bool _ready = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    final controller = WebViewController();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setBackgroundColor(Colors.transparent);
    await controller.addJavaScriptChannel(
      'VoicePlayback',
      onMessageReceived: (message) {
        switch (message.message) {
          case 'ended':
            widget.onCompleted();
            break;
          case 'error':
            AppLoggerHelper.error('Local voice playback failed in WebView.');
            widget.onError?.call();
            EasyLoading.showError('Could not play your recording.');
            widget.onCompleted();
            break;
        }
      },
    );

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      await platform.setMediaPlaybackRequiresUserGesture(false);
    }

    if (!mounted) return;
    setState(() {
      _controller = controller;
      _ready = true;
    });

    if (widget.isPlaying) {
      await _play();
    }
  }

  @override
  void didUpdateWidget(covariant LocalVoicePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying == oldWidget.isPlaying) return;
    if (widget.isPlaying) {
      _play();
    } else {
      _pause();
    }
  }

  Future<void> _play() async {
    final controller = _controller;
    if (controller == null) return;

    final file = File(widget.filePath);
    if (!file.existsSync()) {
      EasyLoading.showInfo('No recording found.');
      widget.onCompleted();
      return;
    }

    try {
      if (!_loaded) {
        final bytes = await file.readAsBytes();
        final html = _htmlFor(bytes);
        await controller.loadHtmlString(html);
        _loaded = true;
      } else {
        await controller.runJavaScript(
          'var a=document.getElementById("player"); if(a){a.currentTime=0; a.play();}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error starting local voice playback: $e', e);
      widget.onError?.call();
      EasyLoading.showError('Could not play your recording.');
      widget.onCompleted();
    }
  }

  Future<void> _pause() async {
    try {
      await _controller?.runJavaScript(
        'var a=document.getElementById("player"); if(a){a.pause();}',
      );
    } catch (_) {}
  }

  String _htmlFor(List<int> bytes) {
    final b64 = base64Encode(bytes);
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <audio id="player" autoplay playsinline>
      <source src="data:audio/mp4;base64,$b64" type="audio/mp4">
    </audio>
    <script>
      const player = document.getElementById('player');
      player.onended = () => VoicePlayback.postMessage('ended');
      player.onerror = () => VoicePlayback.postMessage('error');
      player.play().catch(() => VoicePlayback.postMessage('error'));
    </script>
  </body>
</html>
''';
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: 1,
      height: 1,
      child: WebViewWidget(controller: _controller!),
    );
  }
}
