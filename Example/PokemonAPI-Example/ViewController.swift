//
//  ViewController.swift
//  PokemonAPI-Example
//
//  Created by Christopher Jennewein on 6/30/18.
//  Copyright © 2018 Prismatic Games. All rights reserved.
//

import UIKit
import PokemonAPI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Example of calling a web service using an ID
        PokemonAPI.moveService.fetchMove(1) { result in
            switch result {
            case .success(let move):
                print(move)
            case .failure(let error):
                print(error.message)
            }
        }
        
        
        // Example of calling a web service using a name
        PokemonAPI.pokemonService.fetchPokemon("bulbasaur") { result in
            switch result {
            case .success(let pokemon):
                print(pokemon)
            case .failure(let error):
                print(error.message)
            }
        }
        
        
        // Example of fetching a PKMNamedAPIResource (or PKMAPIResource)
        PokemonAPI.gameService.fetchPokedex(14) { result in
            switch result {
            case .success(let pokedex):
                print(pokedex.name!) // kalos-mountain
                
                PokemonAPI.resourceService.fetch(pokedex.region!) { result in
                    switch result {
                    case .success(let region):
                        print(region.name!) // kalos
                    case .failure(let error):
                        print(error.message)
                    }
                }
                
            case .failure(let error):
                print(error.message)
            }
        }
        
        
        // Example of calling a paginated web service, then taking the first result and fetching the underlying resource
        PokemonAPI.berryService.fetchBerryList() { result in
            switch result {
            case .success(let pagedBerries):
                print(pagedBerries)
                if let berryResource = pagedBerries.results?.first {
                    
                    // Fetching the underlying PKMBerry resource
                    PokemonAPI.resourceService.fetch(berryResource) { result in
                        switch result {
                        case .success(let berry):
                            print(berry.name!) // cheri
                        case .failure(let error):
                            print(error.message)
                        }
                    }
                }
            case .failure(let error):
                print(error.message)
            }
        }
        

        // Example of calling a paginated web service with a pageLimit, then using the pagedObject to fetch the next page in the list
        PokemonAPI.utilityService.fetchLanguageList(paginationState: .initial(pageLimit: 5)) { result in
            switch result {
            case .success(let pagedLanguages):
                print(pagedLanguages)
                print("Language count: \(pagedLanguages.count!)") // Language count: 12

                PokemonAPI.utilityService.fetchLanguageList(paginationState: .continuing(pagedLanguages, .next)) { result in
                    switch result {
                    case .success(let pagedLanguagesNext):
                        print(pagedLanguagesNext)
                        print("Language page: \(pagedLanguagesNext.currentPage)") // Language page: 1
                    case .failure(let error):
                        print(error.message)
                    }
                }
            case .failure(let error):
                print(error.message)
            }
        }
    }

}

