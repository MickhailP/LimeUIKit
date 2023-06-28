//
//  ChannelsListCell.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 21.06.2023.
//

import UIKit
import AVKit


//MARK: - CollectionViewCell delegate
protocol CollectionViewCellDelegate: AnyObject {
	 
	 func favoriteButtonPressed()
	 func showPlayer(for channel: Channel)
}


//MARK: - ChannelsListCell
final class ChannelsListCell: UICollectionViewCell {

	 @IBOutlet var channelsTableView: UITableView!
	 

	 var channels: [Channel] = []
	 var favouritesService: FavouritesChannelsDataService?

	 weak var delegate: CollectionViewCellDelegate?

	 override func awakeFromNib() {
		  super.awakeFromNib()

		  configureTableView()
	 }



	 func setUp(channels: [Channel], favouritesService: FavouritesChannelsDataService) {
		  self.channels = channels
		  self.favouritesService = favouritesService
		  channelsTableView.reloadData()
	 }


	 private func configureTableView() {
		  channelsTableView.delegate = self
		  channelsTableView.dataSource = self
		  channelsTableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: CellsID.channelCell)
		  channelsTableView.separatorStyle = .none
	 }
}


//MARK: - UITableViewDataSource
extension ChannelsListCell: UITableViewDataSource {

	 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		  channels.count
	 }


	 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		  let cell = tableView.dequeueReusableCell(withIdentifier: CellsID.channelCell) as! ChannelTableViewCell
		  let channel = channels[indexPath.row]
		  cell.delegate = self

		  let isFavourite = favouritesService?.contains(channel.id)

		  cell.setCell(with: channel, isFavorite: isFavourite)
		  return cell
	 }


}


//MARK: - UITableViewDelegate
extension ChannelsListCell: UITableViewDelegate {

	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		  let channel = channels[indexPath.row]
		  delegate?.showPlayer(for: channel)
	 }
}


//TODO: IMAGES
extension ChannelsListCell: UITableViewDataSourcePrefetching {

	 func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

	 }
}

//MARK: - ChannelCellDelegate
extension ChannelsListCell: ChannelCellDelegate {

	 func favoriteButtonPressed(for channel: Channel) {

		  guard let isFavourite = favouritesService?.contains(channel.id) else {
				//TODO: SHOW ALERT
				return
		  }

		  do {
				if isFavourite {
					 try favouritesService?.deleteFromFavourites(channel.id)
					 print("deleted")
				} else {
					 try favouritesService?.addToFavourites(channel.id)
					 print("added")
				}

				channelsTableView.reloadData()

				delegate?.favoriteButtonPressed()

		  } catch {
				//TODO: SHOW ALERT
		  }
	 }
}
