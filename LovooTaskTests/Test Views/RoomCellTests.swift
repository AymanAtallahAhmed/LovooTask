//
//  RoomCellTests.swift
//  LovooTaskTests
//
//  Created by Ayman Ata on 7/20/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import XCTest
@testable import LovooTask

class RoomCellTests: XCTestCase {

    var tableView: UITableView!
    var mockDataSource: MockRoomCellDataSource!
    var navigatorMock: Navigator!
    
    var room: Room!
    
    override func setUp() {
        navigatorMock = NaviatorMock.init()
        let roomsVC = RoomsVC.init(navigator: navigatorMock)
        roomsVC.loadView()
        setupRoom()
        
        tableView = roomsVC.tableView
        tableView.registerNIB(cell: RoomCell.self)
        mockDataSource = .init()
        tableView.dataSource = mockDataSource
    }
    
    private func setupRoom() {
        let fact: LovooFact = .init(title: "work hard",
                                    text: "interesting fact",
                                    images: [])
        room = .init(officeLevel: WrappedValue.init(value: "6"),
                    roomNumber: WrappedValue.init(value: "6.2-06"),
                    type: "meeting", name: "Meeting SSH6",
                    department: "all", id: "123456789",
                    lovooFact: fact)
    }

    override func tearDown() {
        tableView = nil
        mockDataSource = nil
        navigatorMock = nil
        super.tearDown()
    }

    func testCell_Config_ShouldSetLabelsToRoomData() {
        let zeroIndex: IndexPath = .init(row: 0, section: 0)
        let cell = tableView.dataSource?.tableView(tableView,
                                                   cellForRowAt: zeroIndex) as! RoomCell
        
        cell.room = room
        
        XCTAssertEqual(cell.roomLabel.text, room.name)
        XCTAssertEqual(cell.levelLabel.text, room.officeLevel?.value)
        XCTAssertEqual(cell.departmentLabel.text, room.department)
    }

}
