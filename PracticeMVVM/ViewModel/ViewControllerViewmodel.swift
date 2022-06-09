//
//  ViewControllerViewmodel.swift
//  PracticeMVVM
//
//  Created by woanjwu liauh on 2022/6/9.
//  Copyright © 2022 Thinkpower. All rights reserved.
//

import Foundation

// 希望 view 能自己處理自己應當顯示的部分

class ViewControllerViewModel {
    
    let service = RequestCommunicator<DownloadMusic>()
    var musicHandlers: [MusicHandler] = []
    var listCellViewModels: [ListCellViewModel] = []
    
    var onRequestEnd: (() -> Void)?
    
    var searchText: String = "" {
        didSet {
            prepareRequest(with: searchText)
        }
    }
    
    private func prepareRequest(with name: String) {
        service.request(type: .searchMusic(media: "music", entity: "song", term: name)) { [weak self] (result) in
            switch result {
            case .success(let response):
                guard let musicHandelr = MusicHandler.updateSearchResults(response.data, section: 0),
                      let requestEnd = self?.onRequestEnd else { return }
                
                self?.musicHandlers.append(contentsOf: musicHandelr)
                self?.convertMusicToViewModel(musics: musicHandelr)
                
            case .failure(let error):
                print("Network error: \(error.localizedDescription)")
            }
        }
    }
    
    // 取得伺服器回應的資料後，將其轉成 Cell，可以直接取用的 ListCellViewModel
    private func convertMusicToViewModel(musics: [MusicHandler]) {
        for music in musics {
            let listCellViewModel = ListCellViewModel(title: music.collectionName, description: music.name, imageUrlString: music.imageUrl)
            listCellViewModels.append(listCellViewModel)
        }
        // 用來告知 VC 可以更新畫面
        onRequestEnd?()
    }
}
