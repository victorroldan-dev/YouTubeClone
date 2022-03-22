//
//  OptionCell.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 22/03/22.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(option: String){
        titleLabel.text = option
    }
}
