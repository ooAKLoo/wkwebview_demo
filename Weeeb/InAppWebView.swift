//
//  InAppWebView.swift
//  Weeeb
//
//  Created by 杨东举 on 2025/3/17.
//

import SwiftUI
import WebKit

// 内置网页视图
struct InAppWebView: View {
    let url: URL
    let parameters: [String: Any]
    @Binding var showWebView: Bool
    @State private var isLoading = true
    @State private var pageTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // WebView
                WebViewWrapper(url: url, parameters: parameters, pageTitle: $pageTitle, isLoading: $isLoading)
                
                // 加载指示器
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
            }
            .navigationBarTitle(pageTitle, displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    showWebView = false
                }) {
                    Text("关闭")
                },
                trailing: HStack {
                    // 刷新按钮
                    Button(action: {
                        // 刷新网页
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshWebView"), object: nil)
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .padding(.trailing, 8)
                    
                    // 分享按钮
                    Button(action: {
                        // 分享按钮实现
                        // 在实际应用中，可以使用UIActivityViewController来分享URL
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            )
        }
    }
}
