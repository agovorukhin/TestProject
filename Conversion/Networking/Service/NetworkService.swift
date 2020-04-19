//
//  NetworkService.swift
//  Conversion
//
//  Created by Александр Говорухин on 16.04.2020.
//  Copyright © 2020 Александр Говорухин. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void)
    func getRate(_ currPair: String, completion: @escaping (Result<Double, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let apiKey = "9ca8a51b690874852b73"
    
    func getCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = getURL(.currencies) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let jsonData = data else {
                completion(.failure(error!))
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: jsonData)
                let currencies = response.results.map { $1 }
                completion(.success(currencies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getRate(_ currPair: String,
                 completion: @escaping (Result<Double, Error>) -> Void) {
        guard let url = getURL(.convert, currPair) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let jsonData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Double]
                if let value = json?.values.first {
                    completion(.success(value))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getURL(_ action: Direction, _ currPair: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free.currconv.com"
        components.path = "/api/v7/" + action.rawValue
        switch action {
        case .currencies:
            components.queryItems = [
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        case .convert:
            guard let currPair = currPair else { return nil }
            components.queryItems = [
                URLQueryItem(name: "q", value: currPair),
                URLQueryItem(name: "compact", value: "ultra"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
        }
        return components.url
    }
}
