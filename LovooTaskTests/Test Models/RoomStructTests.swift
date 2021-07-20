//
//  RoomStructTests.swift
//  LovooTaskTests
//
//  Created by Ayman Ata on 7/20/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import XCTest
@testable import LovooTask

class RoomStructTests: XCTestCase {

    var sut: Room!
    var fact: LovooFact!
    
    override func setUp() {
        fact = .init(title: "work hard",
                     text: "interesting fact",
                     images: [])
        sut = .init(officeLevel: WrappedValue.init(value: "6"),
                        roomNumber: WrappedValue.init(value: "6.2-06"),
                        type: "meeting", name: "Meeting SSH6",
                        department: "all", id: "123456789",
                        lovooFact: fact)
    }

    override func tearDown() {
        fact = nil
        sut = nil
        super.tearDown()
    }

    func testRoom_name () {
        XCTAssertEqual(sut.name, "Meeting SSH6")
    }
    
    func testRoom_level() {
        XCTAssertEqual(sut.officeLevel?.value, "6")
    }
    
    func testRoom_fact() {
        XCTAssertEqual(sut.lovooFact, fact)
        
        sut.lovooFact = nil
        XCTAssertNil(sut.lovooFact)
    }
    
    func testFact_title() {
        XCTAssertEqual(fact.title, "work hard")
    }

}
