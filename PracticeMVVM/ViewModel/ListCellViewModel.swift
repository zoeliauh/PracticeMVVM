//
//  ListCellViewModel.swift
//  PracticeMVVM
//
//  Created by woanjwu liauh on 2022/6/9.
//  Copyright © 2022 Thinkpower. All rights reserved.
//

import Foundation
import UIKit

// 希望 cell 能自己處理自己應當顯示的部分

class ListCellViewModel {
    var title: String
    var description: String
    var imageUrlString: String
    
    init(title: String, description: String, imageUrlString: String) {
        self.title = title
        self.description = description
        self.imageUrlString = imageUrlString
    }
    
    // operations
    private let downloadImageQueue = OperationQueue()
        
    // 新增此變數，以便後續當圖片下載完成後，可以通知 cell 做畫面更新
    var onImageDownloaded: ((UIImage?) -> Void)?
        
    func getImage() {
        guard let url = URL(string: imageUrlString) else { return }
        downloadImageQueue.addOperation { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                
                guard let imageDownloaded = self?.onImageDownloaded else { return }
                imageDownloaded(image)
            } catch let error {
                printLog(logs: [error.localizedDescription], title: "Get Image Error-")
            }
        }
    }
}
