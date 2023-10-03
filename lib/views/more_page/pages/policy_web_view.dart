import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PolicyWebView extends StatefulWidget {
  const PolicyWebView({
    Key? key,
  }) : super(key: key);

  @override
  State<PolicyWebView> createState() => _PolicyWebViewState();
}

class _PolicyWebViewState extends State<PolicyWebView> {
  // Creating instance of InAppWebViewController
  late InAppWebViewController controller;

  // For showing loading indicator when page is loading
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Our policy")),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://mood-tracker-policy.sulabhstha.com.np/")),
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $message'),
                ),
              );
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator widget
            ),
          ),
        ],
      ),
    );
  }
}
