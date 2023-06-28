//
//  StringExt.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 22.06.2023.
//

import Foundation
import UIKit


extension String{

	 func widthOfString(usingFont font: UIFont) -> CGFloat {
		  let fontAttributes = [NSAttributedString.Key.font: font]
		  let size = (self as NSString).size(withAttributes: fontAttributes)
		  return ceil(size.width)
	 }
}
