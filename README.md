# flutter_mobile_bridge

Example library of Flutter mobile app that communicates on a WebView.

Flutter web implementation: https://github.com/tentenponce/flutter_web_bridge

## Quick technical summary

- Receive events from webview by registering Javascript Channels on webview itself.
- Trigger events on webview by dispatching a custom event that should be handled by the website.
