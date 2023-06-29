//
//  VideoModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 04.12.2022.
//

import Foundation


// MARK: Video
struct Video {
    let streams: [Stream]
}


// MARK: Stream
struct Stream {
    let resolution: Resolution
    let streamURL: URL?
}


// MARK: Resolution
enum Resolution: Int, Identifiable, CaseIterable {

		case auto = 0
		case p240
    case p360
    case p480
    case p576
    case p720
    case p1080
    
    var id: Int { rawValue }
    
    var displayValue: String {
        switch self {
						case .auto: return "Auto"
            case .p240: return "240p"
            case .p360: return "360p"
            case .p480: return "480p"
            case .p576: return "576p"
            case .p720: return "720p"
            case .p1080: return "1080p"
            
        }
    }
}


extension Stream {

	static let example = [
		Stream(resolution: .auto, streamURL: URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!),
		Stream(resolution: .p240, streamURL: URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!),
		Stream(resolution: .p360, streamURL: URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!),
	]
}
