//
//  ChannelTableViewCell.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 21.06.2023.
//

import UIKit


//MARK: - Cell delegate
protocol ChannelCellDelegate: AnyObject {
	 
	 func favoriteButtonPressed(for channel: Channel)
}


//MARK: - Cell
final class ChannelTableViewCell: UITableViewCell {
	 
	 var favouritesService: FavouritesChannelsDataService?
	 var channel: Channel?
	 
	 weak var delegate: ChannelCellDelegate?
	 
	 @IBOutlet var container: UIView!
	 @IBOutlet var imageContainer: UIView!
	 
	 @IBOutlet var channelImage: UIImageView!
	 @IBOutlet var loadingIndicator: UIActivityIndicatorView!

	 @IBOutlet var name: UILabel!
	 @IBOutlet var program: UILabel!
	 @IBOutlet var favoriteButton: UIButton!




	 override func awakeFromNib() {
		  super.awakeFromNib()
		  
		  configureCell()
		  configureImageContainer()
		  configureImage()
		 loadingIndicator.startAnimating()
	 }
	 
	 
	 func setCell(with channel: Channel, isFavorite: Bool?) {
		  self.channel = channel
		  name.text = channel.nameRu
		  program.text = channel.current.title
		  configureButtonImage(isFavourite: isFavorite)

		 if channelImage.image == nil {
			 fetchImage()
		 }
		
	 }
	 
	 
	 @IBAction func buttonPressed(_ sender: Any) {
		  
		  guard let channel else {
				return
		  }
		  
		  delegate?.favoriteButtonPressed(for: channel)
	 }
	 
	 
	 private func configureCell() {
		  container.layer.cornerRadius = 10
		  container.layer.masksToBounds = true
	 }
	 
	 
	 private func configureImageContainer() {
		  imageContainer.layer.cornerRadius = 15
		  imageContainer.clipsToBounds = true
	 }
	 
	 
	 private func configureImage() {
		  channelImage.clipsToBounds = true
		  channelImage.contentMode = .scaleAspectFill
	 }


	 private func configureButtonImage(isFavourite: Bool? ) {
		  
		  guard let isFavourite else { return }
		  
		  UIView.animate(withDuration: 1) {
				self.favoriteButton.setImage(isFavourite ? UIImage(named: "star.fill") : UIImage(named: "star"), for: .normal)
		  }
	 }
	 
	 
	 private func fetchImage() {

		  guard let channel else {
				return
		  }

		  let imageURLString = channel.image

		 NetworkService().downloadImage(from: imageURLString) { [weak self] image in
			 guard let self = self else { return }

			 DispatchQueue.main.async {
				 self.channelImage.image = image
				 self.loadingIndicator.stopAnimating()
				 
			 }
		 }
	 }


	 override func prepareForReuse() {
		  name.text = nil
		  program.text = nil
		  favoriteButton.imageView?.image = nil
		  channel = nil
		  favouritesService = nil
		 channelImage.image = nil
	 }
}

