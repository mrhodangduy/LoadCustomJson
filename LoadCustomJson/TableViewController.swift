//
//  TableViewController.swift
//  LoadCustomJson
//
//  Created by Paul on 7/19/17.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var arrayCustomers = Array<NSManagedObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.reloadData()
        
    }
    
    @IBAction func loadJson(_ sender: Any) {
        
        
        var textfiled:String!
        
        let alert = UIAlertController(title: "Link JSON", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            
            tf.placeholder = "input your JSON link"
        }
        
        let btnOK = UIAlertAction(title: "GET", style: .default) { (action) in

            textfiled = alert.textFields?[0].text
            self.saveJsonToCoreData(jsonLink:textfiled)
            print(self.arrayCustomers.count)
            self.tableView.reloadData()
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(btnOK)
        alert.addAction(btnCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteAllData(_ sender: Any) {
        
        self.deleteAllData()
        tableView.reloadData()
        
    }
    func deleteAllData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let rq = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        let rqBatch = NSBatchDeleteRequest(fetchRequest: rq)
        do {
            try context.execute(rqBatch)
            try context.save()
            self.arrayCustomers.removeAll()
            self.tableView.reloadData()
        } catch
        {
            
        }
        
    }
    
    func loadData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let rq = NSFetchRequest<NSFetchRequestResult>(entityName: "Customers")
        
        do {
            arrayCustomers =  try context.fetch(rq) as! [NSManagedObject]
        } catch  {
            
        }
        
    }
    
    func saveData(id: Int, name: String, email: String, phone: String,job:String, avatarlink: String){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Customers", in: context)
        
        let customer = NSManagedObject(entity: entity!, insertInto: context)
        
        customer.setValue(id, forKey: "id")
        customer.setValue(name, forKey: "name")
        customer.setValue(email, forKey: "email")
        customer.setValue(phone, forKey: "phone")
        customer.setValue(job, forKey: "job")
        customer.setValue(avatarlink, forKey: "avatar")
        
        do {
            try context.save()
            self.arrayCustomers.append(customer)
        } catch  {
            
        }
    }
    
    func saveJsonToCoreData(jsonLink: String){
        
        let url = URL(string: jsonLink)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, respone, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                if let content = data {
                    
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! Array<[String:AnyObject]>
                        
                        for i in 0...myJson.count-1{
                            
                            let id = myJson[i]["id"] as! Int
                            let name = myJson[i]["name"] as! String
                            let phone = myJson[i]["phone"] as! String
                            let job = myJson[i]["job"] as! String
                            let avatarlink = myJson[i]["avatar"] as! String
                            let email = myJson[i]["email"] as! String
                            
                            self.saveData(id: id, name: name, email: email, phone: phone, job: job, avatarlink: avatarlink)
                            
                        }
                    }
                    catch{
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayCustomers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let customer = arrayCustomers[indexPath.row]
        let image = customer.value(forKey: "avatar") as? String
        
        cell.lblname.text = customer.value(forKey: "name") as? String
        cell.lblid.text = String(describing: (customer.value(forKey: "id") as? Int)!)
        cell.lblemail.text = customer.value(forKey: "email") as? String
        cell.lblphone.text = customer.value(forKey: "phone") as? String
        cell.lbljob.text = customer.value(forKey: "job") as? String
        
        let queue = DispatchQueue(label: "load_anh", qos: .background, attributes: .concurrent, autoreleaseFrequency: .never, target: nil)
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = cell.imgAvatar.center
        cell.addSubview(indicator)
        
        queue.async {
            indicator.startAnimating()
            do {
                let url = URL(string: image!)
                let imgData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.imgAvatar.image = UIImage(data: imgData)
                    indicator.stopAnimating()
                }
            }catch{
                
            }
        }
        
        return cell
    }
    
}
