//
//  ProfileVC.swift
//  Ascol
//
//  Created by Jamel Reid  on 5/2/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTxtField: UITextField!
    
    var profile: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        username.text = profile.name
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getprofileImage()
    }
    
    func getprofileImage() {
        
        if profile.imageUrl != "" {
            let ref = FIRStorage.storage().reference(forURL: profile.imageUrl)
            
            if let img = ProfileVC.imageCache.object(forKey: profile.imageUrl as NSString) {
                self.profileImage.image = img
            } else {
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("AN ERROR!!!!!!!!!!!!")
                    } else {
                        print("Image DOWNLOADED!!!!!!!!!!!!!!!!!!!!")
                        if let imgData = data {
                            if let image = UIImage(data: imgData) {
                                self.profileImage.image = image
                                ProfileVC.imageCache.setObject(image, forKey: self.profile.imageUrl as NSString)
                            }
                        }
                    }
                    
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let userId: String = (FIRAuth.auth()?.currentUser?.uid)!
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if let imageData = UIImageJPEGRepresentation(image, 0.2) {
                let imageUid = NSUUID().uuidString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.REF_POST_IMAGES.child(imageUid).put(imageData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("Cannot upload to firebase ========>")
                    } else {
                        print("Uploaded to Fireabse!!!!!!!!!!")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        print(downloadURL!)
                        DataService.ds.REF_USERS.child("\(userId)/imageURL").setValue(downloadURL!)
                        self.profileImage.image = image
                    }
                }
            }
            
        } else {
            print("Image wasnt Selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        let userId: String = (FIRAuth.auth()?.currentUser?.uid)!
        DataService.ds.REF_USERS.child("\(userId)/name").setValue(usernameTxtField.text)
    }
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful == true {
            do {
                try FIRAuth.auth()?.signOut()
                performSegue(withIdentifier: "SignOut", sender: nil)
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }
    }
    
    

}
