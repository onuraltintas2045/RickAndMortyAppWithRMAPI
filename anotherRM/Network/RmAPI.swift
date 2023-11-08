//
//  RmAPI.swift
//  anotherRM
//
//  Created by Onur on 5.09.2023.
//

import Foundation

class getPageCountAPI {
    static func fetchCharactersPagesCount(completion: @escaping (Result<InfoResponse, Error>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let infoResponse = try decoder.decode(InfoResponse.self, from: data)
                completion(.success(infoResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

class getCharacterFromPageAPI {
    
    static func fetchCharacters(urlPath: String, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        let basedURL: String = "https://rickandmortyapi.com/api/character/?page="
        guard let url = URL(string: basedURL + urlPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let characterResponse = try decoder.decode(CharacterResponse.self, from: data)
                completion(.success(characterResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


class getEpisodesFromAPI{
    static func fetchEpisodes(pageNumber : String, completion: @escaping (Result<EpisodeResult, Error>) -> Void) {
        let baseUrl: String = "https://rickandmortyapi.com/api/episode?page="
        guard let url = URL(string: baseUrl + pageNumber) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let episodeResponse = try decoder.decode(EpisodeResult.self, from: data)
                completion(.success(episodeResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


class getEpisodePageCount{
    
    static func fetchEpisodesPagesCount(completion: @escaping (Result<InfoResponse, Error>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/episode") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let infoResponse = try decoder.decode(InfoResponse.self, from: data)
                completion(.success(infoResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
