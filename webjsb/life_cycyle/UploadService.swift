//
//  UploadService.swift
//  webjsb
//
//  Created by dongju.yang on 2025/4/28.
//


import Foundation
import RxSwift

// 单例服务 - 处理上传业务逻辑
class UploadService {
    // 单例实例
    static let shared = UploadService()
    
    private let uploadUtil = UploadUtil()
    private var disposeBag = DisposeBag()
    
    // 私有初始化方法确保只有一个实例
    private init() {
        print("UploadService - 初始化")
    }
    
    deinit {
        print("UploadService - 析构")
    }
    
    // 开始上传
    func startUpload(
        progressCallback: @escaping (Float) -> Void,
        completionCallback: @escaping (Bool, String) -> Void
    ) {
        print("UploadService - 开始上传任务")
        
        // 确保每次调用都使用新的DisposeBag
        disposeBag = DisposeBag()
        
        uploadUtil.uploadFile()
            .subscribe(
                onNext: { progress in
                    progressCallback(progress)
                    print("UploadService - 进度更新: \(Int(progress * 100))%")
                },
                onError: { error in
                    completionCallback(false, "上传失败: \(error.localizedDescription)")
                    print("UploadService - 上传任务失败: \(error.localizedDescription)")
                }, onCompleted: {
                    completionCallback(true, "上传完成！")
                    print("UploadService - 上传任务完成")
                }
            )
            .disposed(by: disposeBag)
    }
    
    // 取消上传 - 清理资源
    func cancelUpload() {
        print("UploadService - 取消上传任务")
        disposeBag = DisposeBag() // 创建新的DisposeBag会取消之前的订阅
    }
}
