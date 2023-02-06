//
//  NetworkService.swift
//  M18
//
//  Created by Даниил Попов on 07.01.2023.
//

import Foundation

class NetworkService {
    
        
    func request(urlString: String, complition: @escaping (Result<ImdbFilm, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    complition(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let films = try JSONDecoder().decode(ImdbFilm.self, from: data)
                    complition(.success(films))
                }
                catch let jsonErorr {
                    print("Failed to decode JSON", jsonErorr)
                     complition(.failure(jsonErorr))
                }
            }
        } .resume()
    }

    
}
