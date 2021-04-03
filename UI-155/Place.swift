//
//  Place.swift
//  UI-155
//
//  Created by にゃんにゃん丸 on 2021/04/02.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var placemark : CLPlacemark
}

