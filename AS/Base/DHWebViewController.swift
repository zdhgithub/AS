//
//  DHWebViewController.swift
//  Prestapronto
//
//  Created by dh on 2023/3/7.
//

import UIKit
import WebKit

class DHWebViewController: DHBaseViewController {
    
    let kWebViewProgressObserverKey = "estimatedProgress"
    let kWebViewTitleObserverKey = "title"

    var url:String?
    var titleStr:String?
    
    lazy var progressView:UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: dhScreenWidth, height: 0))
        progressView.progressTintColor = dhColorMain
        progressView.alpha = 0
        return progressView
    }()
    
    lazy var webView:WKWebView = {
         var config = WKWebViewConfiguration()
        //禁止缩放
        var jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        var userContentController = WKUserContentController();
        var cookieScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
          
        
//        [userContentController addScriptMessageHandler:self name:shareToFacebook];
//        [userContentController addScriptMessageHandler:self name:shareToWhatsapp];
//        [userContentController addScriptMessageHandler:self name:shareToOthers];
//
//        [userContentController addScriptMessageHandler:self name:pop];
//        [userContentController addScriptMessageHandler:self name:copy];
//        [userContentController addScriptMessageHandler:self name:iosGetToken];
//        [userContentController addScriptMessageHandler:self name:goBankCard];
        
        config.userContentController = userContentController
        
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.processPool = WKProcessPool()
        
        var webView = WKWebView(frame: .zero, configuration: config)
//        _webView.scrollView.delegate = self;
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: kWebViewProgressObserverKey, options: [.old, .new], context: nil)
        webView.addObserver(self, forKeyPath: kWebViewTitleObserverKey, options: [.new], context: nil)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleStr ?? ""
        
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(-dhBottomBarHeight)
        }
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(2)
        }
        
        loadUrl()
    }
    

    func loadUrl() {
        let urlStr = SMDomainImageUrl(url ?? "")
        webView.load(URLRequest(url: URL(string: urlStr)!))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if(keyPath == kWebViewProgressObserverKey){
            print("estimatedProgress: %lf", webView.estimatedProgress)
            
            progressView.alpha = 1.0
            
            if(progressView.progress <= Float(webView.estimatedProgress)){
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            }
            
            if(webView.estimatedProgress >= 1.0){
                UIView.animate(withDuration: 0.25) {
                    self.progressView.alpha = 0.0
                } completion: { finished in
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        }else if(keyPath == kWebViewTitleObserverKey){
            if(titleStr == nil){
                let titleNew = change![NSKeyValueChangeKey.newKey]
                self.title = titleNew as? String
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
 

}



extension DHWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension DHWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        completionHandler("")
    }
}
