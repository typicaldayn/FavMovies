//
//  MovieModel.swift
//  FavMovies
//
//  Created by Stas Bezhan on 31.08.2022.
//

import Foundation
import RealmSwift

class Movie: Object {
    @Persisted var title: String
    @Persisted var year: Int
}
