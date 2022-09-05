//
//  Collection Manager.swift
//  FavMovies
//
//  Created by Stas Bezhan on 05.09.2022.
//

import Foundation
import Collections
import UIKit
import SwiftUI

class CollectionManager {
    
    private var movies: OrderedSet<MoviesCollectionModel> = []
    
    func save(movie: MoviesCollectionModel, labelToAnimate: UILabel) {
        guard movie.title != "", String(movie.year) != "" else {
            Animation.animate(label: labelToAnimate, newText: "Wrong info");
            return
        }
        if movies.contains(movie) {
            Animation.animate(label: labelToAnimate, newText: "Movie already created")
        } else {
            movies.append(movie)
        }
    }
    
    func delete(at index: Int, labelToAnimate: UILabel) {
        guard !movies.isEmpty else {
            Animation.animate(label: labelToAnimate, newText: "Nothing to delete");
            return
        }
        movies.remove(at: index)
    }
    
    func getMovies() -> OrderedSet<MoviesCollectionModel> {
        return movies
    }
}
