////
////  ViewController.swift
////  webjsb
////
////  Created by 杨东举 on 2025/4/3.
////
//
//import UIKit
//import WebKit
//import JavaScriptCore
//
//// JSBridge核心类 - 负责iOS和JS的通信
//class JSBridge: NSObject {
//    weak var webView: WKWebView?
//    weak var viewController: UIViewController?
//    
//    // 初始化方法
//    init(webView: WKWebView, viewController: UIViewController) {
//        super.init()
//        self.webView = webView
//        self.viewController = viewController
//    }
//    
//    // 注册Bridge到WebView
//    func registerBridge() {
//        // 注入桥接脚本
//        let bridgeScript = """
//        window.iOSBridge = {
//            callNative: function(methodName, params, callback) {
//                // 将回调函数ID存储
//                var callbackId = 'cb_' + Date.now() + '_' + Math.ceil(Math.random() * 10000);
//                window.iOSBridge.callbacks = window.iOSBridge.callbacks || {};
//                window.iOSBridge.callbacks[callbackId] = callback;
//                
//                // 调用原生方法
//                window.webkit.messageHandlers.iOSBridge.postMessage({
//                    methodName: methodName,
//                    params: params,
//                    callbackId: callbackId
//                });
//            },
//            callbacks: {},
//            nativeCallback: function(callbackId, data) {
//                if (window.iOSBridge.callbacks[callbackId]) {
//                    window.iOSBridge.callbacks[callbackId](data);
//                    delete window.iOSBridge.callbacks[callbackId];
//                }
//            }
//        };
//        """
//        
//        let userScript = WKUserScript(source: bridgeScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
//        webView?.configuration.userContentController.addUserScript(userScript)
//        webView?.configuration.userContentController.add(self, name: "iOSBridge")
//    }
//    
//    // 从iOS调用JS方法
//    func callJS(methodName: String, params: [String: Any], callback: ((Any?) -> Void)? = nil) {
//        guard let webView = webView else { return }
//        
//        // 将参数转换为JSON字符串
//        let paramsJSON = try? JSONSerialization.data(withJSONObject: params, options: [])
//        let paramsString = String(data: paramsJSON ?? Data(), encoding: .utf8) ?? "{}"
//        
//        // 构建JavaScript调用
//        let js = "javascript:window.\(methodName)(\(paramsString));"
//        
//        // 执行JavaScript
//        webView.evaluateJavaScript(js) { (result, error) in
//            if let error = error {
//                print("调用JS方法失败: \(error)")
//            }
//            callback?(result)
//        }
//    }
//    
//    // 响应JS调用并返回结果
//    func sendCallbackToJS(callbackId: String, data: Any) {
//        guard let webView = webView else { return }
//        
//        // 将数据转换为JSON字符串
//        let dataJSON = try? JSONSerialization.data(withJSONObject: data, options: [])
//        let dataString = String(data: dataJSON ?? Data(), encoding: .utf8) ?? "{}"
//        
//        // 构建回调JavaScript
//        let js = "window.iOSBridge.nativeCallback('\(callbackId)', \(dataString));"
//        
//        // 执行JavaScript回调
//        webView.evaluateJavaScript(js) { (_, error) in
//            if let error = error {
//                print("JS回调执行失败: \(error)")
//            }
//        }
//    }
//}
//
//// 实现WKScriptMessageHandler协议的扩展
//extension JSBridge: WKScriptMessageHandler {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        guard let body = message.body as? [String: Any],
//              let methodName = body["methodName"] as? String else {
//            return
//        }
//        
//        let params = body["params"] as? [String: Any] ?? [:]
//        let callbackId = body["callbackId"] as? String
//        
//        // 处理来自JS的方法调用
//        handleJSMethod(methodName: methodName, params: params, callbackId: callbackId)
//    }
//    
//    // 处理JS调用的方法
//    private func handleJSMethod(methodName: String, params: [String: Any], callbackId: String?) {
//        print("收到JS方法调用: \(methodName), 参数: \(params)")
//        
//        switch methodName {
//        case "getUserInfo":
//            // 模拟获取用户信息
//            let userInfo: [String: Any] = [
//                "id": 123456,
//                "name": "测试用户",
//                "avatar": "https://example.com/avatar.jpg",
//                "timestamp": Date().timeIntervalSince1970
//            ]
//            
//            // 发送结果回JS
//            if let callbackId = callbackId {
//                sendCallbackToJS(callbackId: callbackId, data: userInfo)
//            }
//            
//        case "showAlert":
//            // 显示一个原生提示框
//            if let message = params["message"] as? String {
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "来自JS的消息", message: message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//                        // 响应确定按钮点击事件
//                        if let callbackId = callbackId {
//                            self.sendCallbackToJS(callbackId: callbackId, data: ["clicked": true])
//                        }
//                    }))
//                    self.viewController?.present(alert, animated: true)
//                }
//            }
//            
//        case "getLocation":
//            // 模拟获取位置信息
//            let location: [String: Any] = [
//                "latitude": 31.230416,
//                "longitude": 121.473701,
//                "address": "上海市"
//            ]
//            
//            // 发送结果回JS
//            if let callbackId = callbackId {
//                sendCallbackToJS(callbackId: callbackId, data: location)
//            }
//            
//        default:
//            print("未知方法: \(methodName)")
//            // 对于未知方法，返回错误
//            if let callbackId = callbackId {
//                sendCallbackToJS(callbackId: callbackId, data: ["error": "未知方法"])
//            }
//        }
//    }
//}
//
//// 主视图控制器
//class ViewController: UIViewController, WKNavigationDelegate {
//    private var webView: WKWebView!
//    private var jsBridge: JSBridge!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupWebView()
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
//        webView.navigationDelegate = self
//        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(webView)
//        
//        // 创建并注册JSBridge
//        jsBridge = JSBridge(webView: webView, viewController: self)
//        jsBridge.registerBridge()
//    }
//    
//    private func loadLocalHTML() {
//        // 从Bundle加载HTML文件
//        if let htmlPath = Bundle.main.path(forResource: "index2", ofType: "html") {
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
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
//        
//        // 示例：页面加载完成后，调用JS方法
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.jsBridge.callJS(methodName: "updateUIFromNative", params: [
//                "message": "网页已成功加载，来自iOS的问候！",
//                "timestamp": Date().timeIntervalSince1970
//            ])
//        }
//    }
//    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("网页加载失败: \(error)")
//    }
//}
