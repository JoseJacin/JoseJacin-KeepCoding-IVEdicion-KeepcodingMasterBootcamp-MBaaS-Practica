//
//  Extensions.swift
//  Scoops
//
//  Created by Jose Sanchez Rodriguez on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation

struct constants {
    //MARK: - App
    static let AppName = "Scoops"
    
    //MARK: - Login
    //MARK: GoogleID
    static let errorLoginGoogleID = "Error en Login en GoogleID"
    static let errorLoginFirebaseWithGoogleID = "Error Login en Firebase con los credenciales de GoogleID"
    
    //MARK: - Analytics
    //MARK: ScreenName
    static let PostReview = "PostReview"
    static let AuthorPostList = "AuthorPostList"
    static let NewPostController = "NewPostController"
    static let MainTimeLine = "MainTimeLine"
    static let AllUsers = "AllUsers"
    static let AuthUsers = "AuthUsers"
    static let Main = "Main"
    
    //MARK: Events
    static let RatePost = "RatePost"
    static let RefrescarListOfAuthorPosts = "RefrescarListOfAuthorPosts"
    static let TakePhoto = "TakePhoto"
    static let PublishPostAction = "PublishPostAction"
    static let DeletePostAction = "DeletePostAction"
    static let SavePostInCloud = "SavePostInCloud"
    static let RefrescarListOfAllPosts = "RefrescarListOfAllPosts"
    static let SeleccionPostOfAllPosts = "SeleccionPostOfAllPosts"
    
    //MARK: Actions parameters
    static let ActionPosts = "ActionPosts"
    static let ReviewPosts = "ReviewPosts"
    static let AuthorPosts = "AuthorPosts"
    static let ActionCamera = "ActionCamera"
    static let NewPost = "NewPost"
    static let AllPosts = "AllPosts"
    
    //MARK: - Table View Row Action
    static let Publicar = "Publicar"
    static let Eliminar = "Eliminar"
    
    //MARK: - Push Alert Camera Action
    static let PushAlertCameraActionMessage = "Selecciona la fuente de la imagen"
    static let PushAlertCameraActionLibrary = "Usar la libreria"
    static let PushAlertCameraActionCamera = "Usar la camara"
    static let PushAlertCameraActionCancel = "Cancel"
    
    //MARK: - Push Alert Login with Mail
    static let PushAlertLoginActionRequireEmail = "Por favor, escriba su mail"
    static let PushAlertLoginActionRequirePass = "Por favor, escriba su password"
    static let PushAlertLoginActionCancel = "Cancel"
    
    //MARK: - Login
    static let LoginActionLogin = "Login"
    static let LoginActionRegisterNewUser = "Registrar nuevo usuario"
    
    //MARK: - Resources
    static let defaultAvatar = "default_avatar.png"
    
    //MARK: - Database
    static let title = "title"
    static let desc = "desc"
    static let photo = "photo"
    static let lat = "lat"
    static let lng = "lng"
    static let published = "published"
    static let numRatings = "numRatings"
    static let cumulativeRating = "cumulativeRating"
    static let creationDate = "creationDate"
    static let userid = "userid"
    static let email = "email"
    static let ratings = "ratings"
    static let rating = "rating"
    
    //MARK: - Cells
    static let PostAutor = "POSTAUTOR"
    static let PostCell = "POSTSCELL"
    
    //MARK: - Segues
    static let launchWithLogged = "launchWithLogged"
    static let ShowRatingPost = "ShowRatingPost"

    //MARK: - Various
    static let RatingString = "Rating: "
    
    //MARK: - Database
    static let dbName = "HackerBooksPro"
    
    // Notifications
    static let collectionViewChanged = "collectionViewChanged"
    static let annotationsViewChanged = "AnnotationsViewChanged"
    
    //MARK: - Location
    /*
    static let locationServiceDisabled = "Location Services Disabled"
    static let locationServiceDisabledMessage = "Please enable location services for this app in Settings"
    static let locationServiceDisabledOK = "OK"
    static let locationServiceTimedOut = "Location Services timed out"
    static let locationServiceTimedOutMessage = "Location service has triggered timed out!"
    static let locationServiceTimedOutOK = "OK"
    */
}
