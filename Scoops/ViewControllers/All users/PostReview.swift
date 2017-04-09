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
        FIRAnalytics.setScreenName(constants.PostReview, screenClass: constants.AllUsers)

        // Se deshabilitan los elementos para que no se pueda interaccionar con ellos si no se está logueado
        rateSlider.isEnabled = false
        
        if let elementPost = post {
            
            titleTxt.text = elementPost.title
            postTxt.text = elementPost.desc
            
            rateSlider.isHidden = false
            slideLabel.isHidden = false
            
            if let currentUser = FIRAuth.auth()?.currentUser {
                    PostModel.getUserRatingPost(post: elementPost.cloudRef!, user: currentUser.uid, completion: { (rating) in
                        self.rateSlider.value = Float(rating)
                        self.rateSlider.isEnabled = true
                        self.slideLabel.text = String(Int(rating))
                    })
            
            } else {
                rateSlider.isHidden = true
                slideLabel.isHidden = true
            }
            imagePost.imageFromServerURL(urlString: elementPost.photo)
            
            if post.cumulativeRating != 0 && post.numRatings != 0 {
                rateLabel.text = String(post.cumulativeRating / post.numRatings)
            }
        }
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
        
        // Se valida si hay un post instanciado y un usuario logado
        if let elementPost = post,
            let currentUser = FIRAuth.auth()?.currentUser {
            
            // Se indica estadística de acción
            FIRAnalytics.logEvent(withName: constants.RatePost, parameters: [constants.ActionPosts : constants.ReviewPosts as NSObject])
            
            // Se guarda la valoración
            PostModel.uploadRatingUserPost(postCloudRef: elementPost.cloudRef!, userid: currentUser.uid, ratingValue: Int(rateSlider.value), completion: { (result) in
                print(result.description)
            })
        }
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
