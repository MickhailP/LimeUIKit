//
//  VideoManager.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//


import Foundation
import AVKit


protocol VideoManagerProtocol {

	func decodePlaylist(from urlString: String, completionHandler: @escaping ([Stream]?, Error?) -> Void)
	func changeResolution(for video: Video, with newResolution: Resolution, in player: AVPlayer)
}


final class VideoManager {

	func decodePlaylist(from urlString: String, completionHandler: @escaping ([Stream]?, Error?) -> Void)  {

		guard let url = URL(string: urlString) else {
			completionHandler(nil, ErrorMessage.badURl)
			return
		}

		NetworkService().downloadDataResult(from: url) { result in

			//СДЕЛАНО ДЛЯ ТЕСТА. Тк не удается загрузить файл с сервера
			let streamsExample = Stream.example
			completionHandler(streamsExample, nil)

			//Основной поток
			switch result {
				case .success(let data):

					guard let m3u8String = String(data: data, encoding: .utf8) else {
						print("Invalid response data or encoding")
						completionHandler(nil, ErrorMessage.m3u8Fail)
						return
					}

					let media = M3U8Parser().parseMediaInfo(from: m3u8String)
					let streams = self.createStreams(for: media, using: url)

				case let .failure(error):
					print(error)
					print(error.localizedDescription)
					completionHandler(nil, error)
			}
		}
	}


	private func createStreams(for playlist: [MediaInfo], using url: URL ) -> [Stream] {

		playlist.compactMap { item in

			let newURL = URL(string: item.uri, relativeTo: url)

			switch item.resolution {
				case 240:
					return Stream(resolution: .p240, streamURL: newURL )
				case 360:
					return Stream(resolution: .p360, streamURL: newURL )
				case 480:
					return Stream(resolution: .p480, streamURL: newURL )
				case 576:
					return Stream(resolution: .p576, streamURL: newURL )
				case 720:
					return Stream(resolution: .p720, streamURL: newURL )
				case 1080:
					return Stream(resolution: .p1080, streamURL: newURL )
				default:
					return Stream(resolution: .auto, streamURL: url)
			}
		}
	}
}
