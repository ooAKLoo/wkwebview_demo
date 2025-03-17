//import SwiftUI
//import WebKit
//
//// 主视图，包含三个WebView示例的入口
//struct ContentView: View {
//    @State private var appMessage = "Hello from Swift App"
//    @State private var webViewMessage = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 30) {
//                // 示例1: 简单WebView打开URL
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("1. 打开URL的WebView").font(.headline)
//                    Text("点击按钮在WebView中打开Apple网站").font(.caption)
//                    
//                    NavigationLink(destination: SimpleWebView()) {
//                        Text("打开Apple网站")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                
//                // 示例2A: App向WebView传参（初始化时传递）
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("2A. App向WebView传参（初始化时）").font(.headline)
//                    Text("输入消息，App将参数传递给WebView").font(.caption)
//                    
//                    TextField("输入要传递的消息", text: $appMessage)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    
//                    NavigationLink(destination: AppToWebView(message: appMessage)) {
//                        Text("传递参数并打开WebView")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                
//                // 示例2B: App向WebView传参（JS请求时传递）
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("2B. JS请求App参数").font(.headline)
//                    Text("WebView加载后，JS主动请求App参数").font(.caption)
//                    
//                    TextField("输入要传递的消息", text: $appMessage)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    
//                    NavigationLink(destination: AppToWebViewOnRequest(message: appMessage)) {
//                        Text("WebView JS请求参数")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .background(Color.teal)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//                
//                // 示例3: WebView向App传参
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("3. WebView向App传参").font(.headline)
//                    Text("在WebView中输入消息，发送回App").font(.caption)
//                    
//                    NavigationLink(destination: WebViewToApp { message in
//                        // 收到WebView消息后更新状态
//                        self.webViewMessage = message
//                    }) {
//                        Text("打开可向App发送消息的WebView")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                    
//                    if !webViewMessage.isEmpty {
//                        Text("收到的WebView消息:").font(.subheadline)
//                        Text(webViewMessage)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("WebView 示例")
//        }
//    }
//}
//
//// 示例1: 简单WebView打开URL
//struct SimpleWebView: View {
//    var body: some View {
//        WebViewContainer(url: URL(string: "https://www.apple.com")!)
//            .navigationTitle("打开URL示例")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// 示例2A: App向WebView传参（初始化时传递）
//struct AppToWebView: View {
//    let message: String
//    
//    var body: some View {
//        WebViewWithParameter(message: message)
//            .navigationTitle("App向WebView传参")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// 示例2B: App向WebView传参（JS请求时传递）
//struct AppToWebViewOnRequest: View {
//    let message: String
//    
//    var body: some View {
//        WebViewWithJSRequest(message: message)
//            .navigationTitle("JS请求App参数")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// 示例3: WebView向App传参
//struct WebViewToApp: View {
//    var onMessageReceived: (String) -> Void
//    
//    var body: some View {
//        WebViewWithCallback(onMessageReceived: onMessageReceived)
//            .navigationTitle("WebView向App传参")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// MARK: - WebView 实现
//
//// 示例1: 基本WebView - 打开URL
//struct WebViewContainer: UIViewRepresentable {
//    let url: URL
//    
//    // 创建WKWebView
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//    
//    // 更新WKWebView - 加载URL
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//}
//
//// 示例2A: App向WebView传参（初始化时传递）
//struct WebViewWithParameter: UIViewRepresentable {
//    let message: String
//    
//    func makeUIView(context: Context) -> WKWebView {
//        return WKWebView()
//    }
//    
//    // 更新WebView - 加载包含App参数的HTML
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // 创建包含App参数的HTML
//        let html = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <style>
//                body { font-family: -apple-system; padding: 20px; text-align: center; }
//                .message-box { padding: 20px; background-color: #f0f0f0; border-radius: 10px; margin-top: 20px; }
//            </style>
//        </head>
//        <body>
//            <h2>从App接收到的参数（初始化时传递）</h2>
//            <div class="message-box">
//                \(message)
//            </div>
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(html, baseURL: nil)
//    }
//}
//
//// 示例2B: App向WebView传参（JS请求时传递）
//struct WebViewWithJSRequest: UIViewRepresentable {
//    let message: String
//    
//    // 创建协调器 - 用于处理WebView和App之间的通信
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        // 配置WKWebView允许JavaScript请求App数据
//        let configuration = WKWebViewConfiguration()
//        // 添加消息处理程序，名称为"appRequestHandler"
//        configuration.userContentController.add(context.coordinator, name: "appRequestHandler")
//        
//        return WKWebView(frame: .zero, configuration: configuration)
//    }
//    
//    // 更新WebView - 加载包含JavaScript的HTML
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // 加载包含JavaScript的HTML，但不包含App参数
//        let html = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <style>
//                body { font-family: -apple-system; padding: 20px; text-align: center; }
//                .message-box { padding: 20px; background-color: #f0f0f0; border-radius: 10px; margin-top: 20px; }
//                button { padding: 10px 20px; background-color: #007AFF; color: white; border: none; border-radius: 5px; font-size: 16px; margin-top: 20px; }
//            </style>
//        </head>
//        <body>
//            <h2>JavaScript请求App参数</h2>
//            <p>点击按钮从App请求数据</p>
//            <button onclick="requestDataFromApp()">请求App参数</button>
//            <div id="responseContainer" class="message-box" style="display: none; margin-top: 20px;">
//                <p>从App接收到的参数：</p>
//                <div id="responseData"></div>
//            </div>
//            
//            <script>
//                // 从App请求数据的函数
//                function requestDataFromApp() {
//                    document.getElementById('responseContainer').style.display = 'block';
//                    // 调用App提供的接口请求数据
//                    window.webkit.messageHandlers.appRequestHandler.postMessage('requestData');
//                }
//                
//                // 接收App发送的数据并显示
//                window.receiveDataFromApp = function(data) {
//                    document.getElementById('responseData').textContent = data;
//                }
//            </script>
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(html, baseURL: nil)
//    }
//    
//    // 协调器类 - 处理从WebView接收消息并响应
//    class Coordinator: NSObject, WKScriptMessageHandler {
//        var parent: WebViewWithJSRequest
//        
//        init(_ parent: WebViewWithJSRequest) {
//            self.parent = parent
//        }
//        
//        // 实现WKScriptMessageHandler协议方法 - 接收WebView消息
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            if message.name == "appRequestHandler" {
//                // 收到WebView请求数据的消息
//                if let webView = message.webView {
//                    // 执行JavaScript，调用页面中的函数并传递App参数
//                    let jsCode = "receiveDataFromApp('\(parent.message)')"
//                    webView.evaluateJavaScript(jsCode, completionHandler: nil)
//                }
//            }
//        }
//    }
//}
//
//// 示例3: WebView向App传参
//struct WebViewWithCallback: UIViewRepresentable {
//    var onMessageReceived: (String) -> Void
//    
//    // 创建协调器 - 用于处理WebView和App之间的通信
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // 创建WKWebView并配置消息处理程序
//    func makeUIView(context: Context) -> WKWebView {
//        // 配置WKWebView允许JavaScript向App发送消息
//        let configuration = WKWebViewConfiguration()
//        // 添加消息处理程序，名称为"appInterface"
//        configuration.userContentController.add(context.coordinator, name: "appInterface")
//        
//        return WKWebView(frame: .zero, configuration: configuration)
//    }
//    
//    // 更新WebView - 加载包含JavaScript的HTML
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // 加载包含JavaScript的HTML
//        let html = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <style>
//                body { font-family: -apple-system; padding: 20px; text-align: center; }
//                button { padding: 10px 20px; background-color: #007AFF; color: white; border: none; border-radius: 5px; font-size: 16px; margin-top: 20px; }
//                input { padding: 10px; margin: 20px 0; width: 80%; border: 1px solid #ccc; border-radius: 5px; font-size: 16px; }
//            </style>
//        </head>
//        <body>
//            <h2>向App发送消息</h2>
//            <p>输入消息并点击按钮将数据发送回App</p>
//            <input type="text" id="messageInput" placeholder="输入消息" value="Hello from WebView">
//            <br>
//            <button onclick="sendMessageToApp()">发送消息到App</button>
//            
//            <script>
//                function sendMessageToApp() {
//                    // 获取用户输入的消息
//                    const message = document.getElementById('messageInput').value;
//                    // 使用WebKit消息处理程序发送到App
//                    // 'appInterface'必须与Swift代码中注册的名称一致
//                    window.webkit.messageHandlers.appInterface.postMessage(message);
//                }
//            </script>
//        </body>
//        </html>
//        """
//        
//        webView.loadHTMLString(html, baseURL: nil)
//    }
//    
//    // 协调器类 - 处理从WebView接收消息
//    class Coordinator: NSObject, WKScriptMessageHandler {
//        var parent: WebViewWithCallback
//        
//        init(_ parent: WebViewWithCallback) {
//            self.parent = parent
//        }
//        
//        // 实现WKScriptMessageHandler协议方法 - 接收WebView消息
//        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//            if message.name == "appInterface", let messageString = message.body as? String {
//                // 将消息发送回SwiftUI视图
//                parent.onMessageReceived(messageString)
//            }
//        }
//    }
//}
