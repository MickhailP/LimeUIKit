//
//  FavouritesChannelsDataService.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation


//MARK: - UserDefaults Keys
extension UserDefaults {
	 public enum SaveKeys: String {
		  case favouritesChannels = "users_favourites_channels"
	 }
}


//MARK: - DataService
final class FavouritesChannelsDataService {
    
	 var favouritesChannels: Set<Int> = []

	 private let userDefaults: UserDefaults
    private let saveKey = UserDefaults.SaveKeys.favouritesChannels


    init(userDefaultsContainer: UserDefaults = UserDefaults.standard) {
		  self.userDefaults = userDefaultsContainer
    }


    func getAlObjects() throws {

		  guard let data = userDefaults.data(forKey: saveKey.rawValue) else {
				throw ErrorMessage.unableFetchFromDataBase
		  }

		  do {
				let decodedData = try JSONDecoder().decode(Set<Int>.self, from: data)
				favouritesChannels = decodedData
		  } catch  {
				throw error
		  }
	 }

	 func contains(_ channelID: Int) -> Bool {
        favouritesChannels.contains(channelID)
    }
    
    func addToFavourites(_ channelID: Int) throws {
        favouritesChannels.insert(channelID)
        try save()
    }
    
    func deleteFromFavourites(_ channelID: Int) throws {
        favouritesChannels.remove(channelID)
        try save()
	 }

	 private func save() throws  {
		  do {
				let encoded = try JSONEncoder().encode(favouritesChannels)
				UserDefaults.standard.set(encoded, forKey: saveKey.rawValue)

		  } catch {
				throw error
		  }
	 }
}


