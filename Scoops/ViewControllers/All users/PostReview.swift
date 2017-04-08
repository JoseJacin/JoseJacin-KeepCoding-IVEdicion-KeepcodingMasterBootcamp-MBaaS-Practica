//
//  PostReview.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class PostReview: UIViewController {
    
    //MARK: - Properties
    var post: Post!
    
    //MARK: - Outlets
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Se indica analítica de Pantalla
        FIRAnalytics.setScreenName(constants.PostReview, screenClass: "AllUsers")

        // Se deshabilitan los elementos para que no se pueda interaccionar con ellos si no se está logueado
        rateSlider.isEnabled = false
        
        if let elementPost = post,
            let currentUser = FIRAuth.auth()?.currentUser {
            titleTxt.text = elementPost.title
            postTxt.text = elementPost.desc
            
            PostModel
            
            }
        }
        
        // Se establece el valor de las valoraciones
        rateSlider.value = 3
        slideLabel.text = String(Int(rateSlider.value))
        //rateLabel.text = String(Int(rateSlider.value))
        rateLabel.text = String(Int(4))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func rateAction(_ sender: Any) {
        // Se establecen los pasos del slider para que solo se puedan seleccionar valores enteros
        rateSlider.value = roundf(rateSlider.value)
        slideLabel.text = String(Int(rateSlider.value))
        
        // En esta parte no se han indicado estadísticas ya que manda muchas
        
    }

    @IBAction func ratePost(_ sender: Any) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: "ratePost", parameters: ["posts" : "reviewposts" as NSObject])
    }
    
    //MARK: - Functions
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
