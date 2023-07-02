//
//  FCollectionRef.swift
//  Chat-App
//
//  Created by ME-MAC on 7/2/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore




enum FCollectionRef: String {
    case User
    case Recent
    
}

func firebaseReferance(_ collectionRef: FCollectionRef) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionRef.rawValue)
}
