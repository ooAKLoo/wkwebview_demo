////
////  ViewController 5.swift
////  webjsb
////
////  Created by 杨东举 on 2025/4/9.
////
//
//
//import UIKit
//import WebKit
//import SnapKit
//
//// 主界面控制器
//class ViewController: UIViewController {
//    
//    private lazy var openWebViewButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("打开H5页面", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 8
//        button.addTarget(self, action: #selector(openWebViewTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//    }
//    
//    private func setupUI() {
//        view.addSubview(openWebViewButton)
//        
//        openWebViewButton.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalTo(50)
//        }
//    }
//    
//    @objc private func openWebViewTapped() {
//        // 使用本地HTML文件
//        if let htmlPath = Bundle.main.path(forResource: "index5", ofType: "html") {
//            let htmlUrl = URL(fileURLWithPath: htmlPath)
//            let webViewController = WebViewController(url: htmlUrl)
//            let navController = UINavigationController(rootViewController: webViewController)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true, completion: nil)
//        } else {
//            print("本地HTML文件未找到")
//        }
//    }
//}
//
//// WebView控制器
//class WebViewController: UIViewController {
//    
//    private var bridge: WKWebViewJavascriptBridge!
//    private var url: URL
//    
//    private lazy var webView: WKWebView = {
//        let configuration = WKWebViewConfiguration()
//        let webView = WKWebView(frame: .zero, configuration: configuration)
//        webView.navigationDelegate = self
//        return webView
//    }()
//    
//    // 返回按钮
//    private lazy var backButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(
//            image: UIImage(systemName: "chevron.left"),
//            style: .plain,
//            target: self,
//            action: #selector(backTapped)
//        )
//        return button
//    }()
//    
//    // 关闭按钮
//    private lazy var closeButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(
//            image: UIImage(systemName: "xmark"),
//            style: .plain,
//            target: self,
//            action: #selector(closeTapped)
//        )
//        return button
//    }()
//    
//    init(url: URL) {
//        self.url = url
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupBridge()
//        loadURL()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(webView)
//        
//        webView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        // 初始状态下只设置返回按钮
//        navigationItem.leftBarButtonItem = backButton
//    }
//    
//    private func setupBridge() {
//        bridge = WKWebViewJavascriptBridge(for: webView)
//        
//        // 只保留关闭WebView的JS回调
//        bridge.registerHandler("closeWebView") { [weak self] _, callback in
//            self?.dismiss(animated: true, completion: nil)
//            callback?(nil)
//        }
//    }
//    
//    private func loadURL() {
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//    
//    private func updateNavigationBar() {
//        if webView.canGoBack {
//            // 二级页面在返回按钮旁边显示关闭按钮
//            navigationItem.leftBarButtonItems = [backButton, closeButton]
//        } else {
//            // 一级页面只显示返回按钮
//            navigationItem.leftBarButtonItems = [backButton]
//        }
//    }
//    
//    @objc private func backTapped() {
//        if webView.canGoBack {
//            webView.goBack()
//        } else {
//            dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    @objc private func closeTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//}
//
//// 扩展WebViewController以实现WKNavigationDelegate
//extension WebViewController: WKNavigationDelegate {
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        // 使用canGoBack判断是否为根页面
//        print("Navigation completed. canGoBack = \(webView.canGoBack)")
//        updateNavigationBar()
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        decisionHandler(.allow)
//    }
//}
