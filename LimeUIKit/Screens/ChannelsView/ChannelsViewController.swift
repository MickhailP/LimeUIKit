//
//  ChannelsViewController.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 20.06.2023.
//

import UIKit
import AVKit

final class ChannelsViewController: UIViewController {

   let networkService: NetworkingProtocol = NetworkService()
   let favouritesStorage = FavouritesChannelsDataService()

   @IBOutlet var searchBar: UISearchBar!
   @IBOutlet var channelsGroups: UICollectionView!
   @IBOutlet var channelsList: UICollectionView!

   var channels: [Channel] = []
   var filteredChannels: [Channel] = []

   let tabItemsCategories: [Category] = Category.allCases
   var selectedCategory: Category = .all

   var isSearching: Bool = false


   //MARK: ViewController LifeCycle
   override func viewDidLoad() {
	  super.viewDidLoad()

	  configureSearchBar()
	  configureCollectionViews()


	  fetchChannels()
	  fetchFavoriteChannels()
   }


   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
	  if scrollView == channelsList {
		 let cells = channelsList.visibleCells
		 if let cell = cells.first, let indexPath = channelsList.indexPath(for: cell) {
			selectedCategory = tabItemsCategories[indexPath.item]
			channelsGroups.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
			channelsGroups.reloadData()
		 }
	  }
   }


   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
	  .portrait
   }


   override var shouldAutorotate: Bool {
	  false
   }
}


//MARK: - CollectionView setup
extension ChannelsViewController {

   private func configureSearchBar() {
	  searchBar.barTintColor = UIColor(named: "CustomGray")

	  if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
		 searchField.backgroundColor = UIColor(named: "CustomTertiary")
		 searchField.textColor = .white

		 searchField.attributedPlaceholder = NSAttributedString(string: searchField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

		 if let leftView = searchField.leftView as? UIImageView {
			leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
			leftView.tintColor = UIColor.lightGray
		 }
	  }
   }


   private func configureCollectionViews() {
	  setDelegates()
	  setDataSource()
	  registerCells()
   }


   private func setDelegates() {
	  searchBar.delegate = self
	  channelsGroups.delegate = self
	  channelsList.delegate = self
   }


   private func setDataSource() {
	  channelsGroups.dataSource = self
	  channelsList.dataSource = self
   }


   private func registerCells() {
	  channelsGroups.register(UINib(nibName: "GroupCell", bundle: nil), forCellWithReuseIdentifier: CellsID.channelsGroup)
	  channelsList.register(UINib(nibName: "ChannelsListCell", bundle: nil), forCellWithReuseIdentifier: CellsID.channelsListCell)
   }
}


//MARK: - Fetching methods
extension ChannelsViewController {

   private func fetchChannels() {

	  guard let url = Endpoint.allChannels.url else {
		 return
	  }

	  networkService.downloadDataResult(from: url) { [weak self] result in

		 guard let self = self else {
			return
		 }

		 switch result {

			case .success(let data):
			   guard let channelsModel: ChannelsModel = DataDecoder.decode(data) else {
				  displayAlert(with: "Error", message: ErrorMessage.decodingError.rawValue)
				  return
			   }
			   DispatchQueue.main.async {
				  self.channels = channelsModel.channels
				  self.channelsList.reloadData()
			   }
			case .failure(let error as ErrorMessage):
			   displayAlert(with: "Error", message: error.rawValue)

			case .failure(let error):
			   displayAlert(with: "Error", message: error.localizedDescription)
		 }
	  }
   }


   private func fetchFavoriteChannels() {

	  do {
		 try favouritesStorage.getAlObjects()

	  } catch let error as ErrorMessage {
		 displayAlert(with: "Error", message: error.rawValue)
	  }
	  catch {
		 displayAlert(with: "Error", message: error.localizedDescription)
	  }
   }


   private func selectChannels(for category: Category) -> [Channel] {

	  if isSearching {
		 switch category {
			case .all:
			   return filteredChannels
			case .favourites:
			   return filteredChannels.filter { favouritesStorage.favouritesChannels.contains($0.id) }
		 }
	  } else {
		 switch category {
			case .all:
			   return channels
			case .favourites:
			   return channels.filter { favouritesStorage.favouritesChannels.contains($0.id) }
		 }
	  }
   }
}


//MARK: - UISearchBarDelegate
extension ChannelsViewController: UISearchBarDelegate {

   func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
	  searchBar.setShowsCancelButton(true, animated: true)
   }


   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	  isSearching = true
	  performSearching(searchText)
   }


   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
	  endSearching()
	  resetSearchResults()
   }


   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
	  if let searchText = searchBar.text {
		 performSearching(searchText)
	  }
   }


   private func performSearching(_ searchText: String) {
	  if searchText.count !=  0 {
		 searchChannel(by: searchText)
	  } else {
		 resetSearchResults()
		 endSearching()
	  }
   }


   private func searchChannel(by name: String) {
	  filteredChannels = channels.filter { $0.nameRu.localizedCaseInsensitiveContains(name) }
	  channelsList.reloadData()
   }


   private func resetSearchResults() {
	  filteredChannels = channels
	  channelsList.reloadData()
   }


   private func endSearching() {
	  isSearching = false
	  searchBar.endEditing(true)
	  searchBar.setShowsCancelButton(false, animated: true)
	  searchBar.text = ""
	  searchBar.resignFirstResponder()
   }
}


//MARK: - UICollectionViewDataSource
extension ChannelsViewController: UICollectionViewDataSource {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
	  tabItemsCategories.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

	  if collectionView == channelsGroups {
		 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsID.channelsGroup, for: indexPath) as! GroupCell

		 let category = tabItemsCategories[indexPath.item]
		 let isSelected = selectedCategory == category

		 cell.setupCell(category: category, isSelected: isSelected)

		 return cell
	  } else {

		 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsID.channelsListCell, for: indexPath) as! ChannelsListCell
		 cell.delegate = self

		 let category = tabItemsCategories[indexPath.row]
		 let channels = selectChannels(for: category)
		 cell.setUp(channels: channels, favouritesService: favouritesStorage)

		 return cell
	  }
   }
}


//MARK: - UICollectionViewDelegateFlowLayout {
extension ChannelsViewController: UICollectionViewDelegateFlowLayout {

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

	  if collectionView == channelsGroups {
		 let groupName = tabItemsCategories[indexPath.row].rawValue
		 let width = groupName.widthOfString(usingFont: UIFont.systemFont(ofSize: 17))
		 return CGSize(width: width + 20, height: collectionView.frame.height)
	  } else {

		 return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height)
	  }
   }


   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
	  return 10
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
	  return 10
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
	  return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
   }
}


//MARK: - UICollectionViewDelegate
extension ChannelsViewController: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	  if collectionView == channelsGroups {
		 selectedCategory = tabItemsCategories[indexPath.item]
		 channelsGroups.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		 channelsGroups.reloadData()
		 channelsList.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
	  }
   }
}


//MARK: - CollectionViewCellDelegate
extension ChannelsViewController: CollectionViewCellDelegate {

   func showPlayer(for channel: Channel) {
	  let playerViewController = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
	  playerViewController.setUp(with: channel)
	  show(playerViewController, sender: self)
   }

   func favoriteButtonPressed() {
	  fetchFavoriteChannels()
	  channelsList.reloadData()
   }

   func didFinishedWith(error: Error) {

	  if let error = error as? ErrorMessage {
		 displayAlert(with: "Error", message: error.rawValue)
	  } else {
		 displayAlert(with: "Error", message: error.localizedDescription)
	  }
   }
}
