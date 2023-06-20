//
//  ChannelsModel.swift
//  LimeTVStreaming
//
//  Created by Миша Перевозчиков on 01.12.2022.
//

import Foundation


// MARK: - ChannelsModel
struct ChannelsModel: Codable {
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

// MARK: Channel example
extension Channel {
    static let example =
        Channel(id: 11, epgId: 12, nameRu: "THT", nameEn: "TNT",
                vitrinaEventsUrl: "https://pl.iptv2021.com/api/v1/vitrina-config?id=136&tz=", isFederal: true, address: "tnt",
                image: "https://assets.iptv2022.com/static/channel/136/logo_256_1655448788.png", hasEpg: true,
                current: Current(timestart: 1669788000, timestop: 1669789800,
                                 title: "Физрук",
                                 desc:
                                """
                                 Выйдя на свободу, Фома узнаёт, что у Саши Мамаевой большие неприятности с бизнесом и Леной \"Белкой\".
                                Мамай не в состоянии помочь.
                                """,
                                 cdnvideo: 0, rating: 16),
                regionCode: 0, tz: 3, isForeign: false,
                number: 19, drmStatus: 0, owner: "lime",
                foreignPlayer: ForeignPlayer(sdk: "", url: "", validFrom: 1664520023), foreignPlayerKey: true,
                url: "https://mhd.iptv2022.com/p/LslElCsq5wSnq4RmfqctfQ,1669884079/streaming/tntott/324/1/index.m3u8",
                urlSound: "https://mhd.iptv2022.com/p/LslElCsq5wSnq4RmfqctfQ,1669884079/streaming/tntott/324/1/tracks-a1/mono.m3u8",
                cdn: "https://limehd.cdnvideo.ru/streaming/tntott/324/1/index.m3u8?md5=VMBAktaDH3lIA5DhU2iVVA&e=1669884079")
}

// MARK: Equatable
extension Channel: Equatable {
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        lhs.id == rhs.id
    }
}
