//
//  UploadManager.swift
//  webjsb
//
//  Created by dongju.yang on 2025/4/28.
//


import Foundation
import RxSwift

class UploadManager {
    private let uploadUtil = UploadUtil()
    private let disposeBag = DisposeBag()
    
    typealias ProgressCallback = (Float) -> Void
    typealias CompletionCallback = (Bool, String) -> Void
    
    
    // MARK: - 初始化与析构
    init() {
        print("UploadManager - 初始化")
    }
    
    deinit {
        print("UploadManager - 析构")
        // 清理资源，如果有的话
    }
    
    // 开始上传，传入进度回调和完成回调
    func startUpload(progressCallback: @escaping ProgressCallback, 
                     completionCallback: @escaping CompletionCallback) {
        
        uploadUtil.uploadFile()
            .subscribe(
                onNext: { progress in
                    // 回调进度更新
                    progressCallback(progress)
                },
                onError: { error in
                    // 回调上传失败
                    completionCallback(false, "上传失败: \(error.localizedDescription)")
                }, onCompleted: {
                    // 回调上传完成
                    completionCallback(true, "上传完成！")
                }
            )
            .disposed(by: disposeBag)
    }
}
