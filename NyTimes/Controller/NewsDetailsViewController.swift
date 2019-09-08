//
//  NewsDetailsViewController.swift
//  NyTimes-Demo
//
//  Created by Herock Hasan on 20/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//


/*
 From NyNewsviewcontroller we send current index parameter based on left and right swipe we increase and decrease current index and load corresponding news here using webview.
 As the api didn't provide total news so here we are showing details news using webview
 
 When swipe index going last setting to base and when going to base setting to top index so here circular swiping enabled
 
 */
import UIKit
import  AVFoundation
import AVKit
class NewsDetailsViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var newswebview: UIWebView!
    
    var tableType : NewsTableType?
        var topStoriesJsonModel : FeedModel? = nil
    var searchResultJsonModel : SearchJsonModel? = nil
    var currentIndex : Int?
   var avPlayerController = AVPlayerViewController()
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newswebview.delegate = self
        
        //Left Swipe
       var swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeleft(sender:)))
        swipeleft.direction = .left
        view.addGestureRecognizer(swipeleft)
           //Right Swipe
        var swiperight = UISwipeGestureRecognizer(target: self, action:#selector(swiperight(sender:)))
        swiperight.direction = .right
        view.addGestureRecognizer(swiperight)
        
    
        loadnews(newsIndex: currentIndex!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if avPlayerController.isBeingDismissed {
            avPlayerController.player = nil
        }
    }
    
    @objc func swiperight(sender: UITapGestureRecognizer) {
        // Do what u want here
       

        currentIndex = currentIndex! - 1
        
        if tableType == NewsTableType.TopStories {
            
            if currentIndex! <  0 {
                
                currentIndex = (topStoriesJsonModel?.results?.count)! - 1
            }
            
        }
        else
        {
            if currentIndex! <  0 {
                
                currentIndex = (searchResultJsonModel?.response?.docs?.count)! - 1
            }
        }
        
        loadnews(newsIndex: currentIndex!)
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.layer.add(transition, forKey: nil)
        view.addSubview(newswebview)
    }
    
    @objc func swipeleft(sender: UITapGestureRecognizer? = nil) {
        // Do what u want here
        currentIndex = currentIndex! + 1
        
        if tableType == NewsTableType.TopStories {
            
            if currentIndex! ==  (topStoriesJsonModel?.results?.count)! - 1 {
                
                currentIndex = 0
            }
            
        }
        else
        {
            if currentIndex! ==  (searchResultJsonModel?.response?.docs?.count)! - 1 {
                
                currentIndex = 0
            }
        }
        loadnews(newsIndex: currentIndex!)
        
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: nil)
        view.addSubview(newswebview)
    }
    
    func loadnews(newsIndex : Int)
    {
        
        activityLoader.startAnimating()
        
        var urlString : String = ""
        if tableType == NewsTableType.TopStories {
            urlString = (topStoriesJsonModel?.results?[newsIndex].url)!
        }
        else
        {
            urlString = (searchResultJsonModel?.response?.docs?[newsIndex].web_url)!
        }
        newswebview.loadRequest(URLRequest(url: URL(string: urlString)!))

    }
    
 
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //handle the callback here when page load completes
        self.activityLoader.stopAnimating()
        self.activityLoader.hidesWhenStopped = true

    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
