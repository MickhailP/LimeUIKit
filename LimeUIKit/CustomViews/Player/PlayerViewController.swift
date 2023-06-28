//
//  PlayerViewController.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 27.06.2023.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {

	@IBOutlet var videoView: UIView!

	let qualityButton = UIButton(type: .system)
	let backButton = UIButton(type: .system)

	var url: URL?

	var player: AVPlayer!
	var playerLayer: AVPlayerLayer!



	override func viewDidLoad() {
		super.viewDidLoad()

		addQualityButton()
		addBackButton()

		setUpPlayer()
	}


	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		playerLayer.masksToBounds = true
		playerLayer?.frame = videoView.bounds
	}


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		player.play()
	}


	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		.landscape
	}


	func setUp(with url: URL) {
		self.url = url
	}


	func setUpPlayer() {

		guard let url	else {
			return
		}

		player = AVPlayer (url: url)

		playerLayer = AVPlayerLayer(player: player)
		playerLayer.videoGravity = .resizeAspectFill

		videoView.layer.addSublayer(playerLayer)
	}


	func addQualityButton() {

		qualityButton.tintColor = .white
		qualityButton.setImage(UIImage(named: "gear"), for: .normal)
		qualityButton.addTarget(self, action: #selector(qualityButtonPressed), for: .touchUpInside)
		qualityButton.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(qualityButton)


		NSLayoutConstraint.activate([
			qualityButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor , constant: -15),
			qualityButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
		])
	}


	@objc func qualityButtonPressed() {

		let popoverContent = PopoverViewController(qualities: ["MID", "Auto", "Low"])
		presentPopover(self, popoverContent, sender: qualityButton, size: CGSize(width: 100, height: 150), arrowDirection: .down)
	}


	func addBackButton() {

		backButton.tintColor = .white
		backButton.setImage(UIImage(named: "arrow.left"), for: .normal)
		backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		backButton.contentVerticalAlignment = .fill
		backButton.contentHorizontalAlignment = .fill

		view.addSubview(backButton)


		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 15),
			backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
			backButton.widthAnchor.constraint(equalToConstant: 25),
			backButton.heightAnchor.constraint(equalToConstant: 25)
		])
	}

		@objc func backPressed() {
			dismiss(animated: true, completion: nil)
		}
}

