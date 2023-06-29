//
//  DataDecoder.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 20.06.2023.
//

import Foundation

final class DataDecoder {

	 class func decode<T: Decodable> (_ data: Data) -> T? {

		  let decoder = JSONDecoder()
		  decoder.keyDecodingStrategy = .convertFromSnakeCase

		  do {
				let decoded = try decoder.decode(T.self, from: data)
				return decoded
		  } catch {
				print(error)
				print(error.localizedDescription)
				return nil
		  }
	 }
}
