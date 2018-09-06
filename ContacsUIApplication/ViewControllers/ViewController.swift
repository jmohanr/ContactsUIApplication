//
//  ViewController.swift
//  ContacsUIApplication
//
//  Created by Jagan Mohan on 05/09/18.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var artistList = [DataModel]()
    var searchedList = [DataModel]()
    var contacts: [NSManagedObject] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

//MARK:- ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        callingApi ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchingContactsData()
    }
    
//MARK:- Handling TableView Data Sources
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as! ContactsTableViewCell
        let candy = artistList[indexPath.row]
        cell.nameLabel.text = candy.name
        cell.phoneNumberLabel.text = candy.emailId
        if let myValue = candy.imageUrl as String?   {
            if (myValue.isEmpty) {
                let data = UIImagePNGRepresentation(UIImage(named: "Profile")!)
                let decodedimage:UIImage = UIImage(data: data!)!
                cell.profileImage.image = decodedimage
            } else {
                let dataDecoded:NSData = NSData(base64Encoded: myValue, options: NSData.Base64DecodingOptions(rawValue: 0))!
                let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                cell.profileImage.image = decodedimage
            }
        }
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2
        cell.profileImage.layer.masksToBounds = true
        
        return cell
    }
    
}


extension ViewController: UISearchBarDelegate,UISearchDisplayDelegate {
    //MARK:- UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        if (text == "") {
            artistList = searchedList
            tableView.reloadData()
        } else {
            searchThroughdata()
        }
    }
    func searchThroughdata() {
        artistList = searchedList.filter { ($0.name?.lowercased().contains(searchBar.text!.lowercased()))! }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        artistList = searchedList
        tableView.reloadData()
    }
    
    
  //MARK:- Storing Country codes and names to coredata
    func callingApi () {
        let query = "https://restcountries.eu/rest/v1/all"
        APIService.fetchingCountryCodes(url: query) { (result) in
            guard result.count > 0 else { return  }
            var countryCode = ""
            for i in 0..<result.count {
                let dicts = result[i]
                let name = dicts["name"]
                
                if let array = dicts["callingCodes"] as? [AnyObject] {
                    for name in array{
                        countryCode = name as! String
                    }
                }
                CoreData.savingContryCodes(entityName: "Contacts",countryCode:countryCode,countryName:name as! String)
            }
            DispatchQueue.main.async {
              self.fetchingContactsData()
                
            }
        }
    }
    
    //MARK:- fetching contacts from core data
    func fetchingContactsData() {
         self.contacts = CoreData.fetchDetailsFormDb(entityName:"PersonDetails")
        self.artistList.removeAll()
        for i in 0..<self.contacts.count {
            let name = self.contacts[i].value(forKey: "name")
            let imageUrl = self.contacts[i].value(forKey: "profileImage")
            let emailId = self.contacts[i].value(forKey: "emailId")
            let artist = DataModel.init(name: name as? String, emailId: emailId as? String, imageUrl: imageUrl as? String)
            self.artistList.append(artist)
        }
        print(self.artistList)
        DispatchQueue.main.async {
            self.searchedList = self.artistList
            self.tableView.reloadData()
        }
    }
}

