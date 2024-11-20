//
//  Bird.swift
//  Test1
//
//  Created by Margaux Mazaleyras on 20/11/2024.
//

import Foundation

struct Bird: Identifiable, Decodable {
    let id: String // Utilise `subId` comme identifiant unique
    let speciesCode: String
    let comName: String
    let sciName: String
    let locName: String
    let obsDt: String
    let howMany: Int? // Rendre cette propriété optionnelle
    let lat: Double
    let lng: Double

    enum CodingKeys: String, CodingKey {
        case id = "subId"
        case speciesCode, comName, sciName, locName, obsDt, howMany, lat, lng
    }
}

