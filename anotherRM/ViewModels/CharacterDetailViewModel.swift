//
//  CharacterDetailViewModel.swift
//  anotherRM
//
//  Created by Onur on 2.09.2023.
//

import Foundation


class CharacterDetailViewModel{
    var characterEpisodes: [Episode] = []
    let getEpisodesFromAPIinstance = getEpisodesFromAPI ()
    let getEpisodePageCountinsatance = getEpisodePageCount()
    var newEpisodes: [String] = []
    let episodeSemaphore = DispatchSemaphore(value: 0)
    let episodePageCountSemaphore = DispatchSemaphore(value: 0)
    var episodeNames: [String] = []
    var totalPageCount: Int = 0
    var currentPageCount: Int = 1
    
    
    func fetchEpisodePagesCount(completion: @escaping (Error?) -> Void){
        getEpisodePageCount.fetchEpisodesPagesCount { result in
            switch result {
            case .success(let myInfo):
                let info = myInfo.info
                self.totalPageCount = info.pages
                print("pageler düzgün alındı")
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func fetchEpisodes(completion: @escaping (Error?) -> Void){
        getEpisodesFromAPI.fetchEpisodes(pageNumber: String(currentPageCount)) { result in
            switch result {
            case .success(let episoderesponse):
                let episodes = episoderesponse.results
                self.episodeCharactersWithOutURL(with: episodes)
                self.currentPageCount += 1
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func episodeCharactersWithOutURL(with characters: [Episode]) {
        for ch in characters {
            newEpisodes = []
            for ep in ch.characters {
                if let epNumber = self.extractCharacterNumber(from: ep) {
                    newEpisodes.append(epNumber)
                }
            }
            var updatedCharacter = ch
            updatedCharacter.characters = newEpisodes
            characterEpisodes.append(updatedCharacter)
        }

    }
    
    private func extractCharacterNumber(from url: String) -> String? {
        if let lastPathComponent = URL(string: url)?.lastPathComponent {
            return lastPathComponent
        }
        return nil
    }
    
    func getPageFromEpisodeAPI(completion: @escaping () -> Void){
        self.fetchEpisodePagesCount() { error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
            } else {
                completion()
            }
            
        }
    }
    
    func getDataFromEpisodeAPI(characterId: Int, completion: @escaping () -> Void) {
        let group = DispatchGroup()
            
        group.enter()
        fetchEpisodesRecursively(characterId: characterId) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }

    private func fetchEpisodesRecursively(characterId: Int, completion: @escaping () -> Void) {
        guard currentPageCount <= totalPageCount else {
            episodesForView(characterID: String(characterId))
            completion()
            return
        }

        fetchEpisodes { error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                completion()
            } else {
                self.fetchEpisodesRecursively(characterId: characterId, completion: completion)
            }
        }
    }

    
    func episodesForView (characterID: String){
        episodeNames = []
        for episode in characterEpisodes{
            for ch in episode.characters{
                if characterID == ch{
                    episodeNames.append(episode.episode)
                }
            }
        }
    }
}
