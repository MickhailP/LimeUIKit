//
//  PlayerViewController.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 27.06.2023.
//

import UIKit
import AVKit


final class PlayerViewController: UIViewController {

	@IBOutlet var videoView: UIView!

	let qualityButton = UIButton(type: .system)
	let backButton = UIButton(type: .system)

	var channel: Channel?
	var video: Video?

	var player: AVPlayer!
	var playerLayer: AVPlayerLayer!

	let videoManager = VideoManager()


	override func viewDidLoad() {
		super.viewDidLoad()

		addQualityButton()
		addBackButton()

		getVideo()
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
}


//MARK: - ViewSetup
extension PlayerViewController {

	func setUp(with channel: Channel) {
		self.channel = channel
	}


	private func setUpPlayer() {

		guard let channel,
			  let url = URL(string: channel.url)
		else {
			displayAlert(with: "Error", message: "URL is missing")
			return
		}

		player = AVPlayer (url: url)

		playerLayer = AVPlayerLayer(player: player)
		playerLayer.videoGravity = .resizeAspectFill

		videoView.layer.addSublayer(playerLayer)
	}
}

//MARK: - ButtonsConfiguration
extension PlayerViewController {

	private func addQualityButton() {

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

		guard let streams = video?.streams else { return }

		let popoverContent = PopoverViewController(streams: streams)
		popoverContent.delegate = self
		presentPopover(self, popoverContent, sender: qualityButton, size: CGSize(width: 100, height: 150), arrowDirection: .down)
	}


	private func addBackButton() {

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


//MARK: - VideoResolutions
extension PlayerViewController {

	private func getVideo() {

		guard let channel else {
			return
		}

		videoManager.decodePlaylist(from: channel.url) { [weak self] streams, error in

			if let streams {
				self?.video = Video(streams: streams)
			}

			if let error {
				self?.displayAlert(with: "Error", message: error.localizedDescription)
			}
		}
	}


	private func changeResolution(for video: Video, with newResolution: Resolution, in player: AVPlayer) {

		guard let stream = video.streams.first(where: { $0.resolution == newResolution }) else {
			displayAlert(with: "Error", message: ErrorMessage.videoNotFound.rawValue)
			return
		}

		let currentTime: CMTime

		if let currentItem = player.currentItem {
			currentTime = currentItem.currentTime()
		} else {
			currentTime = .zero
		}

		guard let url = stream.streamURL else {
			displayAlert(with: "Error", message: ErrorMessage.badURl.rawValue)
			return
		}

		player.replaceCurrentItem(with: AVPlayerItem(url: url))
		player.seek(to: currentTime, toleranceBefore: .zero, toleranceAfter: .zero)
		player.play()
		print("Resolution changed")
	}
}


//MARK: - QualityCellDelegate
extension PlayerViewController: QualityCellDelegate {

	func didSelect(_ stream: Stream) {
		guard let video else { return }
		changeResolution(for: video, with: stream.resolution, in: self.player)
	}
}


