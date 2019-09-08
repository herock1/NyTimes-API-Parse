//
//  ViewController.swift
//  NyTimes-Demo
//
//  Created by Herock Hasan on 18/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//Used Enum to Set TableView type
enum NewsTableType {
    
    case TopStories
    case SearchResult
    case SearchKey
}

class NyNewsViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var botomSpace: NSLayoutConstraint!
    let cellIds   = "topnews"
    var topStories : FeedModel? = nil // TopNewsfeed model json
    var searchResult : SearchJsonModel? = nil // Searchnewsfeedmodel json
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var newsSearchBar: UISearchBar!
    let service = NYTimesAPI()
    var tableType = NewsTableType.TopStories
    
    @IBOutlet weak var activityIndigator: UIActivityIndicatorView!
    
    // Fetch search data from core data
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: SearchData.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        newsTableView.estimatedRowHeight = 92
        newsTableView.delegate = self
        newsSearchBar.delegate = self
        
        do {
            try self.fetchedhResultController.performFetch()
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        // Fetch Top Stories From remote service using call back
        
        activityIndigator.startAnimating()
        service.fetchFeaturedArticles { (data, error) in
            guard let data = data else{return}
            
            do {
                
                let jsonDecoder = JSONDecoder()
                self.topStories = try jsonDecoder.decode(FeedModel.self, from: data) // Modeling json
                
                DispatchQueue.main.async {
                    self.activityIndigator.stopAnimating()
                    self.activityIndigator.hidesWhenStopped = true
                    self.newsTableView.reloadData()
                    print(self.topStories?.results![0].published_date)

                }
            }
            
            catch let err { print("Error:\(err)") }
            

        }
    }
    
// Reset Newsfeed
    @IBAction func reloadFeed(_ sender: Any) {
        
        tableType = NewsTableType.TopStories
        self.newsTableView.reloadData()
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    private func saveInCoreDataWith(searchText: String) {
        
        _ = createSearchEntityFrom(searchText: searchText)
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func createSearchEntityFrom(searchText:String) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let searchEntity = NSEntityDescription.insertNewObject(forEntityName: "SearchData", into: context) as? SearchData {
            searchEntity.searchtext = searchText
            searchEntity.time = getcurretTimeString()
            return searchEntity
        }
        return nil
    }
    
    func getcurretTimeString () -> String
    {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        let date :String = dateFormatter1.string(from: NSDate() as Date)
        return date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Searchbar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("keyboard starded")
        tableType = NewsTableType.SearchKey
        DispatchQueue.main.async {
            self.botomSpace.constant = 300
            self.newsTableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchText \(String(describing: searchBar.text))")
        if newsSearchBar.text != "" {
            self.view.endEditing(true)
            saveInCoreDataWith(searchText: newsSearchBar.text!)
            fetchSearchResult(searchkeyword: newsSearchBar.text!)
                
            }
            
        }
    

    // MARK: - Enter button Action

    @IBAction func getSearchResult(_ sender: Any) {
        
        print("searchText \(String(describing: newsSearchBar.text))")
        
        if newsSearchBar.text != "" {
        self.view.endEditing(true)
        saveInCoreDataWith(searchText: newsSearchBar.text!)
            fetchSearchResult(searchkeyword: newsSearchBar.text!)

        }

    }
    
    // MARK: - Fetch Searched News

    func fetchSearchResult (searchkeyword : String)
    {
        activityIndigator.startAnimating()
        
        service.searchArticles(query: searchkeyword) { (searchdata , error) in
            
            guard let searchdata = searchdata else{return}
            
            do {
                
                let jsonDecoder = JSONDecoder()
                self.searchResult = try jsonDecoder.decode(SearchJsonModel.self, from: searchdata)
                
                DispatchQueue.main.async {
                    self.botomSpace.constant = 0
                    self.tableType = NewsTableType.SearchResult
                    self.newsTableView.reloadData()
                    self.activityIndigator.stopAnimating()
                    self.activityIndigator.hidesWhenStopped = true
                    
                    
                }
            }
            catch let err { print("Error:\(err)") }
        }
    }
    
}


extension NyNewsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
}
}




