//
//  BookViewController.swift
//  Online Bookstore
//
//  Created by WEI Wenzhou on 23/11/2016.
//  Copyright © 2016 WEI Wenzhou. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, UITableViewDelegate {
    
    var customer: Customer?
    var books: [Book]?
    
    let linearAlgebra = Book(id: 1, name: "Linear Algebra", price: 287.25, newBook: false, image: UIImage(named: "Linear Algebra")!, type: 1, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let swiftProgramming = Book(id: 2, name: "iOS 10 Swift Programming", price: 217.46, newBook: true, image: UIImage(named: "Swift Programming")!, type: 2, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let organicChemistry = Book(id: 3, name: "Organic Chemistry", price: 264.71, newBook: true, image: UIImage(named: "Organic Chemistry")!, type: 3, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let zoology = Book(id: 4, name: "Integrated Principles of Zoology", price: 290.79, newBook: true, image: UIImage(named: "Zoology")!, type: 4, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let mechanism = Book(id: 5, name: "Mechanisms and Mechanical Devices Sourcebook", price: 325.77, newBook: true, image: UIImage(named: "Mechanism")!, type: 5, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let java = Book(id: 6, name: "Java: Beginner", price: 289.75, newBook: false, image: UIImage(named: "Java")!, type: 2, owner: Customer(id: 3, name: "WEI Wenzhou", uni: "HKBU", type: 2, imageName: "nortonAvatar", username: "13252542", password: "wenzhou", tel: "3411 7892"))
    let learningPython = Book(id: 7, name: "Learning Python", price: 364.51, newBook: true, image: UIImage(named: "Learning Python")!, type: 2, owner: Customer(id: 5, name: "HO Yee Hung", uni: "HKBU", type: 2, imageName: "hoYeeHungAvatar", username: "13212214", password: "yeehung", tel: "3411 5678"))
    let botanyInADay = Book(id: 8, name: "Botany in a Day", price: 246.85, newBook: false, image: UIImage(named: "Botany in a Day")!, type: 4, owner: Customer(id: 7, name: "LEUNG Wing Tung", uni: "HKBU", type: 2, imageName: "defaultAvatar", username: "14212781", password: "wingtung", tel: "3411 5696"))
    let optics = Book(id: 9, name: "Introduction to Modern Optics", price: 117.50, newBook: false, image: UIImage(named: "Optics")!, type: 5, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let inorganicChemistry = Book(id: 10, name: "Inorganic Chemistry", price: 771.52, newBook: false, image: UIImage(named: "Inorganic Chemistry")!, type: 3, owner: Customer(id: 4, name: "WANG Yan", uni: "HKBU", type: 2, imageName: "wangYanAvatar", username: "13251112", password: "yan", tel: "3411 7983"))
    let geometry = Book(id: 11, name: "Geometry: A Comprehensive Course", price: 140.45, newBook: false, image: UIImage(named: "Geometry")!, type: 1, owner: Customer(id: 0, name: "Administrator", uni: "HKBU", type: 0, imageName: "defaultAvatar", username: "admin", password: "admin", tel: "3411 7457"))
    let cPPProgramming = Book(id: 12, name: "The C++ Programming Language", price: 436.09, newBook: false, image: UIImage(named: "CPP")!, type: 2, owner: Customer(id: 6, name: "YEUNG Yee Mei", uni: "HKBU", type: 2, imageName: "yeungYeeMeiAvatar", username: "13215191", password: "yeemei", tel: "3411 7895"))
    
    var chosenBookIndex = 0
    let searchController = UISearchController(searchResultsController: nil)
    var displayBooks: [Book]?
    var filteredBooks: [Book]?
    
    @IBOutlet weak var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        books = [linearAlgebra, java, inorganicChemistry, botanyInADay, optics, swiftProgramming, geometry, organicChemistry, learningPython, zoology, mechanism, cPPProgramming]
        displayBooks = books?.filter{$0.owner.id == 0}
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.hidesBottomBarWhenPushed = true
        searchController.hideKeyboardWhenTappedAround()
        searchController.searchBar.sizeToFit()
        bookTableView.tableHeaderView = searchController.searchBar
        self.bookTableView.dataSource = self
        searchController.searchBar.scopeButtonTitles = ["All", "Mathematics", "Computer Science", "Chemistry", "Biology", "Physics"]
        searchController.searchBar.delegate = self
        self.bookTableView.reloadData()
        passDataToSell()
        passDataToSelfSellBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayBooks = books?.filter{$0.owner.id == 0}
        passDataToSell()
        passDataToSelfSellBook()
        self.bookTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfoSegue") {
            let destinationViewController = segue.destination as! HelpViewController
            destinationViewController.customer = customer
        } else if (segue.identifier == "showBookDetailSegue") {
            let indexPathForSelectedRow = self.bookTableView.indexPathForSelectedRow!
            chosenBookIndex = (indexPathForSelectedRow as NSIndexPath).row
            
            let destinationViewController = segue.destination as! BookDetailViewController
            let book: Book
            if searchController.isActive && searchController.searchBar.text != "" {
                book = filteredBooks![chosenBookIndex]
            } else {
                book = displayBooks![chosenBookIndex]
            }
            self.searchController.isActive = false
            self.bookTableView.cellForRow(at: indexPathForSelectedRow)?.selectionStyle = UITableViewCellSelectionStyle.none
            
            destinationViewController.books = books
            destinationViewController.book = book
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
        bookTableView.reloadData()
    }
    
    func passDataToSell() {
        let tabBarVC = self.tabBarController?.viewControllers?[3]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! SellViewController
        destinationViewController.books = books
    }
    
    func passDataToSelfSellBook() {
        let tabBarVC = self.tabBarController?.viewControllers?[1]
        let navigationVC = tabBarVC! as! UINavigationController
        let destinationViewController = navigationVC.topViewController as! SelfSellBookViewController
        destinationViewController.books = books
    }
    
    @IBAction func unwindToBookViewController(segue: UIStoryboardSegue) {}
}

extension BookViewController: LoginDelegate {
    func passCustomerData(customer: Customer) {
        self.customer = customer
    }
}

extension BookViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBooks!.count
        } else {
            return displayBooks!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "bookCell"
        let cell = bookTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
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
        if (!book.newBook) {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
}

extension BookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContent(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension BookViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
