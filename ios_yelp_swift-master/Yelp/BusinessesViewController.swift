//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false

    override func viewDidLoad() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate=self;

        navigationItem.titleView = searchBar
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int)->Int{
        if filteredBusinesses != nil {
            return filteredBusinesses!.count
        }
        else {
            return 0
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchBar.endEditing(true)

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //    NSLog("searchBar")
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredBusinesses = businesses
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            // NSLog("searchBar1")
            filteredBusinesses = businesses!.filter({(dataItem: Business) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let str:String = dataItem.name!
                if str.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
            
        }
        tableView.reloadData()
    }

    func loadMoreData() {
        print("loadMoreData");
        print(businesses.count)
        // ... Create the NSURLRequest (myRequest) ...
        Business.searchWithTermMore(businesses.count, term: "Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses.appendContentsOf(businesses)
            self.filteredBusinesses = self.businesses
            self.isMoreDataLoading = false
            print(self.businesses.count)
            self.tableView.reloadData()
         
        })
        // Configure session so that completion handler is executed on main UI thread
//        let session = NSURLSession(
//            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
//            delegate:nil,
//            delegateQueue:NSOperationQueue.mainQueue()
//        )
//        
//        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
//            completionHandler: { (data, response, error) in
//                
//                // Update flag
//
//                // ... Use the new data to update the data source ...
//                
//                // Reload the tableView now that there is new data
//                self.myTableView.reloadData()
//        });
//        task.resume()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                loadMoreData()

            }
        }
        // Handle scroll behavior here
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
       // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.selectionStyle = .None

        cell.business = filteredBusinesses[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
