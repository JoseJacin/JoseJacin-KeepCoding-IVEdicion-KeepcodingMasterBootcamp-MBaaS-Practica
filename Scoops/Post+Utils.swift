//
//  PostModel.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 8/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Properties
var removeObserverValue : Bool = false

// Se hace una referencia al documento Post mediante el nombre de la clase
let posts = FIRDatabase.database().reference().child(Post.className)

class PostModel{
    
    //MARK: - === Funcions ===
    //MARK: == Post ==
    //MARK: Recover Posts
    // Revisando por la red se recomienda realizar un manejador para cada consulta que se quiera realizar.
    // Cada manejador llamará a una función fetch que será la que recupere los datos
    
    // Función manejadora que recupera los post publicados ("published" : true)
    class func recoverPost(event: FIRDataEventType, completion: @escaping typealiases.PostsList){
        let query = posts.queryOrdered(byChild: constants.published).queryEqual(toValue : true)
        fetch(query: query, event: event) { (posts) in
            completion(posts)
        }
    }
    
    // Función manejadora que recupera los post del usuario logado ("userid" : userid)
    class func recoverUserPost(event: FIRDataEventType, userId: String, completion: @escaping typealiases.PostsList){
        let query = posts.queryOrdered(byChild: constants.userid).queryEqual(toValue : userId)
        
        fetch(query: query, event: event) { (posts) in
            completion(posts)
        }
    }
    
    // Función que realiza la consulta contra Firebase Database
    private class func fetch(query: FIRDatabaseQuery, event: FIRDataEventType, completion: @escaping typealiases.PostsList){
        // Se recuperan los datos de Firebase Database
        query.observe(event, with: { (snapshot) in

            var model: [Post] = []
            
            // Se recuperan todos los datos hijos que se encuentran
            for child in snapshot.children {
                if let snapshot = child as? FIRDataSnapshot, snapshot.hasChildren() {
                    let post = Post.init(snapshot: snapshot)
                    model.append(post)
                }
            }
            
            model.sort(by: { $0.creationDate > $1.creationDate })
            DispatchQueue.main.async {
                completion(model)
            }
            
        }) { (error) in
            completion([])
        }
    }
    
    //MARK: Save Post
    // Función que guarda el post
    class func uploadPost(post: Post, imageData: Data, completion: @escaping typealiases.OperationCallbacks) {
        
        uploadImage(imageData: imageData as NSData) { (photo) in
            
            if photo != "" {
                post.photo = photo
            }
            
            let key = posts.childByAutoId().key
            let postInFB = ["\(key)": post.toDict()]
            posts.updateChildValues(postInFB)
            
            DispatchQueue.main.async {
                completion(Callbacks(done: true, message: "Post saved"))
            }
        }
    }
    
    //MARK: Delete Post
    // Función que elimina el post
    class func deletePost(post: Post, completion: @escaping typealiases.OperationCallbacks){
        posts.child(post.cloudRef!).removeValue(completionBlock: { (error, ref) in
            
            var ret = Callbacks(done: true, message: "Post deleted")
            if let error = error {
                ret = Callbacks(done: false,message: error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion(ret)
            }
        })
    }
    
    //MARK: Publish Post
    // Función que publica el post
    class func publishPost(postId: String, completion: @escaping typealiases.OperationCallbacks){
        
        posts.child(postId).child(constants.published).setValue(true)
        
        completion(Callbacks(done: true, message: "Post published"))
        
    }
    
    //MARK: - == Posts Ratings ==
    //MARK: Get User Rating
    // Función que recupera la valoración que el usuario logado ha realizado sobre el post
    class func getUserRatingPost(post: String, user: String, completion: @escaping (Int) -> ()){
        
        let query = posts.child(post).child(constants.ratings).child(user)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            query.removeAllObservers()
            
            DispatchQueue.main.async {
                if !(snapshot.value is NSNull) {
                    completion(snapshot.value as! Int)
                }else{
                    completion(0)
                }
            }
        })
    }
    
    //MARK: Save User Rating
    // Función que guarda la valoración que el usuario logado ha realizado sobre el post
    class func uploadRatingUserPost(postCloudRef: String, userid: String, ratingValue: Int,  completion: @escaping typealiases.OperationCallbacks){
        
        let postFetch = posts.child(postCloudRef)
        
        let rating = ["\(userid)": ratingValue]
        postFetch.child(constants.ratings).updateChildValues(rating)
        
        postFetch.observeSingleEvent(of: .value, with: { (snapshot) in
            
            postFetch.removeAllObservers()
            
            if snapshot.hasChildren() {
                let post_firebase = Post.init(snapshot: snapshot)
                
                //TODO -- ESTO LO TENDRIA QUE HACER EL BACKEND!!!
                post_firebase.numRatings = 0
                post_firebase.cumulativeRating = 0
                if let ratings = post_firebase.ratings {
                    for rating in ratings {
                        post_firebase.numRatings += 1
                        post_firebase.cumulativeRating += rating.rating
                    }
                }
                
                posts.child(postCloudRef).child(constants.numRatings).setValue(post_firebase.numRatings)
                posts.child(postCloudRef).child(constants.cumulativeRating).setValue(post_firebase.cumulativeRating)
                
                DispatchQueue.main.async {
                    completion(Callbacks(done: true, message: "Rating saved"))
                }
            }
        })
    }
    
    //MARK: - == Image ==
    //MARK: Save Image
    // Función que guarda la imagen asociada al post
    private class func uploadImage(imageData: NSData, completion: @escaping (String) -> ()){
        
        if imageData.length == 0 {
            completion("")
        }else{
            let storage = FIRStorage.storage()
            let postImages = storage.reference().child(Post.className)
            let newImage = postImages.child(UUID().uuidString)
            newImage.put(imageData as Data, metadata: nil) { (metadata, error) in
                
                if let url = metadata?.downloadURL()?.absoluteString {
                    completion(url)
                }
            }
        }
    }
}
