//
//  NetworkManager.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire

class NetworkManager {
    private let endPoint = "https://europe-west1-lv-trialwork.cloudfunctions.net/lovooOffice"
    
    func getObjects<T: Codable>(ofType type: T.Type,
                                parameters: [String: String]? = nil,
                                headers: HTTPHeaders? = nil,
                                method: HTTPMethod = .get ) -> Observable<T> {
        
        return Observable.create { [weak self] (observer) -> Disposable in
            
            guard let self = self,
                let url = URL(string: self.endPoint) else {
                return Disposables.create()
            }
//            let headers: HTTPHeaders = [.authorization(username: "lovooTrialUser",
//                                                       password: "lovoo#2021")]
            
            _ = json(method,
                     url,
                     parameters: parameters,
                     encoding: URLEncoding.default,
                     headers: headers)
                .subscribe(onNext: { (response) in
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: response)
                        let decoder: JSONDecoder = .init()
                        //decoder.keyDecodingStrategy = .useDefaultKeys
                        let result = try decoder.decode(T.self, from: jsonData)
                        observer.onNext(result)
                    } catch {
                        //observer.onError(GHError.invalidData)
                    }
                }, onError: { err in
                    //observer.onError(GHError.invalidResponse)
                })
            return Disposables.create()
        }
    }
}
