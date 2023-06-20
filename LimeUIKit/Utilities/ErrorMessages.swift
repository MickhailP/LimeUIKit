//
//  ErrorMessages.swift
//  Chats
//
//  Created by Миша Перевозчиков on 08.06.2023.
//

import Foundation


enum ErrorMessage: String, Error {
	 case badURl = "URL is invalid"
	 case invalidData = "Data is missing"
	 case badRequest = "Request is not correct"

	 case encodingError = "Encoding error"
	 case decodingError = "Decoding error"

	 case unableFetchFromDataBase = "Failed to load data from storage."

	 case unableConvertImageData = "Failed to convert image for uploading format"

	 case unknown = "Unknown error"
}
