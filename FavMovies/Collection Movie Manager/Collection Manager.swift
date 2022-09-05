//
//  Collection Manager.swift
//  FavMovies
//
//  Created by Stas Bezhan on 05.09.2022.
//

import Foundation
import Collections
import OrderedCollections
import UIKit

class CollectionManager {
    
    private var movies: OrderedSet<MoviesCollectionModel> = []
    
    func save(movie: MoviesCollectionModel, labelToAnimate: UILabel) {
        guard movie.title != "", String(movie.year) != "" else {
            Animation.animate(label: labelToAnimate, newText: "Wrong info");
            return
        }
        movies.append(movie)
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
    
    func sort(sortIndex: Int = 0) {
        if sortIndex == 0 {
            self.movies.sort {$0.year < $1.year}
        } else {
            self.movies.sort {$0.title > $1.title}
        }
    }
    
}
