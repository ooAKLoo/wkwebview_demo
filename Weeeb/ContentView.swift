////
////  ContentView.swift
////  Weeeb
////
////  Created by 杨东举 on 2025/3/12.
////  Updated with parameter passing functionality
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var showWebView = false
//    @State private var urlToLoad: URL? = URL(string: "https://www.apple.com")
//    @State private var paramsToPass: [String: Any] = [:]
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
//                    paramsToPass = [:]
//                    showWebView = true
//                }
//                
//                LinkButton(title: "访问Swift官网", url: "https://swift.org") {
//                    urlToLoad = URL(string: "https://swift.org")
//                    paramsToPass = [:]
//                    showWebView = true
//                }
//                
//                LinkButton(title: "查看SwiftUI文档", url: "https://developer.apple.com/documentation/swiftui") {
//                    urlToLoad = URL(string: "https://developer.apple.com/documentation/swiftui")
//                    paramsToPass = [:]
//                    showWebView = true
//                }
//                
//                // 新增: 带参数的按钮
//                ParameterLinkButton(title: "传参数示例", description: "向JS传递用户信息") {
//                    urlToLoad = URL(string: "https://example.com/demo")
//                    // 传递模拟用户信息参数
//                    paramsToPass = [
//                        "userId": "12345",
//                        "userName": "测试用户",
//                        "userLevel": 5,
//                        "isVIP": true,
//                        "theme": "dark"
//                    ]
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
//                    InAppWebView(url: url, parameters: paramsToPass, showWebView: $showWebView)
//                }
//            }
//            .navigationBarTitle("首页", displayMode: .inline)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
