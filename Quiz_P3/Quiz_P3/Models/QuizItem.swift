//
//  QuizItem.swift
//  P1 Quiz SwiftUI
//
//  Created by Santiago Pavón Gómez on 14/9/21.
//

import Foundation
//Codable: permite usar datos de un json entre otros, lo lee y creo un objeto
//Identificable: si hay campo id para distinguir los datos
struct QuizItem: Codable, Identifiable{
    let id: Int
    let question: String
    let answer: String
    let author: Author?
    let attachment: Attachment?
    var favourite: Bool
    
    struct Author: Codable {
        let id: Int
        let isAdmin: Bool?
        let username: String?
        let profileName: String?
        let photo: Attachment?
    }
    
    struct Attachment: Codable {
        let filename: String?
        let mime: String?
        let url: URL?
    }
}
