//
//  Room.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import Foundation

struct Room: Codable {
    var officeLevel: WrappedValue?
    var roomNumber: WrappedValue?
    var type: String?
    var name, department, id: String?
    var lovooFact: LovooFact?
    var typ: String?
    var bookable: Bookable?
    
    enum CodingKeys: String, CodingKey {
        case officeLevel = "officeLevel"
        case roomNumber = "roomNumber"
        case type = "type"
        case name = "name"
        case department = "department"
        case id = "id"
        case lovooFact = "lovooFact"
        case typ = "typ"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        officeLevel = try values.decodeIfPresent(WrappedValue.self, forKey: .officeLevel)
        roomNumber = try values.decodeIfPresent(WrappedValue.self, forKey: .roomNumber)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        lovooFact = try values.decodeIfPresent(LovooFact.self, forKey: .lovooFact)
        typ = try values.decodeIfPresent(String.self, forKey: .typ)
    }
    
    init(officeLevel: WrappedValue,
         roomNumber: WrappedValue,
         type: String,
         name: String,
         department: String,
         id: String,
         lovooFact: LovooFact?) {
        self.officeLevel = officeLevel
        self.roomNumber = roomNumber
        self.type = type
        self.name = name
        self.department = department
        self.id = id
        self.lovooFact = lovooFact
    }
}

// MARK: - LovooFact
struct LovooFact: Codable, Equatable {
    let title, text: String
    let images: [String]
}

// MARK: - Wrapped Value 
struct WrappedValue: Codable {
    var value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = String(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            value = String(doubleValue)
        } else {
            value = try container.decode(String.self)
        }
    }
    
    init(value: String) {
        self.value = value
    }
}
