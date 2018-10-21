//
//  SelfSellBookViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 26/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import Foundation
import UIKit

class SelfSellBookViewController: UIViewController, UITableViewDelegate {
    
    var customer: Customer?
    var books: [Book]?
    
    var chosenBookIndex = 0
    let searchController = UISearchController(searchResultsController: nil)
    var displayBooks: [Book]?
    var filteredBooks: [Book]?
    var owners: [Customer]?
    
    @IBOutlet weak var selfSellBookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayBooks = books?.filter{$0.owner.id != 0}
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.sizeToFit()
        selfSellBookTableView.tableHeaderView = searchController.searchBar
        self.selfSellBookTableView.delegate = self
        self.selfSellBookTableView.dataSource = self
        searchController.searchBar.scopeButtonTitles = ["All", "Mathematics", "Computer Science", "Chemistry", "Biology", "Physics"]
        searchController.searchBar.delegate = self
        self.selfSellBookTableView.reloadData()
        passDataToSell()
        passDataToBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayBooks = books?.filter{$0.owner.id != 0}
        passDataToSell()
        passDataToBook()
        self.selfSellBookTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfoSegue") {
            let destinationViewController = segue.destination as! HelpViewController
            destinationViewController.customer = customer
        }
    }
    
    func filterContent(searchText: String, scope: String = "All") {
        filteredBooks = displayBooks?.filter{ book in
            
            let category: String
            
            switch book.type {
            case 1:
                category = "Mathematics"
            case 2:
                category = "Computer Science"
            case 3:
                category = "Chemistry"
            case 4:
                category = "Biology"
            case 5:
                category = "Physics"
            default:
                category = "Unknown"
            }
            
            let match = (scope == "All") || (category == scope)
            return match && book.name.lowercased().contains(searchText.lowercased())
        }
        selfSellBookTableView.reloadData()
    }
    
    func passDataToSell() {
        let tabBarVC = self.tabBarController?.viewControllers?[3]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! SellViewController
        destinationViewController.books = books
    }
    
    func passDataToBook() {
        let tabBarVC = self.tabBarController?.viewControllers?[0]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! BookViewController
        destinationViewController.books = books
    }
    
    func showSelfSellBookDetailAlert(owner: Customer) {
        let bookInfoAlert = UIAlertController(title: "Note", message: "The book is owned by \(owner.name), whose contact number is: \(owner.tel). Please contact us after you buy it. Thank you!", preferredStyle: UIAlertControllerStyle.alert)
        bookInfoAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel))
        self.present(bookInfoAlert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let owner = owners![(indexPath as NSIndexPath).row]
        showSelfSellBookDetailAlert(owner: owner)
        self.selfSellBookTableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
    }
}

extension SelfSellBookViewController: LoginDelegate {
    func passCustomerData(customer: Customer) {
        self.customer = customer
    }
}

extension SelfSellBookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBooks!.count
        } else {
            return displayBooks!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        owners = []
        
        if searchController.isActive && searchController.searchBar.text != "" {
            for book in filteredBooks! {
                owners?.append(book.owner)
            }
        } else {
            for book in displayBooks! {
                owners?.append(book.owner)
            }
        }
        
        let cellIdentifier = "selfSellBookCell"
        let cell = selfSellBookTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        let book: Book
        if searchController.isActive && searchController.searchBar.text != "" {
            book = filteredBooks![(indexPath as NSIndexPath).row]
        } else {
            book = displayBooks![(indexPath as NSIndexPath).row]
        }
        
        cell.imageView?.image = book.image
        cell.textLabel?.text = book.name
        if (customer?.type == 2 || customer?.type == 3) {
            cell.detailTextLabel?.text = "Discount Price: \(book.discountPrice)HKD"
        } else {
            cell.detailTextLabel?.text = "Price: \(book.price)HKD"
        }
        
        return cell
    }
    
    
}

extension SelfSellBookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContent(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension SelfSellBookViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
