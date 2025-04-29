////
////  WebViewController 2.swift
////  webjsb
////
////  Created by dongju.yang on 2025/4/28.
////
//
//
//import UIKit
//import WebKit
//import RxSwift
//
//class WebViewController: UIViewController, WKNavigationDelegate {
//    private var webView: WKWebView!
//    private var bridge: WKWebViewJavascriptBridge!
//    private let uploadManager = UploadManager()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
//        setupBridge()
//        loadHTML()
//    }
//    
//    private func setupWebView() {
//        // 配置WKWebView
//        let configuration = WKWebViewConfiguration()
//        configuration.preferences.javaScriptEnabled = true
//        
//        // 创建WebView
//        webView = WKWebView(frame: view.bounds, configuration: configuration)
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//    }
//    
//    private func setupBridge() {
//        // 初始化WebViewJavascriptBridge
//        bridge = WKWebViewJavascriptBridge(for: webView)
//        
//        // 启用日志（调试用）
////        WKWebViewJavascriptBridge.enableLogging()
//        
//        // 设置桥接的导航代理
//        bridge.setWebViewDelegate(self)
//        
//        // 注册上传进度处理方法
//        registerHandlers()
//    }
//    
//    private func registerHandlers() {
//        // 开始上传
//        bridge.registerHandler("startUpload") { [weak self] data, callback in
//            guard let self = self else { return }
//            
//            print("开始上传操作")
//            
//            // 使用UploadManager开始上传
//            self.uploadManager.startUpload(
//                progressCallback: { progress in
//                    // 发送进度更新到网页
//                    self.bridge.callHandler("updateProgress", data: [
//                        "progress": progress
//                    ])
//                },
//                completionCallback: { success, message in
//                    // 通知网页上传完成
//                    self.bridge.callHandler("uploadComplete", data: [
//                        "success": success,
//                        "message": message
//                    ])
//                }
//            )
//            
//            // 返回响应
//            callback?(["status": "started"])
//        }
//    }
//    
//    private func loadHTML() {
//        // 从Bundle加载HTML文件
//        if let htmlPath = Bundle.main.path(forResource: "upload", ofType: "html") {
//            let url = URL(fileURLWithPath: htmlPath)
//            let request = URLRequest(url: url)
//            webView.load(request)
//            print("从Bundle加载HTML文件")
//        } else {
//            print("HTML文件不存在")
//        }
//    }
//    
//    // MARK: - WKNavigationDelegate
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
//    }
//}
