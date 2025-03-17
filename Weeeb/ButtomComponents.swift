//
//  ButtomComponents.swift
//  Weeeb
//
//  Created by 杨东举 on 2025/3/17.
//

import SwiftUI

// 普通链接按钮
struct LinkButton: View {
    let title: String
    let url: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(url)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Image(systemName: "arrow.up.right.square")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 参数传递按钮组件 - 新增
struct ParameterLinkButton: View {
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .fontWeight(.medium)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 参数传递图标
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "arrow.right.arrow.left")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.05)))
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
