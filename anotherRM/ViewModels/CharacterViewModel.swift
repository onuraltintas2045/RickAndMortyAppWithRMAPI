

import Foundation

class CharacterViewModel{
    let getCharacterFromPageAPIinstance = getCharacterFromPageAPI()
    var charactersWithEpisodeNumbers: [Character] = []
    var currentPage: Int = 1
    var totalPageCount: Int = 0
    var newEpisodes: [String] = []
    let pageCountSemaphore = DispatchSemaphore(value: 0)
    let charactersSemaphore = DispatchSemaphore(value: 0)
    
    func fetchCharactersPagesCount(completion: @escaping (Error?) -> Void){
        getPageCountAPI.fetchCharactersPagesCount { result in
            switch result {
            case .success(let myInfo):
                let info = myInfo.info
                self.totalPageCount = info.pages
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
        
    }
    
    func fetchCharacters(completion: @escaping (Error?) -> Void) {
        getCharacterFromPageAPI.fetchCharacters(urlPath: String(currentPage)) { result in
            switch result {
            case .success(let characterResponse):
                let characters = characterResponse.results
                self.episodeWithOutURL(with: characters)
                if self.currentPage <= self.totalPageCount{
                    self.currentPage += 1
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    private func episodeWithOutURL(with characters: [Character]) {
        for ch in characters {
            newEpisodes = []
            for ep in ch.episode {
                if let epNumber = self.extractEpisodeNumber(from: ep) {
                    newEpisodes.append(epNumber)
                }
            }
            var updatedCharacter = ch
            updatedCharacter.episode = newEpisodes
            charactersWithEpisodeNumbers.append(updatedCharacter)
        }
    }
    
    private func extractEpisodeNumber(from url: String) -> String? {
        if let lastPathComponent = URL(string: url)?.lastPathComponent {
            return lastPathComponent
        }
        return nil
    }
    
    func getDataFromPageCountAPI(completion: @escaping () -> Void){
        self.fetchCharactersPagesCount { error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                completion()
            } else {
                completion()
            }
            
        }
        
    }
    
    func getDataFromCharactersAPI(completion: @escaping () -> Void){
        self.fetchCharacters { error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                completion()
            } else {
                completion()
            }
            
        }
    }
}
