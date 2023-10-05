//
//  TransLateData.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/05.
//

import Foundation

import Foundation

// MARK: - TransData
struct TransData: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let type, service, version: String
    let result: Result

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case service = "@service"
        case version = "@version"
        case result
    }
}

// MARK: - Result
struct Result: Codable {
    let srcLangType, tarLangType, translatedText: String
}
