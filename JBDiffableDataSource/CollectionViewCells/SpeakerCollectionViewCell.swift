//
//  SpeakerCollectionViewCell.swift
//  JBDiffableDataSource
//
//  Created by Jeroen Bakker on 21/09/2019.
//  Copyright © 2019 Jeroen Bakker. All rights reserved.
//

import UIKit
import Nuke

final class SpeakerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var twitterHandler: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        avatarImageView.image = UIImage(named: "User_Avatar")
    }
}

// MARK: - Display
extension SpeakerCollectionViewCell {
    
    func display(viewModel: Speaker) {
        titleLabel.text = viewModel.name
        twitterHandler.text = viewModel.twitterHandler
        
        guard let imageURL = viewModel.imageURL else { return }
        Nuke.loadImage(with: imageURL, into: avatarImageView)
    }
}
