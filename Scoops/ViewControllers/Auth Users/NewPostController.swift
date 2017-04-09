//
//  NewPostController.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Properties
    var isReadyToPublish: Bool = false
    var imageCaptured: UIImage! {
        didSet {
            imagePost.image = imageCaptured
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var titlePostTxt: UITextField!
    @IBOutlet weak var textPostTxt: UITextField!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Se indica analítica de Pantalla
        FIRAnalytics.setScreenName(constants.NewPostController, screenClass: constants.AuthUsers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func takePhoto(_ sender: Any) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.TakePhoto, parameters: [constants.ActionCamera : constants.NewPost as NSObject])
        
        self.present(pushAlertCameraLibrary(), animated: true, completion: nil)
    }
    
    @IBAction func publishAction(_ sender: Any) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.PublishPostAction, parameters: [constants.ActionPosts : constants.NewPost as NSObject])
        
        isReadyToPublish = (sender as! UISwitch).isOn
    }

    @IBAction func savePostInCloud(_ sender: Any) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.SavePostInCloud, parameters: [constants.ActionPosts : constants.NewPost as NSObject])
        
        // Se instancia un nuevo Post
        let post = Post(title: self.titlePostTxt.text!,
                        desc: self.textPostTxt.text!,
                        lat: "", //Todavía no se ha implementado la parte de la localicación
                        lng: "", // Todavía no se ha implementado la parte de la localicación
                        published: self.isReadyToPublish,
                        userid: (FIRAuth.auth()?.currentUser?.uid.description)!, //Más adelante se enlazará con el objeto User, de momento se usar el userUid de Firebase
                        email: (FIRAuth.auth()?.currentUser?.email)!)
        
        // Se instancia un objeto data para almacenar la imagen asociada
        var data = Data.init()
        if let image = imagePost.image,
            let imageData = UIImagePNGRepresentation(image) {
            data = imageData
        }
        
        doneButton.isEnabled = false
        PostModel.uploadPost(post: post, imageData: data) { (result) in
            print(result.description)
            self.doneButton.isEnabled = true
            self.navigationController?.popViewController(animated: true)
        }
    
    }

    //MARK: - === Functions ===
    //MARK: Functions for Camera
    internal func pushAlertCameraLibrary() -> UIAlertController {
        let actionSheet = UIAlertController(title: NSLocalizedString(constants.PushAlertCameraActionMessage, comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        
        let libraryBtn = UIAlertAction(title: NSLocalizedString(constants.PushAlertCameraActionLibrary, comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.photoLibrary)
            
        }
        let cameraBtn = UIAlertAction(title: NSLocalizedString(constants.PushAlertCameraActionCamera, comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.camera)
            
        }
        let cancel = UIAlertAction(title: NSLocalizedString(constants.PushAlertCameraActionCancel, comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryBtn)
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(cancel)
        
        return actionSheet
    }
    
    internal func takePictureFromCameraOrLibrary(_ source: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                return
            }
        case .photoLibrary:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        case .savedPhotosAlbum:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(picker, animated: true, completion: nil)
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

//# MARK: - === Extensions ===
//# MARK: UIImagePickerController Delegate
extension NewPostController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageCaptured = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismiss(animated: false, completion: {
        })
    }
    
}












