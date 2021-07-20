//
//  BookRoomViewModel.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/16/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class BookRoomViewModel {
    private let coreDataManager: CoreDataManager = .init()
    private let disposeBag: DisposeBag = .init()
    var bookable: ReplaySubject<Bookable> = .createUnbounded()
    
    func addEditBookable(bookingCase: BookingStatus,
                         id: String,
                         day: String,
                         startHour: String,
                         endHour: String) {
        let context = coreDataManager.persistentContainer.viewContext
        
        switch bookingCase {
        case .add:
            let bookableElement = NSEntityDescription.insertNewObject(forEntityName: "Bookable", into: context)
            bookableElement.setValue(id, forKey: "id")
            bookableElement.setValue(day, forKey: "day")
            bookableElement.setValue(startHour, forKey: "startHour")
            bookableElement.setValue(endHour, forKey: "endHour")
            coreDataManager.save()
        case .edit:
            bookable.subscribe(onNext: { [weak self] bookable in
                bookable.day = day
                bookable.endHour = endHour
                bookable.startHour = startHour
                self?.coreDataManager.save()
                })
                .disposed(by: disposeBag)
        }
    }
    
    func deleteBookableWith(id: String) {
        bookable.subscribe(onNext: { [weak self] bookable in
            self?.coreDataManager.persistentContainer.viewContext.delete(bookable)
            self?.coreDataManager.save()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData(for id: String) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Bookable>.init(entityName: "Bookable")
        fetchRequest.predicate = NSPredicate.init(format: "id == %@", id)
        
        do {
            let bookings = try context.fetch(fetchRequest)
            guard let bookable = bookings.first else { return }
            self.bookable.onNext(bookable)
        } catch let err {
            print("couldn't fetch data ---> \(err)")
        }
    }
}

enum BookingStatus {
    case add
    case edit
}
