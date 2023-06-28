//
//  QualityCell.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//

import UIKit

final class QualityCell: UITableViewCell {

	@IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

			let backgroundView = UIView()
			backgroundView.backgroundColor = UIColor.systemBlue
			selectedBackgroundView = backgroundView
    }

	func setLabel(with text: String) {
		label.text = text
	}
}
