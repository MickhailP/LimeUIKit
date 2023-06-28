//
//  M3U8Parser.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 28.06.2023.
//

import Foundation


final class M3U8Parser {

	func parseMediaInfo(from data: String) -> [MediaInfo] {
		var mediaInfoArray: [MediaInfo] = []

		let lines = data.components(separatedBy: .newlines)

		for line in lines {
			if line.hasPrefix("#EXT-X-STREAM-INF") {
				if let uriLine = lines.first(where: { $0.hasPrefix(line) == false }) {
					let uri = uriLine.components(separatedBy: "?").first ?? ""
					let resolution = extractResolution(from: line)
					let mediaInfo = MediaInfo(uri: uri, resolution: Int(resolution) ?? 0)
					mediaInfoArray.append(mediaInfo)
				}
			}
		}

		return mediaInfoArray
	}

	private func extractResolution(from line: String) -> String {
		guard let range = line.range(of: "RESOLUTION=") else {
			return ""
		}

		var resolution = line[range.upperBound...]
		if let endIndex = resolution.firstIndex(of: ",") {
			resolution = resolution[..<endIndex]
		}

		return String(resolution.split(separator: "x")[0])
	}
}
