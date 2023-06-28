//
//  QualityCell.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//

import UIKit

final class QualityCell: UITableViewCell {

	@IBOutlet var label: UILabel!

	var resolution: Resolution?

    override func awakeFromNib() {
        super.awakeFromNib()

			let backgroundView = UIView()
			backgroundView.backgroundColor = UIColor.systemBlue
			selectedBackgroundView = backgroundView
    }


	func setLabel(with resolution: Resolution) {
		self.resolution = resolution
		label.text = resolution.displayValue
	}
}
