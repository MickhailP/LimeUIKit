//
//  ChannelsModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation


// MARK: - ChannelsModel
struct ChannelsModel: Decodable {
    let channels: [Channel]
    let valid: Int?
    let ckey: String?
}

// MARK: - Channel
struct Channel: Codable, Identifiable {
    let id, epgId: Int
    let nameRu, nameEn: String
    let vitrinaEventsUrl: String
    let isFederal: Bool
    let address: String
    let image: String
    let hasEpg: Bool
    let current: Current
    let regionCode, tz: Int
    let isForeign: Bool
    let number, drmStatus: Int
    let owner: String
    let foreignPlayer: ForeignPlayer
    let foreignPlayerKey: Bool
    let url, urlSound, cdn: String

}

// MARK: - Current
struct Current: Codable {
    let timestart, timestop: Int
    let title, desc: String
    let cdnvideo, rating: Int
}

// MARK: - ForeignPlayer
struct ForeignPlayer: Codable {
    let sdk, url: String
    let validFrom: Int

}


// MARK: Equatable
extension Channel: Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
}
