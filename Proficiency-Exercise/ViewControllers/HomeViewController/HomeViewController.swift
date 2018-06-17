//
//  HomeViewController.swift
//  Proficiency-Exercise
//
//  Created by Vasim Ajmeri on 17/06/18.
//  Copyright © 2018 Vasim Ajmeri. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tblViewHome: UITableView!
    
    let cellIdentifier = "homeCell"
    
    
//MARK: VIEW DELEGATES METHODS

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup tablview row height
        self.configTableView()
    }
    
    func configTableView(){
        self.tblViewHome.estimatedRowHeight = 100
        self.tblViewHome.rowHeight          = UITableViewAutomaticDimension
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! HomeViewCell
        
        cell.lblTitle.text       = "My Title"
        cell.lblDescription.text = "My Description"
        cell.imgView.image       = UIImage.init(named: "placeholder")
        
        return cell
    }
    
    
    
    

}
