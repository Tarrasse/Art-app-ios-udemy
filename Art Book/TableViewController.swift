//
//  TableViewController.swift
//  Art Book
//
//  Created by Mahmoud El-Tarrasse on 8/14/17.
//  Copyright © 2017 Mahmoud El-Tarrasse. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    let cellId = "id"
    
    var names = [String]()
    var years = [Int]()
    var artists = [String]()
    var images = [UIImage]()
    
    var selectedPainting = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        reviveData()
    }
    
    private func reviveData(){
        names.removeAll()
        years.removeAll()
        artists.removeAll()
        images.removeAll()
        
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try context?.fetch(fetchRequest)
            if (results?.count)! > 0{
                for result in (results as? [NSManagedObject])!{
                    if let name = result.value(forKey: "name") as? String{
                        names.append(name)
                    }
                    if let year = result.value(forKey: "year") as? Int{
                        years.append(year)
                    }
                    
                    if let artist = result.value(forKey: "artist")as? String{
                        artists.append(artist)
                    }
                    if let imageData = result.value(forKey: "image") as? Data{
                        let image = UIImage(data: imageData)
                        images.append(image!)
                        
                    }
                }
            }
        }catch{
            print("retch error")
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        cell.detailTextLabel?.text = artists[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPainting = names[indexPath.row]
        performSegue(withIdentifier: "toCreate", sender: nil)
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCreate"{
            if let destVC = segue.destination as? ItemViewController{
                print(self.selectedPainting)
                destVC.chosenPainting = selectedPainting
            }
        }
    }
    

}
