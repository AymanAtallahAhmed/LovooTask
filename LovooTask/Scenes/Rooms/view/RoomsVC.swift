//
//  RoomsVC.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RoomsVC: UIViewController, UIScrollViewDelegate {

    private let viewModel: RoomsViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private let navigator: Navigator
    lazy private var headerView: UIView = .init()
    lazy private var departmentOptionBtn = LVDropDownButton.init(frame: .zero)
    lazy private var typeOptionBtn = LVDropDownButton.init(frame: .zero)
    
    @IBOutlet weak var tableView: UITableView!
    
    init(navigator: Navigator) {
        self.navigator = navigator
        super.init(nibName: "RoomsVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupRightBarButton()
        setupTableView()
        navigationItem.title = "Rooms"
        setStatusBar(color: .systemPurple)
        setupOptionButtons()
        bind()
    }
    
    private func setupRightBarButton() {
        let rightBarButton: UIBarButtonItem = .init(title: "Logout",
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(logOutBtnTapped))
        rightBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func logOutBtnTapped() {
        let alertController: UIAlertController = .init(title: "LogOut !",
                                                       message: "Are you sure you want to logout",
                                                       preferredStyle: .alert)
        let cancelAction: UIAlertAction = .init(title: "Cancel", style: .cancel)
        let okAction: UIAlertAction = .init(title: "Ok", style: .default) { [weak self] (_) in
            self?.navigator.logout()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.registerNIB(cell: RoomCell.self)
        tableView.rowHeight = 125
        
        headerView.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 70)
        headerView.backgroundColor = .systemBackground
        tableView.tableHeaderView = headerView
        
        tableView.rx.modelSelected(Room.self)
            .subscribe(onNext: { [weak self] model in
                if model.type == "meeting" ||
                    model.typ == "meeting" {
                    self?.navigator.navigate(to: .bookRoomVC(room: model))
                } else if let fact = model.lovooFact {
                    self?.navigator.navigate(to: .detailedRooomVC(fact: fact))
                }
        }).disposed(by: disposeBag)
    }
    
    private func bind() {
        viewModel.roomsToPresent.bind(to: tableView.rx.items(cellIdentifier: String(describing: RoomCell.self), cellType: RoomCell.self)) { index, model, cell in
            cell.room = model
        }.disposed(by: disposeBag)
        
        viewModel.departmentOptions.subscribe(onNext: { [weak self] options in
            self?.departmentOptionBtn.options = options
        }).disposed(by: disposeBag)
        
        viewModel.typeOptions.subscribe(onNext: { [weak self] options in
            self?.typeOptionBtn.options = options
        }).disposed(by: disposeBag)
    }
    
    private func setupOptionButtons() {
        [departmentOptionBtn, typeOptionBtn].forEach({ (button) in
            button.backgroundColor = .systemPink
            button.setView(corner: 6)
            view.addSubview(button)
        })
        
        NSLayoutConstraint.activate([
            departmentOptionBtn.heightAnchor.constraint(equalToConstant: 40),
            departmentOptionBtn.topAnchor.constraint(equalTo: tableView.tableHeaderView!.topAnchor, constant: 10),
            departmentOptionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            departmentOptionBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -25),
            
            typeOptionBtn.heightAnchor.constraint(equalToConstant: 40),
            typeOptionBtn.topAnchor.constraint(equalTo: departmentOptionBtn.topAnchor),
            typeOptionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            typeOptionBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
        ])
        
        departmentOptionBtn.setTitle(LVConstant.allDeparts, for: .normal)
        typeOptionBtn.setTitle(LVConstant.allTypes, for: .normal)
        
        departmentOptionBtn.itemSelectedCompletion = { [weak self] item in
            self?.viewModel.filterFor(department: item, type: (self?.typeOptionBtn.title(for: .normal)!)!)
        }
        
        typeOptionBtn.itemSelectedCompletion = { [weak self] item in
            self?.viewModel.filterFor(department: (self?.departmentOptionBtn.title(for: .normal)!)!, type: item)
        }
    }
}
