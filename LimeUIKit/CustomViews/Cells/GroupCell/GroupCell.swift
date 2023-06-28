//
//  GroupCell.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 26.06.2023.
//

import UIKit

final class GroupCell: UICollectionViewCell {

	 @IBOutlet var categoryLabel: UILabel!
	 @IBOutlet var selectionBar: UIView!


	 override func awakeFromNib() {
		  super.awakeFromNib()

	 }

	 func setupCell(category: Category, isSelected: Bool) {

		  categoryLabel.text = category.rawValue

		  UIView.animate(withDuration: 1) {
				if isSelected {
					 self.selectionBar.isHidden = false
					 self.categoryLabel.textColor = .white
				} else {
					 self.selectionBar.isHidden = true
					 self.categoryLabel.textColor = .lightGray

				}
		  }
	 }
}
