//
//  NetworkingProtocol.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation
import UIKit


protocol NetworkingProtocol: AnyObject {

	func downloadDataResult(from url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void)
	func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void)
}


extension NetworkingProtocol {

	/// Check if URLResponse have good status code, if it's not, it will throw an error
	/// - Parameter response: URLResponse from dataTask
	func handleResponse(_ response: URLResponse?) throws {

		guard let response = response as? HTTPURLResponse else {
			throw URLError(.cannotParseResponse)
		}

		let statusCode = response.statusCode

		print(statusCode)
		if statusCode >= 200 && statusCode <= 300 {
			return
		} else {
			throw URLError(.badServerResponse)
		}
	}
}
