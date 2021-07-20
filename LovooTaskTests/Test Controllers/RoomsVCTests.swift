//
//  RoomsVCTests.swift
//  LovooTaskTests
//
//  Created by Ayman Ata on 7/20/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import LovooTask

class RoomsVCTests: XCTestCase {

    var sut: RoomsVC!
    var navigatorMock: Navigator!
    
    override func setUp() {
        navigatorMock = NaviatorMock.init()
        sut = RoomsVC.init(navigator: navigatorMock)
        sut.loadView()
    }

    override func tearDown() {
        sut = nil
        navigatorMock = nil
        super.tearDown()
    }

    // MARK: Nil Checks
    func testLibraryVC_TableViewShouldNotBeNil() {
        XCTAssertNotNil(sut.tableView)
    }
    
    // MARK: selected row
    func test_itemSelected() {
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        var resultIndexPath: IndexPath? = nil
        
        let subscription = tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                resultIndexPath = indexPath
            })
        
        let testRow = IndexPath(row: 1, section: 0)
        tableView.delegate!.tableView!(tableView, didSelectRowAt: testRow)
        
        XCTAssertEqual(resultIndexPath, testRow)
        subscription.dispose()
    }

}
