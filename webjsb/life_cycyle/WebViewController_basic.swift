import UIKit
import WebKit

class WebViewController_basic: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var bridge: WKWebViewJavascriptBridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupBridge()
        loadHTML()
    }
    
    private func setupWebView() {
        // 配置WKWebView
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        
        // 创建WebView
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    private func setupBridge() {
        // 初始化WebViewJavascriptBridge
        bridge = WKWebViewJavascriptBridge(for: webView)
        
        // 启用日志（调试用）
        WKWebViewJavascriptBridge.enableLogging()
        
        // 设置桥接的导航代理
        bridge.setWebViewDelegate(self)
        
        // 注册上传进度处理方法
        registerHandlers()
    }
    
    private func registerHandlers() {
        // 开始上传
        bridge.registerHandler("startUpload") { data, callback in
            print("开始上传操作")
            
            // 模拟上传过程
            var progress: Float = 0.0
            let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                // 更新进度
                progress += 0.1
                
                // 发送进度更新到网页
                self.bridge.callHandler("updateProgress", data: [
                    "progress": progress
                ])
                
                // 上传完成
                if progress >= 1.0 {
                    timer.invalidate()
                    // 通知网页上传完成
                    self.bridge.callHandler("uploadComplete", data: [
                        "success": true,
                        "message": "上传完成！"
                    ])
                }
            }
            
            // 启动定时器
            timer.fire()
            
            // 返回响应
            callback?(["status": "started"])
        }
    }
    
    private func loadHTML() {
        // 从Bundle加载HTML文件
        if let htmlPath = Bundle.main.path(forResource: "upload", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            webView.load(request)
            print("从Bundle加载HTML文件")
        } else {
            print("HTML文件不存在")
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
    }
}
