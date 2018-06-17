//
//  HomeViewController.swift
//  Proficiency-Exercise
//
//  Created by Vasim Ajmeri on 17/06/18.
//  Copyright © 2018 Vasim Ajmeri. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    

    @IBOutlet weak var tblViewHome: UITableView!
    
    let CELL_IDENTIFIRE = "homeCell"
    let API_URL         = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    var responseData    = Data()
    var homeListData    = [HomeItem]()
    var imageCache      = NSCache<NSString, UIImage>()
    var refreshControl  = UIRefreshControl()
 
    
//MARK: VIEW DELEGATES METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: Notification.Name("reloadTable"), object: nil)
        
        //setup tablview row height
        self.configTableView()
        
        //fetch data from server
        self.fetchDataFromAPI()
    }
    
    func configTableView(){
        
        // Pull to refresh tableview
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(self.fetchDataFromAPI), for: .valueChanged)
        self.tblViewHome.addSubview(refreshControl)
        
        //Dynamic row height
        self.tblViewHome.estimatedRowHeight = 100
        self.tblViewHome.rowHeight          = UITableViewAutomaticDimension
    }
    
    func setupNavigationTitle(_ title:String){
        self.title = title
    }
    
    @objc func reloadTableView(){
        DispatchQueue.main.async {//reload tablview on main thread
            self.tblViewHome.reloadData()
        }
    }
    
    
//MARK: FETCH DATA FROM API
    
    @objc func fetchDataFromAPI(){
        
        let dataUrl = URL.init(string: self.API_URL)//API URL
        
        if let dataUrl = dataUrl{//fetch optional value of url
            let dataRequest    = URLRequest.init(url: dataUrl)
            let dataConnection = NSURLConnection.init(request:dataRequest , delegate: self)
            dataConnection?.start()
        }
    }

    
//MARK: CONNECTION DELEGATE METHODS
 
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        //Request failed
        print(error.localizedDescription)
        self.refreshControl.endRefreshing()
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        //New request, clear data
        self.responseData = Data()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        //Append data while receive data
        self.responseData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        //convert data response into ISO latin
        let responseEncode = String(data: self.responseData, encoding: .isoLatin1)
        
        //string ISO latin to UT8 data
        guard let responseDataUTF8 = responseEncode?.data(using: .utf8) else {
            print("could not convert data to UTF-8 format")
            self.refreshControl.endRefreshing()
            return
        }
        
        //parse data to json
        do {
            let jsonData = try JSONDecoder().decode(HomeData.self, from: responseDataUTF8)
            
            if let strNavigationTitle =  jsonData.title {
                self.homeListData = jsonData.rows//all related data
                self.setupNavigationTitle(strNavigationTitle)//setup navigation title
                self.reloadTableView()//reload tableview data
                self.refreshControl.endRefreshing()
            }
            
        } catch let jsonError {
            print(jsonError)
            self.refreshControl.endRefreshing()
        }

    }
    
//MARK: TABLEVIEW DELEGATE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeListData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let homeItem = self.homeListData[indexPath.row]
        
        if homeItem.title == nil && homeItem.description == nil && homeItem.imageHref == nil{
            return 0.0
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIRE, for: indexPath) as! HomeViewCell
        
        let homeItem = self.homeListData[indexPath.row]
        
        //title for the cell
        if let title = homeItem.title{
            cell.lblTitle.text = title
        }else{
            cell.lblTitle.text = ""
        }
        
        //description for the cell
        if let description = homeItem.description{
            cell.lblDescription.text = description
        }else{
            cell.lblDescription.text = ""
        }
        
        //image for the cell
        if let imageLink = homeItem.imageHref{
            cell.imgView.loadImageUsingUrlString(imageLink)
        }else{
            cell.imgView.image = nil
        }
        cell.selectionStyle = .none
        
        return cell
    }


}

