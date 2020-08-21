//
//  Order.swift
//  HotCoffee
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
  case cappuccino
  case latte
  case lattee
  case espressino
  case cortado
}

enum CoffeeSize: String, Codable, CaseIterable {
  case small
  case medium
  case large
}

struct Order: Codable {
  let name: String
  let email: String
  let type: CoffeeType
  let size: CoffeeSize
}

extension Order {
  static var all: Resource<[Order]> = {
    guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
      fatalError("No URL")
    }
    
    return Resource<[Order]>(url: url)
  }()
  
  static func create(order: Order?) -> Resource<Order?> {
    guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
      fatalError("No URL")
    }
    
    guard let data = try? JSONEncoder().encode(order) else {
      fatalError("Error encoding")
    }
    
    var resource = Resource<Order?>(url: url)
    
    resource.httpMethod = .post
    resource.body = data
    
    return resource
  }
}
