//
//  ListCell.swift
//  PracticeMVVM
//
//  Created by Thinkpower on 2019/10/18.
//  Copyright © 2019 Thinkpower. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

   
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: ListCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // 將照片先清空或設成預設照片
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        self.viewModel?.onImageDownloaded = nil
    }
    
    // 將 viewModel 要顯示的資訊更新在 cell 上
    func setup(viewModel: ListCellViewModel) {
        self.viewModel = viewModel
        
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        
        self.viewModel?.onImageDownloaded = { [weak self] image in
            DispatchQueue.main.async {
                self?.albumImageView.image = image
            }
        }
        self.viewModel?.getImage()
    }
}
