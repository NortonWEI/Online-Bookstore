//
//  PeripheralViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

class PeripheralViewController: UIViewController, UITableViewDelegate {
    
    var customer: Customer?
    var peripherals: [Peripheral]?
    
    let ballPen = Peripheral(id: 1, name: "Ball Pen", price: 10.99, imageName: "Ball Pen", type: 1)
    let calculator = Peripheral(id: 2, name: "Calculator", price: 223.83, imageName: "Calculator", type: 2)
    let correctionFluid = Peripheral(id: 3, name: "Correction Fluid", price: 15.95, imageName: "Correction Fluid", type: 1)
    let cup = Peripheral(id: 4, name: "Cup", price: 89.42, imageName: "Cup", type: 3)
    let earphone = Peripheral(id: 5, name: "Earphone", price: 345.12, imageName: "Earphone", type: 2)
    let eraser = Peripheral(id: 6, name: "Eraser", price: 8.88, imageName: "Eraser", type: 1)
    let handkerchief = Peripheral(id: 7, name: "Handkerchief", price: 35.63, imageName: "Handkerchief", type: 3)
    let jacket = Peripheral(id: 8, name: "Jacket", price: 674.64, imageName: "Jacket", type: 4)
    let keyboard = Peripheral(id: 9, name: "Keyboard", price: 389.28, imageName: "Keyboard", type: 2)
    let notebook = Peripheral(id: 10, name: "Notebook", price: 30.52, imageName: "Notebook", type: 1)
    let portableDisk = Peripheral(id: 11, name: "Portable Disk", price: 322.52, imageName: "Portable Disk", type: 2)
    let postcard = Peripheral(id: 12, name: "Postcard", price: 9.35, imageName: "Postcard", type: 3)
    let ruler = Peripheral(id: 13, name: "Ruler", price: 4.48, imageName: "Ruler", type: 1)
    let scarf = Peripheral(id: 14, name: "Scarf", price: 213.53, imageName: "Scarf", type: 4)
    let trousers = Peripheral(id: 15, name: "Trousers", price: 320.98, imageName: "Trousers", type: 4)
    
    var chosenPeripheralIndex = 0
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPeripherals: [Peripheral]?
    
    @IBOutlet weak var peripheralTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripherals = [ballPen, calculator, correctionFluid, cup, earphone, eraser, handkerchief, jacket, keyboard, notebook, portableDisk, postcard, ruler, scarf, trousers]
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.sizeToFit()
        peripheralTableView.tableHeaderView = searchController.searchBar
        self.peripheralTableView.dataSource = self
        searchController.searchBar.scopeButtonTitles = ["All", "Stationery", "Digital", "Living", "Clothing"]
        searchController.searchBar.delegate = self
        self.peripheralTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.peripheralTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfoSegue") {
            let destinationViewController = segue.destination as! HelpViewController
            destinationViewController.customer = customer
        } else if (segue.identifier == "showPeripheralSegue") {
            let indexPathForSelectedRow = self.peripheralTableView.indexPathForSelectedRow!
            chosenPeripheralIndex = (indexPathForSelectedRow as NSIndexPath).row
            
            let destinationViewController = segue.destination as! PeripheralDetailViewController
            let peripheral: Peripheral
            if searchController.isActive && searchController.searchBar.text != "" {
                peripheral = filteredPeripherals![chosenPeripheralIndex]
            } else {
                peripheral = peripherals![chosenPeripheralIndex]
            }
            self.searchController.isActive = false
            self.peripheralTableView.cellForRow(at: indexPathForSelectedRow)?.selectionStyle = UITableViewCellSelectionStyle.none
            
            destinationViewController.peripheral = peripheral
            destinationViewController.peripherals = peripherals
            destinationViewController.peripheralIndex = chosenPeripheralIndex
            destinationViewController.customer = customer
        }
    }
    
    @IBAction func unwindToPeripheralViewController(segue: UIStoryboardSegue) {}
}

extension PeripheralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPeripherals!.count
        } else {
            return peripherals!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "peripheralCell"
        let cell = peripheralTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        let peripheral: Peripheral
        if searchController.isActive && searchController.searchBar.text != "" {
            peripheral = filteredPeripherals![(indexPath as NSIndexPath).row]
        } else {
            peripheral = peripherals![(indexPath as NSIndexPath).row]
        }
        cell.imageView?.image = UIImage(named: peripheral.imageName)
        cell.textLabel?.text = peripheral.name
        if (customer?.type == 1 || customer?.type == 2) {
            cell.detailTextLabel?.text = "Discount Price: \(peripheral.discountPrice)HKD"
        } else {
            cell.detailTextLabel?.text = "Price: \(peripheral.price)HKD"
        }
        
        return cell
    }
    
    func filterContent(searchText: String, scope: String = "All") {
        filteredPeripherals = peripherals?.filter{ peripheral in
            
            let category: String
            
            switch peripheral.type {
            case 1:
                category = "Stationery"
            case 2:
                category = "Digital"
            case 3:
                category = "Living"
            case 4:
                category = "Clothing"
            default:
                category = "Unknown"
            }
            
            let match = (scope == "All") || (category == scope)
            return match && peripheral.name.lowercased().contains(searchText.lowercased())
        }
        peripheralTableView.reloadData()
    }
}

extension PeripheralViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContent(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension PeripheralViewController: LoginDelegate {
    func passCustomerData(customer: Customer) {
        self.customer = customer
    }
}

extension PeripheralViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
