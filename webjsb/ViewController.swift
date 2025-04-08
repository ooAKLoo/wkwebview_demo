////
////  ViewController.swift
////  webjsb
////
////  Created by 杨东举 on 2025/4/3.
////
//
//import UIKit
//import WebKit
//
//class ViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
//
//    private var webView: WKWebView!
//    private let localServerUrl = "http://192.168.1.18:8080" // 本地服务器地址
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
//        loadLocalWebPage()
//    }
//    
//    // 配置WebView
//    private func setupWebView() {
//        // 创建WKWebView配置
//        let configuration = WKWebViewConfiguration()
//        let userContentController = WKUserContentController()
//        
//        // 注册JS消息处理器
//        userContentController.add(self, name: "iosHandler")
//        configuration.userContentController = userContentController
//        
//        // 创建WebView
//        webView = WKWebView(frame: view.bounds, configuration: configuration)
//        webView.navigationDelegate = self
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(webView)
//    }
//    
//    // 加载本地网页
//    private func loadLocalWebPage() {
//        // 方法1：直接从Bundle加载HTML文件
//        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
//            let url = URL(fileURLWithPath: htmlPath)
//            let request = URLRequest(url: url)
//            webView.load(request)
//            print("从Bundle加载HTML文件")
//        }
//        // 方法2：从本地服务器加载
//        else {
//            if let url = URL(string: localServerUrl) {
//                let request = URLRequest(url: url)
//                webView.load(request)
//                print("从本地服务器加载HTML")
//            }
//        }
//    }
//    
//    // 处理来自JS的消息
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print("收到JS消息: \(message.body)")
//        
//        // 确保消息来自我们注册的处理器
//        if message.name == "iosHandler", let messageDictionary = message.body as? [String: Any] {
//            guard let action = messageDictionary["action"] as? String else { return }
//            
//            // 根据不同的action执行不同的操作
//            switch action {
//            case "sendMessage":
//                if let data = messageDictionary["data"] as? String {
//                    print("收到来自H5的消息: \(data)")
//                    // 这里可以处理收到的消息，如更新UI或调用其他原生功能
//                }
//                
//            case "getData":
//                // 准备要发送给H5的数据
//                let dataToSend = "这是来自iOS原生的数据，时间: \(Date())"
//                
//                // 调用JS函数将数据发送回H5
//                let jsCode = "receiveMessageFromIOS('\(dataToSend)')"
//                webView.evaluateJavaScript(jsCode) { (result, error) in
//                    if let error = error {
//                        print("执行JavaScript时出错: \(error)")
//                    }
//                }
//                
//            default:
//                print("未知的操作: \(action)")
//            }
//        }
//    }
//    
//    // MARK: - WKNavigationDelegate
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
//    }
//    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("网页加载失败: \(error)")
//    }
//}
