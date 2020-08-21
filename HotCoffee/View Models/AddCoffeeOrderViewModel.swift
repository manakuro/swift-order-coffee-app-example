//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
  var name: String?
  var email: String?
  
  var selectedType: String?
  var selectedSize: String?
  
  var types: [String] {
    CoffeeType.allCases.map { $0.rawValue.capitalized }
  }
  
  var sizes: [String] {
    CoffeeSize.allCases.map { $0.rawValue.capitalized }
  }
}

extension AddCoffeeOrderViewModel {
  func toModel() -> Order? {
        guard
      let name = self.name,
      let email = self.email,
      let selectedType = CoffeeType(rawValue: self.selectedType!.lowercased()),
      let selectedSize = CoffeeSize(rawValue: self.selectedSize!.lowercased()) else {
      return nil
    }
    
    return Order(
      name:  name,
      email: email,
      type: selectedType,
      size: selectedSize
    )
  }
}
