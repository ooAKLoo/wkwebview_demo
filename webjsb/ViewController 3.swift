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
//// 主视图控制器
//class ViewController: UIViewController, WKNavigationDelegate {
//    private var webView: WKWebView!
//    private var bridge: WKWebViewJavascriptBridge!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
//        setupBridge()
//        loadLocalHTML()
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
//        view.addSubview(webView)
//    }
//    
//    private func setupBridge() {
//        // 初始化WebViewJavascriptBridge
//        bridge = WKWebViewJavascriptBridge(for: webView)
//        
//        // 启用日志（可选，调试用）
//        WKWebViewJavascriptBridge.enableLogging()
//        
//        // 重要：设置桥接的导航代理
//            bridge.setWebViewDelegate(self)
//        
//        // 注册原生方法，供JS调用
//        registerHandlers()
//    }
//    
//    private func registerHandlers() {
//        // 获取用户信息
//        bridge.registerHandler("getUserInfo") { data, callback in
//            print("收到JS方法调用: getUserInfo, 参数: \(String(describing: data))")
//            
//            // 模拟获取用户信息
//            let userInfo: [String: Any] = [
//                "id": 123456,
//                "name": "测试用户",
//                "avatar": "https://example.com/avatar.jpg",
//                "timestamp": Date().timeIntervalSince1970
//            ]
//            
//            // 发送结果回JS
//            callback?(userInfo)
//        }
//        
//        // 显示提示框
//        bridge.registerHandler("showAlert") { data, callback in
//            print("收到JS方法调用: showAlert, 参数: \(String(describing: data))")
//            
//            guard let params = data as? [String: Any],
//                  let message = params["message"] as? String else {
//                callback?(["error": "参数错误"])
//                return
//            }
//            
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "来自JS的消息", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//                    // 响应确定按钮点击事件
//                    callback?(["clicked": true])
//                }))
//                self.present(alert, animated: true)
//            }
//        }
//        
//        // 获取位置信息
//        bridge.registerHandler("getLocation") { data, callback in
//            print("收到JS方法调用: getLocation, 参数: \(String(describing: data))")
//            
//            // 模拟获取位置信息
//            let location: [String: Any] = [
//                "latitude": 31.230416,
//                "longitude": 121.473701,
//                "address": "上海市"
//            ]
//            
//            // 发送结果回JS
//            callback?(location)
//        }
//    }
//    
//    private func loadLocalHTML() {
//        // 从Bundle加载HTML文件
//        if let htmlPath = Bundle.main.path(forResource: "index3", ofType: "html") {
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
//        
//        // 直接调用，不使用延迟
//        print("准备调用JS方法: updateUIFromNative")
//        bridge.callHandler("updateUIFromNative", data: [
//            "message": "网页已成功加载，来自iOS的问候！",
//            "timestamp": Date().timeIntervalSince1970
//        ]) { (response) in
//            print("JS响应: \(String(describing: response))")
//        }
//    }
//    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("网页加载失败: \(error)")
//    }
//}
