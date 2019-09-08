//
//  NyNewsViewController+ShowNews.swift
//  NyTimes-Demo
//
//  Created by Herock Hasan on 9/6/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NyNewsViewController : UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if (tableType == NewsTableType.TopStories)
        {
            guard topStories != nil  else {
                return 0;
            }
            
            print(topStories?.results?.count)
            return (topStories?.results?.count)!
        }
        else if (tableType == NewsTableType.SearchResult)
        {
            guard searchResult != nil  else {
                return 0;
            }
            
            print(topStories?.results?.count)
            return (searchResult?.response?.docs?.count)!
        }
            
        else
        {
            if let count = fetchedhResultController.sections?.first?.numberOfObjects {
                if count>10
                {
                    return 10
                }
                else
                {
                    return count
                }
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableType == NewsTableType.TopStories {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIds, for: indexPath) as! NewsCell
            cell.newscategory.text = topStories?.results?[indexPath.row].section
            cell.newsTitle.text =  topStories?.results?[indexPath.row].title
            cell.newsDetails.text = topStories?.results?[indexPath.row].abstract
            cell.newsdate.text = topStories?.results?[indexPath.row].published_date
            
            if self.topStories?.results?[indexPath.row].media?.count != 0
            {
            DispatchQueue.main.async {
                
                if let url = self.topStories?.results?[indexPath.row].media?[0].media_metadata?[1].url {
                    cell.newImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
                }
            }
            }
            
            return cell
        }
        else if tableType == NewsTableType.SearchResult
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIds, for: indexPath) as! NewsCell
            cell.newscategory.text = searchResult?.response?.docs?[indexPath.row].document_type
            cell.newsTitle.text =  searchResult?.response?.docs?[indexPath.row].headline?.main
            cell.newsDetails.text = searchResult?.response?.docs?[indexPath.row].snippet
            cell.newsdate.text = searchResult?.response?.docs?[indexPath.row].pub_date
            
            DispatchQueue.main.async {
                
                //                guard (self.searchResult?.response?.docs?[indexPath.row].multimedia) != nil else{return}
                if (self.searchResult?.response?.docs?[indexPath.row].multimedia?.count)! > 0
                {
                    var urlString : String = "https://www.nytimes.com/" + (self.searchResult?.response?.docs?[indexPath.row].multimedia?[0].url)!
                    cell.newImageView.loadImageUsingCacheWithURLString(urlString, placeHolder: UIImage(named: "placeholder"))
                }
                
                
            }
            return cell
        }
            
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! SearchKeyCell
            if let searchInfo = fetchedhResultController.object(at: indexPath) as? SearchData
            {
                cell.searchKeyword.text = searchInfo.searchtext
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        if tableType == NewsTableType.TopStories
        {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "newsdetails") as! NewsDetailsViewController
            detailsViewController.tableType = NewsTableType.TopStories
            detailsViewController.topStoriesJsonModel = topStories
            detailsViewController.currentIndex = indexPath.row
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        else if tableType == NewsTableType.SearchResult
        {
            let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "newsdetails") as! NewsDetailsViewController
            detailsViewController.tableType = NewsTableType.SearchResult
            detailsViewController.searchResultJsonModel = searchResult
            detailsViewController.currentIndex = indexPath.row
            self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
        else
        {
            let currentCell = tableView.cellForRow(at: indexPath) as! SearchKeyCell
            
            if currentCell.searchKeyword.text != "" {
                self.view.endEditing(true)
                fetchSearchResult(searchkeyword: currentCell.searchKeyword.text!)
            }
        }
    }
}
