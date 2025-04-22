import UIKit
import WebKit

class ProgressViewController: UIViewController {
    
    private var webView: WKWebView!
    private var bridge: WKWebViewJavascriptBridge!
    private var progressTimer: Timer?
    private var currentProgress: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupBridge()
        loadLocalHTML()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }
    
    private func setupBridge() {
        // 初始化 WKWebViewJavascriptBridge
        bridge = WKWebViewJavascriptBridge(for: webView)
        
        bridge.setWebViewDelegate(self)
        
        registerHandlers()
    }
    
    private func registerHandlers() {
        // 注册一个原生方法供 JS 调用，用于获取当前进度
        bridge.registerHandler("getProgress") { [weak self] (data: Any?, responseCallback: ((Any?) -> Void)?) in
            guard let self = self else { return }
            // 返回当前进度值给 JS
            responseCallback?(["progress": self.currentProgress])
        }
        
        // 注册一个原生方法供 JS 调用，用于开始/重置进度模拟
        bridge.registerHandler("startProgress") { [weak self] (data: Any?, responseCallback: ((Any?) -> Void)?) in
            guard let self = self else { return }
            self.startProgressSimulation()
            responseCallback?(["status": "started"])
        }
        
        // 注册一个原生方法供 JS 调用，用于停止进度模拟
        bridge.registerHandler("stopProgress") { [weak self] (data: Any?, responseCallback: ((Any?) -> Void)?) in
            guard let self = self else { return }
            self.stopProgressSimulation()
            responseCallback?(["status": "stopped"])
        }
    }
    
    private func loadLocalHTML() {
        // 加载本地 HTML 文件
        if let htmlPath = Bundle.main.path(forResource: "progress 2", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // 模拟进度更新的方法
    private func startProgressSimulation() {
        // 停止之前的计时器（如果有）
        stopProgressSimulation()
        
        // 重置进度
        currentProgress = 0.0
        
        // 创建新的计时器，每0.1秒更新一次进度
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // 增加进度值
            self.currentProgress += 0.01
            
            // 如果进度超过100%，停止计时器
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.stopProgressSimulation()
            }
            
            // 通知 JS 进度已更新
            self.bridge.callHandler("updateProgress", data: ["progress": self.currentProgress], responseCallback: nil)
        }
    }
    
    private func stopProgressSimulation() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    

    
    
    deinit {
        stopProgressSimulation()
    }
}
