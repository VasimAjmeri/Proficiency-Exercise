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

    
//MARK: VIEW DELEGATES METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup tablview row height
        self.configTableView()
        self.fetchDataFromAPI()
    }
    
    func configTableView(){
        self.tblViewHome.estimatedRowHeight = 100
        self.tblViewHome.rowHeight          = UITableViewAutomaticDimension
    }
    
    
//MARK: FETCH DATA FROM API
    
    func fetchDataFromAPI(){
        
        let dataUrl        = URL.init(string: self.API_URL)
        
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
        
        //encode ISO latin to UT8
        guard let responseDataUTF8 = responseEncode?.data(using: .utf8) else {
            print("could not convert data to UTF-8 format")
            return
        }
        
        //parse data to json
        do {
            let jsonData = try JSONSerialization.jsonObject(with: responseDataUTF8) as? [String : Any]
            
            if let jsonData = jsonData{
                print(jsonData)//parsed data
            }
            
        } catch let jsonError {
            print(jsonError)
        }

    }
    
//MARK: TABLEVIEW DELEGATE METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        
        cell.lblTitle.text       = "My Title"
        cell.lblDescription.text = "My Description"
        cell.imgView.image       = UIImage.init(named: "placeholder")
        
        return cell
    }
    
    
    
    

}
