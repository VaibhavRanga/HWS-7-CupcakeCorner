//
//  Order.swift
//  HWS-7-CupcakeCorner
//
//  Created by Vaibhav Ranga on 01/06/24.
//

import Foundation

struct Address: Codable {
    var name: String
    var street: String
    var city: String
    var zip: String
}

@Observable
class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestsEnabled = "specialRequestsEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _street = "street"
        case _city = "city"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestsEnabled = false {
        didSet {
            if !specialRequestsEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name: String {
        didSet {
            saveAddress()
        }
    }
    
    var street: String {
        didSet {
            saveAddress()
        }
    }
    
    var city: String {
        didSet {
            saveAddress()
        }
    }
    
    var zip: String {
        didSet {
            saveAddress()
        }
    }
    
    var address = Address(name: "", street: "", city: "", zip: "")
    
    var hasValidAddress: Bool {
        if address.name.trimmingCharacters(in: .whitespaces).isEmpty || address.street.trimmingCharacters(in: .whitespaces).isEmpty || address.city.trimmingCharacters(in: .whitespaces).isEmpty || address.zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.5/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    init() {
        if let storedAddress = UserDefaults.standard.data(forKey: "address") {
            if let decodedAddress = try? JSONDecoder().decode(Address.self, from: storedAddress) {
                name = decodedAddress.name
                street = decodedAddress.street
                city = decodedAddress.city
                zip = decodedAddress.zip
                
                address = Address(name: name, street: street, city: city, zip: zip)
                return
            }
        }
        name = ""
        street = ""
        city = ""
        zip = ""
        
        address = Address(name: name, street: street, city: city, zip: zip)
    }

    func saveAddress() {
        address = Address(name: name, street: street, city: city, zip: zip)
        
        if let encodedAddress = try? JSONEncoder().encode(address) {
            UserDefaults.standard.set(encodedAddress, forKey: "address")
        }
    }
}
