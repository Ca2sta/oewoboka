//
//  NaverDictionaryManager.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/01.
//

import Foundation

struct NaverDictionaryManager {
    
    enum Language {
        case ko
        case en
        
        var getLanguage: String {
          switch self {
          case .ko:
            return "ko"
          case .en:
            return "en"
          }
        }
    }
    
    func getTranslateData(searchKeyWord: String?, from: Language, target: Language, completion: @escaping (_ result: Result) -> Void) {
        
        let baseURL = "https://openapi.naver.com/v1/papago/n2mt"
        var urlComponent = URLComponents(string: baseURL)

        // MARK: - Query
        let from = URLQueryItem(name: "source", value: from.getLanguage)
        let target = URLQueryItem(name: "target", value: target.getLanguage)
        let searchQuery = URLQueryItem(name: "text", value: searchKeyWord)
        let items: [URLQueryItem] = [from, target, searchQuery]
        urlComponent?.queryItems = items
        
        guard let url = urlComponent?.url else { return }
        
        // MARK: - Header
        var requestURL = URLRequest(url: url)
        requestURL.httpMethod = "POST"
        requestURL.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(Client.id.getClient, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(Client.secret.getClient, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        
        let task = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data")
                return
            }
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
            
            do {
                let res = try JSONDecoder().decode(TransData.self, from: data)
                completion(res.message.result)
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

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
