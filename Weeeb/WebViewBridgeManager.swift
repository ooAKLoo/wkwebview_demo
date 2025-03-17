//
//  WebViewBridgeManager.swift
//  Weeeb
//
//  Created by 杨东举 on 2025/3/17.
//

import Foundation
import WebKit

// 管理APP与WebView之间通信的类
class WebViewBridgeManager {
    // 单例模式
    static let shared = WebViewBridgeManager()
    
    // 禁止外部创建实例
    private init() {}
    
    // JavaScript处理器的名称
    let jsBridgeName = "appInterface"
    
    // 将Swift参数转换为JavaScript字符串
    func parametersToJSString(_ parameters: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }
    
    // 生成注入的基础JavaScript代码
    func generateBaseJSBridge() -> String {
        return """
        // APP->JS 参数接收对象
        window.appParams = {
            isFromApp: true,
            timestamp: \(Date().timeIntervalSince1970)
        };
        
        // 提供JS->APP通信接口
        window.sendToApp = function(action, data) {
            window.webkit.messageHandlers.\(jsBridgeName).postMessage({
                'action': action,
                'data': data
            });
            return true;
        };
        """
    }
    
    // 生成带参数的JavaScript注入代码
    func generateJSBridge(withParameters parameters: [String: Any]) -> String {
        return """
        // APP->JS 参数接收对象
        window.appParams = {
            isFromApp: true,
            timestamp: \(Date().timeIntervalSince1970),
            params: \(parametersToJSString(parameters))
        };
        
        // 提供JS->APP通信接口
        window.sendToApp = function(action, data) {
            window.webkit.messageHandlers.\(jsBridgeName).postMessage({
                'action': action,
                'data': data
            });
            return true;
        };
        """
    }
    
    // 生成显示消息的JavaScript函数
    func generateShowMessageJS() -> String {
        return """
        // 提供App调用的JavaScript函数
        function showMessage(message) {
            // 创建简单的toast消息
            var toast = document.createElement('div');
            toast.textContent = message;
            toast.style.position = 'fixed';
            toast.style.bottom = '50px';
            toast.style.left = '50%';
            toast.style.transform = 'translateX(-50%)';
            toast.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
            toast.style.color = 'white';
            toast.style.padding = '10px 20px';
            toast.style.borderRadius = '20px';
            toast.style.zIndex = '10000';
            document.body.appendChild(toast);
            
            // 2秒后移除
            setTimeout(function() {
                toast.style.transition = 'opacity 0.5s';
                toast.style.opacity = '0';
                setTimeout(function() {
                    document.body.removeChild(toast);
                }, 500);
            }, 2000);
        }
        """
    }
    
    // 从WebView获取数据的例子
    func exampleGetDataFromWebView(webView: WKWebView, completion: @escaping ([String: Any]?) -> Void) {
        // 执行JavaScript获取数据
        webView.evaluateJavaScript("JSON.stringify(document.getElementById('data-container')?.dataset || {})") { (result, error) in
            guard error == nil,
                  let jsonString = result as? String,
                  let data = jsonString.data(using: .utf8),
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil)
                return
            }
            
            completion(jsonObject)
        }
    }
    
    // 向WebView发送数据的例子
    func exampleSendDataToWebView(webView: WKWebView, data: [String: Any]) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            // 调用WebView中的JavaScript函数
            webView.evaluateJavaScript("receiveDataFromApp(\(jsonString))") { (_, error) in
                if let error = error {
                    print("发送数据到WebView出错: \(error)")
                }
            }
        }
    }
}
