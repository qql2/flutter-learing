import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class WindowsWebView extends StatefulWidget {
  const WindowsWebView({super.key});

  @override
  State<WindowsWebView> createState() => _WindowsWebViewState();
}

class _WindowsWebViewState extends State<WindowsWebView> {
  final _controller = WebviewController();
  bool _isWebViewReady = false;
  String? lastMessage;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    try {
      await _controller.initialize();

      _controller.webMessage.listen((dynamic message) {
        setState(() {
          lastMessage = message;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('收到消息: $message')),
        );
      });

      await _controller.loadUrl('data:text/html;charset=utf-8,' +
          Uri.encodeComponent(_getHtmlContent()));
      setState(() {
        _isWebViewReady = true;
      });
    } catch (e) {
      debugPrint('Error initializing Windows WebView: $e');
    }
  }

  String _getHtmlContent() {
    return '''
      <!DOCTYPE html>
      <html>
        <head><title>WebView Demo</title></head>
        <body>
          <h1>Windows WebView Demo</h1>
          <button onclick="sendMessage()">Send Message</button>
          <div id="result"></div>
          <script>
            function sendMessage() {
              window.chrome.webview.postMessage('Hello from Windows WebView!');
            }

            // 添加异步函数
            async function doAsyncTask() {
              const result = await new Promise(resolve => {
                setTimeout(() => {
                  resolve('异步任务完成！');
                }, 5000);
              });
              document.getElementById('result').textContent = '结果: ' + result;
              return result;
            }
          </script>
        </body>
      </html>
    ''';
  }

  // 直接执行 JavaScript 异步函数
  Future<void> _runJsAsync() async {
    try {
      final result = await _controller.executeScript('doAsyncTask()');
      setState(() {
        lastMessage = '执行结果: $result';
      });
    } catch (e) {
      debugPrint('Error executing JavaScript: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWebViewReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(child: Webview(_controller)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _runJsAsync,
            child: const Text('运行异步任务'),
          ),
        ),
        if (lastMessage != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('最后收到的消息: $lastMessage'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
