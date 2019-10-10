//
//  SpeakerCollectionReusableView.swift
//  JBDiffableDataSource
//
//  Created by Jeroen Bakker on 29/09/2019.
//  Copyright © 2019 Jeroen Bakker. All rights reserved.
//

import UIKit

final class SpeakerCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
}

// MARK: - Display
extension SpeakerCollectionReusableView {
    
    func display(viewModel: String) {
        titleLabel.text = viewModel
    }
}
