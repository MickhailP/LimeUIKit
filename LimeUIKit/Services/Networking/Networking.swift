//
//  Networking.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation
import UIKit


final class NetworkService: NetworkingProtocol {

	 let cache = ImageCacheManager.shared

	 func downloadDataResult(from url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) {

		  let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let error {
					 completionHandler(.failure(error))
				}

				guard let data else {
					 completionHandler(.failure(ErrorMessage.invalidData))
					 return
				}

				do {
					 try self.handleResponse(response)
					 completionHandler(.success(data))

				} catch  {
					 print(error)
					 print(error.localizedDescription)
					 completionHandler(.failure(ErrorMessage.decodingError))
				}
		  }
		  task.resume()
	 }


	func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {

		  if let cachedImage = cache.get(key: url) {
					 print("Cached")
				completion(cachedImage)
		  } else {
				var image: UIImage? = nil

				fetchImage(from: url) { fetchedImage in
					 if let fetchedImage {
						  self.cache.add(key: url, value: fetchedImage)
						 completion(fetchedImage)
					 }
				}
				print("Loaded")
		  }
	 }


	 private func fetchImage(from urlString: String, completionHandler: @escaping (UIImage?) -> Void) {

		  guard let url = URL(string: urlString) else {
				completionHandler(nil)
				return
		  }

		  let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let error {
					 completionHandler(nil)
					 return
				}

				guard let data else {
					 completionHandler(nil)
					 return
				}

				do {
					 try self.handleResponse(response)
					 completionHandler(UIImage(data: data))

				} catch  {
					 print(error)
					 print(error.localizedDescription)
					 completionHandler(nil)
				}
		  }
		  task.resume()
	 }
}
