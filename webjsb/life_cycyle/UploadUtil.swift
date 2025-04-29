//
//  UploadUtil.swift
//  webjsb
//
//  Created by dongju.yang on 2025/4/28.
//


import Foundation
import RxSwift

class UploadUtil {
    
    // MARK: - 初始化与析构
    init() {
        print("UploadUtil - 初始化")
    }
    
    deinit {
        print("UploadUtil - 析构")
        // 清理资源，如果有的话
    }
    
    // 模拟上传过程，返回一个进度流
    func uploadFile() -> Observable<Float> {
        return Observable<Float>.create { observer in
            var progress: Float = 0.0
            
            let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                // 更新进度
                progress += 0.1
                
                // 发送进度更新
                observer.onNext(progress)
                
                // 上传完成
                if progress >= 1.0 {
                    timer.invalidate()
                    observer.onCompleted()
                }
            }
            
            // 启动定时器
            timer.fire()
            
            // 当订阅被取消时，停止定时器
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
}
