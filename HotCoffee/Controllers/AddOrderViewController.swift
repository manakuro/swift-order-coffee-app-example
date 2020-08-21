//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Copyright © 2020 manato. All rights reserved.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
  func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
  func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  
  private var vm = AddCoffeeOrderViewModel()
  private var conffeeSizesSegmentedControl: UISegmentedControl!
  
  var delegate: AddCoffeeOrderDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  private func setupUI() {
    self.conffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
    self.conffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(self.conffeeSizesSegmentedControl)
    
    // activate constraints
    self.conffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
    self.conffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.vm.types.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell  = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
    
    cell.textLabel?.text = self.vm.types[indexPath.row]
    return cell
  }
  
  @IBAction func close() {
    if let delegate = self.delegate {
      delegate.addCoffeeOrderViewControllerDidClose(controller: self)
    }
  }
  
  // Click
  @IBAction func save() {
    let name = self.nameTextField.text
    let email = self.emailTextField.text
    
    let selectedSize = self.conffeeSizesSegmentedControl.titleForSegment(at: self.conffeeSizesSegmentedControl.selectedSegmentIndex)
    
    guard let indexPath = self.tableView.indexPathForSelectedRow else {
      fatalError("No Select Coffee")
    }
    
    self.vm.name = name
    self.vm.email = email
    
    self.vm.selectedSize = selectedSize
    self.vm.selectedType = self.vm.types[indexPath.row]
    
    let orderModel = self.vm.toModel()
    
    WebService().load(resource: Order.create(order: orderModel)) { result in
      switch result {
      case .success(let order):
        if let order = order, let delegate = self.delegate {
          delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
        }
        
          
      case .failure(let error):
          print(error)
      }
    }
  }
}
