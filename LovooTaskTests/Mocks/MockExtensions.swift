//
//  MockExtensions.swift
//  LovooTaskTests
//
//  Created by Ayman Ata on 7/20/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit
@testable import LovooTask

extension RoomsVCTests {
    
    class NaviatorMock: Navigator {
        func navigate(to destination: Destination) { }
        func pop() { }
        func start() { }
        func logout() { }
    }
}

extension RoomCellTests {
    
    class NaviatorMock: Navigator {
        func navigate(to destination: Destination) { }
        func pop() { }
        func start() { }
        func logout() { }
    }
}

extension RoomCellTests {
    class MockRoomCellDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RoomCell.self), for: indexPath)
            return cell
        }
    }
}
