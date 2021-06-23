//
//  MainPageFactory.swift
//  RaboParser
//
//  Created by Andrei Ivanou2 on 6/20/21.
//

import UIKit

protocol MainPageFactoryProtocol {
    func make(parsingService: ParsingServiceProtocol, completion: @escaping (UserFlowEvent) -> Void ) -> UIViewController
}

class MainPageFactory: MainPageFactoryProtocol {
    
    func make(parsingService: ParsingServiceProtocol, completion: @escaping (UserFlowEvent) -> Void) -> UIViewController {
        let presenter = MainPagePresenter(parsingService: parsingService, completion: completion)
        let view = MainPageView(presenter: presenter)

        presenter.view = view
 
        return view
    }
}
