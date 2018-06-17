//
//  HomeItem.swift
//  Proficiency-Exercise
//
//  Created by Vasim Ajmeri on 17/06/18.
//  Copyright © 2018 Vasim Ajmeri. All rights reserved.
//

import Foundation

struct HomeData : Decodable {
    let title : String?
    let rows  : [HomeItem]
}

struct HomeItem : Decodable{
    let title       : String?
    let description : String?
    let imageHref   : String?
}
