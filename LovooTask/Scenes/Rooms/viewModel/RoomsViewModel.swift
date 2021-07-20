//
//  RoomsViewModel.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CoreData
import Alamofire

class RoomsViewModel {
    private let disposeBag: DisposeBag = .init()
    private let networkManager: NetworkManager = .init()
    private let coreDataManager: CoreDataManager = .init()
    private var rooms: BehaviorRelay<[Room]> = .init(value: [])
    var roomsToPresent: BehaviorRelay<[Room]> = .init(value: [])
    var departmentOptions: BehaviorRelay<[String]> = .init(value: [])
    var typeOptions: BehaviorRelay<[String]> = .init(value: [])
    
    func viewDidLoad() {
        fetchRooms()
    }
    
    private func fetchRooms() {
        let keyChainManager: KeyChainManager = .init()
        guard let passData = keyChainManager.fetchWith(key: LVConstant.passwordKey),
            let usernameData = keyChainManager.fetchWith(key: LVConstant.usernameKey) else { return }
        
        var headers: HTTPHeaders
        let password = String(data: passData, encoding: .utf8)
        let username = String(data: usernameData, encoding: .utf8)
        headers = [.authorization(username: username ?? "",
                                  password: password ?? "")]
        
        networkManager.getObjects(ofType: [Room].self, headers: headers )
            .subscribe(onNext: { [weak self] (fetchedRooms) in
            var rooms = [Room]()
            for room in fetchedRooms {
                var newRoom = room
                newRoom.bookable = self?.getBookable(for: room.id ?? "")
                rooms.append(newRoom)
            }
            self?.rooms.accept(rooms)
            self?.setupOptions()
            self?.roomsToPresent.accept(rooms)
            
        }, onError: { (err) in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    private func getBookable(for id: String) -> Bookable? {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Bookable>.init(entityName: "Bookable")
        fetchRequest.predicate = NSPredicate.init(format: "id == %@", id)
        do {
            let bookings = try context.fetch(fetchRequest)
            guard let book = bookings.first else { return nil }
            return book
        } catch let err {
            print("couldn't fetch data ---> \(err)")
        }
        return nil
    }
    
    private func setupOptions() {
        var departmentOptions: Set<String> = []
        var typeOptions: Set<String> = []
        for room in rooms.value {
            if let department = room.department {
                departmentOptions.insert(department)
            }
            if let type = room.type {
                typeOptions.insert(type)
            } else if let type = room.typ {
                typeOptions.insert(type)
            }
        }
        var allDepartmentOptions = Array(departmentOptions)
        allDepartmentOptions.insert(LVConstant.allDeparts, at: 0)
        self.departmentOptions.accept(allDepartmentOptions)
        
        var allTypeOptions = Array(typeOptions)
        allTypeOptions.insert(LVConstant.allTypes, at: 0)
        self.typeOptions.accept(allTypeOptions)
    }
    
    
    func filterFor(department: String, type: String) {
        
        if department == LVConstant.allDeparts &&
            type == LVConstant.allTypes {
            roomsToPresent.accept(rooms.value)
        } else if department == LVConstant.allDeparts {
            roomsToPresent.accept(
                rooms.value.filter({ $0.type == type || $0.typ == type }))
            
        } else if type == LVConstant.allTypes {
            roomsToPresent.accept(
                rooms.value.filter({ $0.department == department }))
        } else {
            self.roomsToPresent.accept(
                rooms.value
                    .filter({ $0.department == department })
                    .filter({ $0.type == type || $0.typ == type })
            )
        }
    }
}
