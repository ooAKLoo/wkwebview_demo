////
////  ContentView.swift
////  Weeeb
////
////  Created by 杨东举 on 2025/3/12.
////
//
//import SwiftUI
//import WebKit
//
//
//// 主内容视图
//struct ContentView: View {
//    @State private var showWebView = false
//    @State private var urlToLoad: URL? = URL(string: "https://www.apple.com")
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Text("APP内置浏览器Demo")
//                    .font(.largeTitle)
//                    .padding(.top, 50)
//                
//                Text("点击以下链接将在APP内打开网页")
//                    .font(.headline)
//                    .foregroundColor(.secondary)
//                
//                // 示例链接列表
//                LinkButton(title: "访问Apple官网", url: "https://www.apple.com") {
//                    urlToLoad = URL(string: "https://www.apple.com")
//                    showWebView = true
//                }
//                
//                LinkButton(title: "访问Swift官网", url: "https://swift.org") {
//                    urlToLoad = URL(string: "https://swift.org")
//                    showWebView = true
//                }
//                
//                LinkButton(title: "查看SwiftUI文档", url: "https://developer.apple.com/documentation/swiftui") {
//                    urlToLoad = URL(string: "https://developer.apple.com/documentation/swiftui")
//                    showWebView = true
//                }
//                
//                Spacer()
//                
//                Text("用户无需离开APP即可浏览网页内容")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 20)
//            }
//            .padding()
//            .sheet(isPresented: $showWebView) {
//                // 当showWebView为true时，显示WebView sheet
//                if let url = urlToLoad {
//                    InAppWebView(url: url, showWebView: $showWebView)
//                }
//            }
//            .navigationBarTitle("首页", displayMode: .inline)
//        }
//    }
//}
//
//// 自定义链接按钮
//struct LinkButton: View {
//    let title: String
//    let url: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Text(title)
//                    .fontWeight(.medium)
//                
//                Spacer()
//                
//                Text(url)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                
//                Image(systemName: "arrow.up.right.square")
//                    .foregroundColor(.blue)
//            }
//            .padding()
//            .background(Color(.systemGray6))
//            .cornerRadius(10)
//            .padding(.horizontal)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//// 内置网页视图
//struct InAppWebView: View {
//    let url: URL
//    @Binding var showWebView: Bool
//    @State private var isLoading = true
//    @State private var pageTitle = ""
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // WebView
//                WebViewWrapper(url: url, pageTitle: $pageTitle, isLoading: $isLoading)
//                
//                // 加载指示器
//                if isLoading {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//                }
//            }
//            .navigationBarTitle(pageTitle, displayMode: .inline)
//            .navigationBarItems(
//                leading: Button(action: {
//                    showWebView = false
//                }) {
//                    Text("关闭")
//                },
//                trailing: Button(action: {
//                    // 分享按钮实现
//                    // 在实际应用中，可以使用UIActivityViewController来分享URL
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                }
//            )
//        }
//    }
//}
//
//// WKWebView的SwiftUI包装器
//struct WebViewWrapper: UIViewRepresentable {
//    let url: URL
//    @Binding var pageTitle: String
//    @Binding var isLoading: Bool
//    
//    // JavaScript处理器的名称
//    private let jsBridgeName = "appInterface"
//    
//    // 创建WKWebView
//    func makeUIView(context: Context) -> WKWebView {
//        // 1. 创建WKWebView配置
//        let configuration = WKWebViewConfiguration()
//        
//        // 2. 创建用户内容控制器
//        let userContentController = WKUserContentController()
//        
//        // 3. 注册JavaScript消息处理程序
//        userContentController.add(context.coordinator, name: jsBridgeName)
//        
//        // 4. 注入自定义JavaScript
//        let script = """
//        // 拦截所有链接点击
//        document.addEventListener('click', function(e) {
//            var target = e.target;
//            while(target) {
//                if (target.tagName === 'A' && target.href) {
//                    e.preventDefault();
//                    // 通知App有链接被点击
//                    window.webkit.messageHandlers.\(jsBridgeName).postMessage({
//                        'action': 'linkClicked',
//                        'url': target.href,
//                        'title': target.innerText || target.href
//                    });
//                    return false;
//                }
//                target = target.parentElement;
//            }
//        }, true);
//        
//        // 提供App调用的JavaScript函数
//        function showMessage(message) {
//            // 创建简单的toast消息
//            var toast = document.createElement('div');
//            toast.textContent = message;
//            toast.style.position = 'fixed';
//            toast.style.bottom = '50px';
//            toast.style.left = '50%';
//            toast.style.transform = 'translateX(-50%)';
//            toast.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
//            toast.style.color = 'white';
//            toast.style.padding = '10px 20px';
//            toast.style.borderRadius = '20px';
//            toast.style.zIndex = '10000';
//            document.body.appendChild(toast);
//            
//            // 2秒后移除
//            setTimeout(function() {
//                toast.style.transition = 'opacity 0.5s';
//                toast.style.opacity = '0';
//                setTimeout(function() {
//                    document.body.removeChild(toast);
//                }, 500);
//            }, 2000);
//        }
//        """
//        
//        let userScript = WKUserScript(
//            source: script,
//            injectionTime: .atDocumentEnd,
//            forMainFrameOnly: false
//        )
//        
//        userContentController.addUserScript(userScript)
//        
//        // 5. 设置配置
//        configuration.userContentController = userContentController
//        
//        // 6. 创建和配置WKWebView
//        let webView = WKWebView(frame: .zero, configuration: configuration)
//        webView.navigationDelegate = context.coordinator
//        
//        // 启用回弹效果
//        webView.scrollView.bounces = true
//        
//        // 允许链接预览
//        webView.allowsLinkPreview = true
//        
//        // 加载URL
//        webView.load(URLRequest(url: url))
//        
//        return webView
//    }
//    
//    // 更新UIView
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // 可以在这里响应SwiftUI状态变化
//    }
//    
//    // 创建协调器
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // 协调器类，处理WKWebView的代理方法和JavaScript消息
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        var parent: WebViewWrapper
//        
//        init(_ parent: WebViewWrapper) {
//            self.parent = parent
//        }
//        
//        // 处理从JavaScript接收的消息
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            guard let dict = message.body as? [String: Any],
//                  let action = dict["action"] as? String else {
//                return
//            }
//            
//            if action == "linkClicked", let urlString = dict["url"] as? String {
//                // 在这里处理链接点击
//                print("链接被点击: \(urlString)")
//                
//                // 可以选择在App内加载新链接或执行其他操作
//                if let url = URL(string: urlString), let webView = message.webView {
//                    webView.load(URLRequest(url: url))
//                    
//                    // 显示消息通知用户
//                    webView.evaluateJavaScript("showMessage('在App内打开链接')", completionHandler: nil)
//                }
//            }
//        }
//        
//        // 页面开始加载
//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            parent.isLoading = true
//        }
//        
//        // 页面加载完成
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.isLoading = false
//            // 获取页面标题
//            webView.evaluateJavaScript("document.title") { (result, error) in
//                if let title = result as? String {
//                    self.parent.pageTitle = title
//                }
//            }
//        }
//        
//        // 处理加载错误
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
//        }
//        
//        // 决定是否允许导航
//        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            // 处理特殊URL方案，如tel:, mailto:等
//            if let url = navigationAction.request.url,
//               let scheme = url.scheme?.lowercased(),
//               scheme != "http" && scheme != "https" {
//                
//                // 可以在这里使用UIApplication.shared.open打开外部应用
//                // 在实际应用中，需要添加适当的处理
//                print("需要外部处理的URL: \(url)")
//                
//                // 拒绝WebView导航
//                decisionHandler(.cancel)
//                return
//            }
//            
//            // 允许其他所有HTTP/HTTPS导航
//            decisionHandler(.allow)
//        }
//    }
//}
