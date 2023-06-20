//
//  Endpoints.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 17.01.2023.
//

import Foundation


enum Endpoint {

	 case allChannels
}


//MARK: - Components
extension Endpoint {

	 var scheme: String { "https" }

	 var host: String { "limehd.online" }

	 var path: String {
		  switch self {
				case .allChannels:
					 return "/playlist/channels.json"
		  }
	 }

	 var queryItems: [String: String]? {
		  nil
	 }
}


//MARK: - URL
extension Endpoint {
	 var url: URL? {
		  var components = URLComponents()
		  components.scheme = scheme
		  components.host = host
		  components.path = path

		  let queryItems = queryItems?.compactMap{ URLQueryItem(name: $0.key, value: $0.value) }

		  components.queryItems = queryItems

		  return components.url
	 }
}
