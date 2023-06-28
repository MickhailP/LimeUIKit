//
//  ImageCacheManager.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 20.06.2023.
//

import Foundation
import UIKit


//MARK: - ImageStorageProtocol
protocol ImageStorageProtocol {

	 func add(key: String, value: UIImage)
	 func get(key: String) -> UIImage?
}


//MARK: - ImageCacheManager
final class ImageCacheManager: ImageStorageProtocol {

	 static let shared = ImageCacheManager()

	 private init() { }

	 var photoCache: NSCache<NSString, UIImage> = {
		  var cache = NSCache<NSString, UIImage>()
		  cache.countLimit = 200
		  cache.totalCostLimit = 1024 * 1024 * 100 //100 MB
		  return cache
	 }()

	 func add(key: String, value: UIImage) {
		  photoCache.setObject(value, forKey: key as NSString)
	 }

	 func get(key: String) -> UIImage? {
		  return photoCache.object(forKey: key as NSString)
	 }
}
