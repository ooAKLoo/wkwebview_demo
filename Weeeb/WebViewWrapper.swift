//
//  WebViewWrapper.swift
//  Weeeb
//
//  Created by 杨东举 on 2025/3/17.
//

//
//  WebViewWrapper.swift
//  Weeeb
//
//  Created for parameter passing example
//

import SwiftUI
import WebKit

// WKWebView的SwiftUI包装器
struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    let parameters: [String: Any]
    @Binding var pageTitle: String
    @Binding var isLoading: Bool
    
    // JavaScript处理器的名称
    private let jsBridgeName = "appInterface"
    
    // 创建WKWebView
    func makeUIView(context: Context) -> WKWebView {
        // 1. 创建WKWebView配置
        let configuration = WKWebViewConfiguration()
        
        // 2. 创建用户内容控制器
        let userContentController = WKUserContentController()
        
        // 3. 注册JavaScript消息处理程序
        userContentController.add(context.coordinator, name: jsBridgeName)
        
        // 4. 注入自定义JavaScript
        let script = """
        // APP->JS 参数接收对象
        window.appParams = {
            isFromApp: true,
            timestamp: \(Date().timeIntervalSince1970),
            params: \(parametersToJSONString(parameters))
        };
        
        // 拦截所有链接点击
        document.addEventListener('click', function(e) {
            var target = e.target;
            while(target) {
                if (target.tagName === 'A' && target.href) {
                    e.preventDefault();
                    // 通知App有链接被点击
                    window.webkit.messageHandlers.\(jsBridgeName).postMessage({
                        'action': 'linkClicked',
                        'url': target.href,
                        'title': target.innerText || target.href
                    });
                    return false;
                }
                target = target.parentElement;
            }
        }, true);
        
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
        
        // 使用APP传递的参数处理网页内容
        document.addEventListener('DOMContentLoaded', function() {
            if (window.appParams && window.appParams.isFromApp) {
                // 显示参数信息
                showParamsInfo(window.appParams.params);
            }
        });
        
        // 显示参数信息函数
        function showParamsInfo(params) {
            // 如果页面是示例页面，显示参数面板
            if (window.location.href.includes('example.com/demo')) {
                // 创建参数展示面板
                var panel = document.createElement('div');
                panel.style.position = 'fixed';
                panel.style.top = '20px';
                panel.style.right = '20px';
                panel.style.width = '300px';
                panel.style.backgroundColor = params.theme === 'dark' ? '#333' : '#f8f9fa';
                panel.style.color = params.theme === 'dark' ? '#fff' : '#333';
                panel.style.padding = '15px';
                panel.style.borderRadius = '10px';
                panel.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)';
                panel.style.zIndex = '1000';
                
                // 标题
                var title = document.createElement('h3');
                title.textContent = '从APP接收的参数';
                title.style.marginTop = '0';
                title.style.borderBottom = '1px solid ' + (params.theme === 'dark' ? '#555' : '#ddd');
                title.style.paddingBottom = '10px';
                panel.appendChild(title);
                
                // 参数列表
                var list = document.createElement('ul');
                list.style.listStyleType = 'none';
                list.style.padding = '0';
                
                Object.keys(params).forEach(function(key) {
                    var item = document.createElement('li');
                    item.style.padding = '8px 0';
                    item.style.borderBottom = '1px solid ' + (params.theme === 'dark' ? '#444' : '#eee');
                    
                    var keySpan = document.createElement('span');
                    keySpan.textContent = key + ': ';
                    keySpan.style.fontWeight = 'bold';
                    
                    var valueSpan = document.createElement('span');
                    valueSpan.textContent = params[key];
                    valueSpan.style.color = params.theme === 'dark' ? '#8cc' : '#07c';
                    
                    item.appendChild(keySpan);
                    item.appendChild(valueSpan);
                    list.appendChild(item);
                });
                
                panel.appendChild(list);
                
                // 用户信息部分
                if (params.userId && params.userName) {
                    var userInfo = document.createElement('div');
                    userInfo.style.marginTop = '15px';
                    userInfo.style.padding = '10px';
                    userInfo.style.backgroundColor = params.theme === 'dark' ? '#444' : '#e9f5ff';
                    userInfo.style.borderRadius = '5px';
                    
                    var greeting = document.createElement('p');
                    greeting.style.margin = '0 0 5px 0';
                    greeting.textContent = '欢迎回来, ' + params.userName;
                    greeting.style.fontWeight = 'bold';
                    
                    var userIdText = document.createElement('p');
                    userIdText.style.margin = '0';
                    userIdText.style.fontSize = '12px';
                    userIdText.textContent = 'ID: ' + params.userId;
                    
                    var levelText = document.createElement('p');
                    levelText.style.margin = '5px 0 0 0';
                    
                    // VIP标识
                    if (params.isVIP) {
                        levelText.innerHTML = '等级: ' + params.userLevel + ' <span style="color: gold; font-weight: bold;">VIP</span>';
                    } else {
                        levelText.textContent = '等级: ' + params.userLevel;
                    }
                    
                    userInfo.appendChild(greeting);
                    userInfo.appendChild(userIdText);
                    userInfo.appendChild(levelText);
                    panel.appendChild(userInfo);
                }
                
                // 添加到文档
                document.body.appendChild(panel);
                
                // 为demo页面添加样式
                applyThemeToPage(params.theme);
            }
        }
        
        // 为示例页面应用主题
        function applyThemeToPage(theme) {
            if (window.location.href.includes('example.com/demo')) {
                if (theme === 'dark') {
                    document.body.style.backgroundColor = '#222';
                    document.body.style.color = '#eee';
                    
                    var h1 = document.createElement('h1');
                    h1.textContent = 'APP参数传递示例页面 (深色模式)';
                    h1.style.textAlign = 'center';
                    
                    var description = document.createElement('p');
                    description.textContent = '这个页面展示了从APP传递到WebView的参数，查看右上角的参数面板了解详情。';
                    description.style.textAlign = 'center';
                    description.style.maxWidth = '600px';
                    description.style.margin = '0 auto';
                    description.style.fontSize = '16px';
                    description.style.lineHeight = '1.5';
                    
                    document.body.insertBefore(description, document.body.firstChild);
                    document.body.insertBefore(h1, document.body.firstChild);
                } else {
                    document.body.style.backgroundColor = '#fff';
                    document.body.style.color = '#333';
                    
                    var h1 = document.createElement('h1');
                    h1.textContent = 'APP参数传递示例页面 (浅色模式)';
                    h1.style.textAlign = 'center';
                    
                    var description = document.createElement('p');
                    description.textContent = '这个页面展示了从APP传递到WebView的参数，查看右上角的参数面板了解详情。';
                    description.style.textAlign = 'center';
                    description.style.maxWidth = '600px';
                    description.style.margin = '0 auto';
                    description.style.fontSize = '16px';
                    description.style.lineHeight = '1.5';
                    
                    document.body.insertBefore(description, document.body.firstChild);
                    document.body.insertBefore(h1, document.body.firstChild);
                }
            }
        }
        
        // 提供JS->APP通信接口
        window.sendToApp = function(action, data) {
            window.webkit.messageHandlers.\(jsBridgeName).postMessage({
                'action': action,
                'data': data
            });
            return true;
        };
        """
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        
        userContentController.addUserScript(userScript)
        
        // 5. 设置配置
        configuration.userContentController = userContentController
        
        // 6. 创建和配置WKWebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // 启用回弹效果
        webView.scrollView.bounces = true
        
        // 允许链接预览
        webView.allowsLinkPreview = true
        
        // 注册刷新通知
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.refreshWebView),
            name: NSNotification.Name("RefreshWebView"),
            object: nil
        )
        
        // 加载URL
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    // 更新UIView
    func updateUIView(_ webView: WKWebView, context: Context) {
        // 可以在这里响应SwiftUI状态变化
    }
    
    // 创建协调器
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 将参数转换为JSON字符串
    private func parametersToJSONString(_ params: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return "{}"
    }
    
    // 协调器类，处理WKWebView的代理方法和JavaScript消息
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebViewWrapper
        weak var webView: WKWebView?
        
        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }
        
        // 处理从JavaScript接收的消息
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard let dict = message.body as? [String: Any],
                  let action = dict["action"] as? String else {
                return
            }
            
            print("从JS收到消息: \(action)")
            
            if action == "linkClicked", let urlString = dict["url"] as? String {
                // 在这里处理链接点击
                print("链接被点击: \(urlString)")
                
                // 可以选择在App内加载新链接或执行其他操作
                if let url = URL(string: urlString), let webView = message.webView {
                    webView.load(URLRequest(url: url))
                    
                    // 显示消息通知用户
                    webView.evaluateJavaScript("showMessage('在App内打开链接')", completionHandler: nil)
                }
            } else if action == "requestUserInfo" {
                // 示例：JS向APP请求更多用户信息
                // 在实际应用中，这里可能从用户数据库或偏好设置中获取信息
                if let webView = message.webView {
                    let moreUserInfo = [
                        "fullName": "张三",
                        "email": "user@example.com",
                        "registrationDate": "2024-12-01",
                        "points": 2500
                    ] as [String : Any]
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: moreUserInfo, options: []),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        // 发送数据回JS
                        let js = "receiveUserInfoFromApp(\(jsonString))"
                        webView.evaluateJavaScript(js, completionHandler: { result, error in
                            if let error = error {
                                print("发送用户信息到JS出错: \(error)")
                            }
                        })
                    }
                }
            }
        }
        
        // 页面开始加载
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.webView = webView
            parent.isLoading = true
        }
        
        // 页面加载完成
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            // 获取页面标题
            webView.evaluateJavaScript("document.title") { (result, error) in
                if let title = result as? String {
                    self.parent.pageTitle = title
                }
            }
            
            // 如果是示例页面，主动通知JS我们有额外数据
            if webView.url?.absoluteString.contains("example.com/demo") == true {
                // 示例：在页面加载完成后向JS发送额外数据
                let extraData = [
                    "appVersion": "2.0.1",
                    "deviceType": "iOS",
                    "notification": "您有3条未读消息"
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: extraData, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    // 这里假设页面上有一个接收额外数据的JS函数
                    let js = """
                    if (typeof receiveExtraData === 'function') {
                        receiveExtraData(\(jsonString));
                        showMessage('收到来自APP的额外数据');
                    }
                    """
                    webView.evaluateJavaScript(js, completionHandler: nil)
                }
            }
        }
        
        // 处理加载错误
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        // 决定是否允许导航
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // 处理特殊URL方案，如tel:, mailto:等
            if let url = navigationAction.request.url,
               let scheme = url.scheme?.lowercased(),
               scheme != "http" && scheme != "https" {
                
                // 可以在这里使用UIApplication.shared.open打开外部应用
                // 在实际应用中，需要添加适当的处理
                print("需要外部处理的URL: \(url)")
                
                // 拒绝WebView导航
                decisionHandler(.cancel)
                return
            }
            
            // 允许其他所有HTTP/HTTPS导航
            decisionHandler(.allow)
        }
        
        // 刷新网页视图
        @objc func refreshWebView() {
            webView?.reload()
        }
    }
}
