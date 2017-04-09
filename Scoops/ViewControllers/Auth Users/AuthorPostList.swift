//
//  AuthorPostList.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class AuthorPostList: UITableViewController {

    //MARK: - Properties
    let cellIdentifier = constants.PostAutor
    
    var model: [Post] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Se indica analítica de Pantalla
        FIRAnalytics.setScreenName(constants.AuthorPostList, screenClass: constants.AuthUsers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Se recupera el usuario logado y se crean dos observers para los post del usuario y por si alguno de ellos es eliminado
        if let userId = FIRAuth.auth()?.currentUser?.uid {
            PostModel.recoverUserPost(event: .value, userId: userId, completion: { (posts) in
                self.model = posts
                self.tableView.reloadData()
            })
            PostModel.recoverUserPost(event: .childRemoved, userId: userId, completion: { (posts) in
                self.model = posts
                self.tableView.reloadData()
            })
        }
    }
    
    //MARK: - Funcions
    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.RefrescarListOfAuthorPosts, parameters: [constants.ActionPosts : constants.AuthorPosts as NSObject])
        
        refreshControl.endRefreshing()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let post = model[indexPath.row]
        cell.textLabel?.text = post.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Se recupera el post en el que se va a realiar la acción de eliminar
        let post = self.model[indexPath.row] as Post
        
        // Se añade un botón de publicar para realizar la publicación del post sin tener que entrar en la descripción del mismo
        let publish = UITableViewRowAction(style: .normal, title: constants.Publicar) { (action, indexPath) in
            posts.removeAllObservers()
            
            // Se realiza la publicación del post
            PostModel.publishPost(postId: post.cloudRef!, completion: { (result) in
                print(result.description)
                
                // Se indica analítica de acción
                FIRAnalytics.logEvent(withName: constants.PublishPostAction, parameters: [constants.ActionPosts : constants.AuthorPosts as NSObject])
                
            })
            
            // Se recupera el usuario logado y se crean dos observers para los post del usuario y por si alguno de ellos es eliminado
            if let userId = FIRAuth.auth()?.currentUser?.uid {
                PostModel.recoverUserPost(event: .value, userId: userId, completion: { (posts) in
                    self.model = posts
                    self.tableView.reloadData()
                })
                PostModel.recoverUserPost(event: .childRemoved, userId: userId, completion: { (posts) in
                    self.model = posts
                    self.tableView.reloadData()
                })
            }
            
            
        }
        publish.backgroundColor = UIColor.green
        
        let deleteRow = UITableViewRowAction(style: .destructive, title: constants.Eliminar) { (action, indexPath) in
            // Se elimina el post
            PostModel.deletePost(post: post, completion: { (result) in
                print(result.description)
                
                // Se indica analítica de acción
                FIRAnalytics.logEvent(withName: constants.DeletePostAction, parameters: [constants.ActionPosts : constants.AuthorPosts as NSObject])

            })
        }
        return [publish, deleteRow]
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

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
