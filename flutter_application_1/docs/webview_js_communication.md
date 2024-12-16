# Flutter WebView 与 JavaScript 通信指南

本文档记录了在 Flutter WebView 中与 JavaScript 进行通信的两种主要方式。

## 1. 直接执行 JavaScript 代码

### 1.1 异步函数执行

在 Windows WebView 中，可以使用 `executeScript` 方法直接执行 JavaScript 代码并获取返回值： 
```dart
// Flutter 代码
Future<void> runJavaScript() async {
	try {
		final result = await webViewController.executeScript('doAsyncTask()');
		print('JavaScript 返回结果: $result');
	} catch (e) {
		print('执行 JavaScript 出错: $e');
		}
	}
```

```javascript
// JavaScript 代码
async function doAsyncTask() {
	const result = await new Promise(resolve => {
	setTimeout(() => {
		resolve('异步任务完成！');
		}, 2000);
	});
	return result;
}
```

### 1.2 特点
- 可以直接获取 JavaScript 函数的返回值
- 支持 async/await 语法
- 错误处理更直接
- 适合需要立即获取结果的场景

## 2. 消息通信机制

### 2.1 从 JavaScript 发送消息到 Flutter

```dart
// Flutter 代码
webViewController.webMessage.listen((dynamic message) {
  setState(() {
    lastMessage = message;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('收到消息: $message')),
  );
});
```

```javascript
// JavaScript 代码
function sendMessage() {
  window.chrome.webview.postMessage('Hello from JavaScript!');
}
```

### 2.2 从 Flutter 发送消息到 JavaScript

```dart
// Flutter 代码
await webViewController.postWebMessage('message from Flutter');
```

```javascript
// JavaScript 代码
window.chrome.webview.addEventListener('message', event => {
  console.log('收到来自 Flutter 的消息:', event.data);
});
```

### 2.3 特点
- 适合长期通信和事件监听场景
- 支持双向通信
- 可以处理异步事件
- 适合需要持续监听的场景

## 3. 平台差异

### 3.1 Windows (webview_windows)
- 使用 `window.chrome.webview.postMessage` 发送消息
- 使用 `window.chrome.webview.addEventListener` 监听消息

### 3.2 Mobile (webview_flutter)
- 使用 JavaScriptChannel 进行通信
- 需要注册特定的通道名称

## 4. 最佳实践

1. **选择合适的通信方式**
   - 需要立即结果：使用 executeScript
   - 需要持续监听：使用消息通信

2. **错误处理**
   - 始终包含 try-catch 块
   - 记录错误信息便于调试

3. **性能考虑**
   - 避免频繁的跨平台通信
   - 批量处理数据而不是频繁小数据传输

4. **代码组织**
   - 将 JavaScript 代码独立管理
   - 使用统一的消息格式

## 5. 示例代码

完整的通信示例可以参考：
- `lib/webview_js_demo/platform/webview_windows.dart`
- `lib/webview_js_demo/platform/webview_mobile.dart`

## 6. 注意事项

1. 确保 WebView 已正确初始化
2. 处理平台特定的实现差异
3. 注意消息格式的一致性
4. 考虑内存泄漏问题
5. 在组件销毁时清理监听器


这个文档总结了 WebView 与 JavaScript 通信的主要方式、特点和最佳实践，可以作为开发参考指南。需要注意的是，不同平台（Windows/Android/iOS）的实现可能有所不同，使用时需要注意平台特定的 API。