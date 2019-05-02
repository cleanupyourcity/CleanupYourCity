//
//  CameraViewController.swift
//  CleanUpYourCity
//
//  Created by Ariel McCarthy on 4/25/19.
//  Copyright © 2019 Group3. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var onSubmitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCameraSubmitButton(_ sender: Any)
    {
        let picker = UIImagePickerController()
        
        // calls a function that has the photo
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
            // try with both
            picker.sourceType = .photoLibrary
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
   /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
   */
    
    
    
    
    @IBAction func onSubmitButton(_ sender: Any)
    {
         // performSegue(withIdentifier: "profileSegue", sender: nil)
        self.navigationController?.popViewController(animated: true)

    }
 
    
    
    
    /*
        @IBAction func onTap(_ sender: Any) {
            self.performSegue(withIdentifier: "ChangePic", sender: self)
    
        }
    */
    
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */

}
