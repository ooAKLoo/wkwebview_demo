//
//  WebViewController 3.swift
//  webjsb
//
//  Created by dongju.yang on 2025/4/28.
//


import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var bridge: WKWebViewJavascriptBridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupBridge()
        loadHTML()
    }
    
    deinit {
        print("WebViewController - 析构")
        // 确保在控制器销毁时取消上传任务
        UploadService.shared.cancelUpload()
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
        
        // 设置桥接的导航代理
        bridge.setWebViewDelegate(self)
        
        // 注册上传进度处理方法
        registerHandlers()
    }
    
    private func registerHandlers() {
        // 开始上传
        bridge.registerHandler("startUpload") { [weak self] data, callback in
            guard let self = self else { return }
            
            print("WebView - 收到开始上传请求")
            
            // 使用UploadService开始上传
            UploadService.shared.startUpload(
                progressCallback: { progress in
                    // 发送进度更新到网页
                    self.bridge.callHandler("updateProgress", data: [
                        "progress": progress
                    ])
                },
                completionCallback: { success, message in
                    // 通知网页上传完成
                    self.bridge.callHandler("uploadComplete", data: [
                        "success": success,
                        "message": message
                    ])
                }
            )
            
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
            print("WebView - 从Bundle加载HTML文件")
        } else {
            print("WebView - HTML文件不存在")
        }
    }
    
    // 添加关闭按钮
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.backgroundColor = .systemRed
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.cornerRadius = 5
        closeButton.frame = CGRect(x: view.bounds.width - 80, y: 30, width: 60, height: 30)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        view.addSubview(closeButton)
    }
    
    @objc private func closeView() {
        dismiss(animated: true)
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView - 网页加载完成")
    }
}
