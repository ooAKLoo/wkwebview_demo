import UIKit
import WebKit
import SnapKit
//import WKWebViewJavascriptBridge

// 主界面控制器
class ViewController: UIViewController {
    
    private lazy var openWebViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("打开H5页面", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openWebViewTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(openWebViewButton)
        
        openWebViewButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
//    @objc private func openWebViewTapped() {
//        let webViewController = WebViewController(url: URL(string: "https://example.com/index.html")!)
//        let navController = UINavigationController(rootViewController: webViewController)
//        navController.modalPresentationStyle = .fullScreen
//        present(navController, animated: true, completion: nil)
//    }
    
    @objc private func openWebViewTapped() {
        // 使用本地HTML文件而不是在线URL
        if let htmlPath = Bundle.main.path(forResource: "index4", ofType: "html") {
            let htmlUrl = URL(fileURLWithPath: htmlPath)
            let webViewController = WebViewController(url: htmlUrl)
            let navController = UINavigationController(rootViewController: webViewController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        } else {
            print("本地HTML文件未找到")
        }
    }
}

// WebView控制器
import UIKit
import WebKit
import SnapKit
//import WKWebViewJavascriptBridge

// WebView控制器
class WebViewController: UIViewController {
    
    private var bridge: WKWebViewJavascriptBridge!
    private var url: URL
    private var isRootPage = true
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()
    
    // 返回按钮
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        return button
    }()
    
    // 关闭按钮
    private lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        return button
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBridge()
        loadURL()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 初始状态下只设置返回按钮
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupBridge() {
        bridge = WKWebViewJavascriptBridge(for: webView)
        
        // 注册原生方法供JS调用
        bridge.registerHandler("updateNavigation") { [weak self] data, callback in
            guard let self = self else { return }
            if let dict = data as? [String: Any],
               let isRoot = dict["isRootPage"] as? Bool {
                self.updateNavigationBar(isRootPage: isRoot)
            }
            callback?(nil)
        }
        
        bridge.registerHandler("closeWebView") { [weak self] _, callback in
            self?.dismiss(animated: true, completion: nil)
            callback?(nil)
        }
    }
    
    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func updateNavigationBar(isRootPage: Bool) {
        self.isRootPage = isRootPage
        
        if isRootPage {
            // 一级页面只显示返回按钮
            navigationItem.leftBarButtonItems = [backButton]
            // 确保右侧没有按钮
            navigationItem.rightBarButtonItem = nil
        } else {
            // 二级页面在返回按钮旁边显示关闭按钮
            navigationItem.leftBarButtonItems = [backButton, closeButton]
        }
    }
    
    @objc private func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// 扩展WebViewController以实现WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 页面加载完成后检查是否为根页面
        webView.evaluateJavaScript("window.location.href") { [weak self] (result, error) in
            if let urlString = result as? String,
               let pageURL = URL(string: urlString),
               let self = self {
                // 根据URL判断是否为根页面
                let isRoot = pageURL.path == "/" || pageURL.path == "/index4.html"
                self.updateNavigationBar(isRootPage: isRoot)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 处理导航操作，这里可以拦截链接或执行其他导航逻辑
        decisionHandler(.allow)
    }
}
