//
//  APOD.swift
//  NasaApod
//
//  Created by Timur Dzamikh on 28.03.2023.
//

import Foundation

struct APOD: Decodable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let title: String
    let url: URL
    let media_type: String
}
