//
//  MainViewController.swift
//  webjsb
//
//  Created by dongju.yang on 2025/4/28.
//


import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 创建打开WebView的按钮
        let openButton = UIButton(type: .system)
        openButton.setTitle("打开上传页面", for: .normal)
        openButton.backgroundColor = .systemBlue
        openButton.setTitleColor(.white, for: .normal)
        openButton.layer.cornerRadius = 8
        openButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        openButton.center = view.center
        openButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        
        view.addSubview(openButton)
    }
    
    @objc private func openWebView() {
        // 创建并打开WebView控制器
        let webViewController = WebViewController()
        present(webViewController, animated: true)
    }
}
