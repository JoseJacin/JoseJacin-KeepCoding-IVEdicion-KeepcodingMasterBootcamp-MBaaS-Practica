//
//  MainTimeLine.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class MainTimeLine: UITableViewController {

    //MARK: - Properties
    var model : [Post] = []
    let cellIdentier = constants.PostCell
    
    //MARK: - Outlets
    @IBOutlet weak var addPost: UIBarButtonItem!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        // Se indica analítica de Pantalla
        FIRAnalytics.setScreenName(constants.MainTimeLine, screenClass: constants.Main)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PostModel.recoverPost(event: .value) { (posts) in
            self.model = posts
            self.tableView.reloadData()
        }
        
        // Se comprueba si hay un usuario logado
        if let _ = FIRAuth.auth()?.currentUser {
            addPost.isEnabled = true
        } else {
            addPost.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Functions
    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.RefrescarListOfAllPosts, parameters: [constants.ActionPosts : constants.AllPosts as NSObject])
        
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentier)
        
        let post: Post = model[indexPath.row]
        
        cell.textLabel?.text = post.title
        
        var averageRating : Float = 0
        if post.cumulativeRating > 0 {
            averageRating = Float(post.cumulativeRating) / Float(post.numRatings)
        }
        
        cell.imageView?.imageFromServerURL(urlString: post.photo)
        
        cell.detailTextLabel?.text = constants.RatingString + averageRating.description

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Se indica analítica de acción
        FIRAnalytics.logEvent(withName: constants.SeleccionPostOfAllPosts, parameters: [constants.ActionPosts : constants.AllPosts as NSObject])
        
        performSegue(withIdentifier: constants.ShowRatingPost, sender: indexPath)
    }


    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == constants.ShowRatingPost {
            let vc = segue.destination as! PostReview
            // Se almacena el ultimo valor seleccionado
            let lastSelectedIndex = self.tableView.indexPathForSelectedRow?.last
            // Se pasa el elemento seleccionado
            vc.post = model[lastSelectedIndex!]
        }
    }
}
