//
//  BookRoomVC.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/16/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookRoomVC: UIViewController {
    
    private let viewModel: BookRoomViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private let navigator: Navigator
    private var room: Room
    
    @IBOutlet weak var dayTF: UITextField!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    init(room: Room, navigator: Navigator) {
        self.room = room
        self.navigator = navigator
        super.init(nibName: "BookRoomVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData(for: room.id ?? "")
        bind()
        setupUI()
        setStatusBar(color: .systemPurple)
    }
    
    private func setupUI() {
        navigationItem.title = "Book Room '\(room.name ?? "")'"
        confirmButton.setTitle(room.bookable == nil ? "Book" : "Update" , for: .normal)
        deleteButton.isHidden = room.bookable == nil
        [dayTF, fromTF, toTF, confirmButton]
            .forEach({ $0?.setView(corner: 12) })
        deleteButton.setView(corner: 24)
    }
    
    private func bind() {
        viewModel.bookable.subscribe(onNext: { [weak self] (bookable) in
            self?.room.bookable = bookable
            self?.dayTF.text = bookable.day
            self?.fromTF.text = bookable.startHour
            self?.toTF.text = bookable.endHour
        })
        .disposed(by: disposeBag)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard let day = dayTF.text, day != "",
            let startHour = fromTF.text, startHour != "",
            let endHour = toTF.text, endHour != "" else { return }
        let bookingCase: BookingStatus = room.bookable != nil ? .edit : .add
        
        viewModel.addEditBookable(bookingCase: bookingCase,
                                  id: room.id ?? "",
                                  day: day,
                                  startHour: startHour,
                                  endHour: endHour)
        [dayTF, fromTF, toTF].forEach({ $0?.resignFirstResponder() })
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.deleteBookableWith(id: room.id ?? "")
        deleteButton.isHidden = true
        confirmButton.setTitle("Book", for: .normal)
        [dayTF, fromTF, toTF].forEach({ $0?.text?.removeAll() })
    }
}
