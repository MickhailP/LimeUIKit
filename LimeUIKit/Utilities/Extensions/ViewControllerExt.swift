//
//  ViewControllerExt.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//

import UIKit


extension UIViewController: UIPopoverPresentationControllerDelegate {

	public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}


	func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
		viewController.preferredContentSize = size
		viewController.modalPresentationStyle = .popover
		if let pres = viewController.presentationController {
			pres.delegate = parentViewController
		}
		parentViewController.present(viewController, animated: true)
		if let pop = viewController.popoverPresentationController {
			pop.sourceView = sender
			pop.sourceRect = sender.bounds
			pop.permittedArrowDirections = arrowDirection
		}
	}
}


//MARK: Alert
extension UIViewController {

	func displayAlert(with title: String, message: String, action: UIAlertAction = UIAlertAction(title: "Ok", style: .default)) {
		DispatchQueue.main.async {
			guard self.presentedViewController == nil else {
				return
			}

			let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alertController.addAction(action)
			self.present(alertController, animated: true)
		}
	}
}
