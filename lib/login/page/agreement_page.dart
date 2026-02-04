import 'package:Kupool/utils/empty_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/color_utils.dart';

/// 应用内的H5页面，用于显示用户协议等
class AgreementPage extends StatefulWidget {
  final String title;
  final String url;

  const AgreementPage({super.key, required this.title, required this.url});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String errorStr = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        if (await _webViewController?.canGoBack() ?? false) {
          await _webViewController?.goBack();
        } else {
          if (navigator.canPop()) {
            navigator.pop(result);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                setState(() {
                  errorStr = error.description;
                  _isLoading = false;
                });
              },
              onReceivedHttpError: (controller, request, errorResponse) {
                 setState(() {
                  _isLoading = false;
                });
              },
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: ColorUtils.mainColor),
              )
            else if(_isLoading == false && isValidString(errorStr))
               Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(errorStr),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          errorStr = "";
                          _isLoading = true;
                        });
                        _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: ColorUtils.mainColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                          child: Text("重新加载",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),)),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
