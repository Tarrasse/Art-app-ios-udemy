//
//  ItemViewController.swift
//  Art Book
//
//  Created by Mahmoud El-Tarrasse on 8/14/17.
//  Copyright © 2017 Mahmoud El-Tarrasse. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var planingYear: UITextField!
    
    var chosenPainting = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(ItemViewController.selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        if chosenPainting != ""{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenPainting)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context?.fetch(fetchRequest)
                if (results?.count)! > 0{
                    for result in results as! [NSManagedObject]{
                        if let name  = result.value(forKey: "name") as? String{
                             nameTextField.text = name
                            
                        }
                        if let year = result.value(forKey: "year") as? Int{
                            planingYear.text = String(year)
                        }
                        
                        if let artist = result.value(forKey: "artist")as? String{
                            artistTextField.text = artist
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                        
                    }
                }
            }catch{
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func save(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context!)
        newArt.setValue(nameTextField.text, forKey: "name")
        newArt.setValue(artistTextField.text, forKey: "artist")
        if let intyear = Int(planingYear.text!){
            newArt.setValue(intyear, forKey: "year")
        }
        
        
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        newArt.setValue(data, forKey: "image")
        
        do{
            try context?.save()
            navigationController?.popViewController(animated: true)

            print("saved")
        }catch{
            print("error saving the data")
        }

    }


    func selectImage(){
        let picker  = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
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
