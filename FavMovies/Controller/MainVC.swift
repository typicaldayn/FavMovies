//
//  ViewController.swift
//  FavMovies
//
//  Created by Stas Bezhan on 31.08.2022.
//

import UIKit
import RealmSwift
import SwiftUI

class MainVC: UIViewController {
    
    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    private let realm = try! Realm(configuration: .defaultConfiguration, queue: DispatchQueue.main)
    private lazy var movies: Results<Movie> = {
        return realm.objects(Movie.self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTable.delegate = self
        moviesTable.dataSource = self
        warningLabel.alpha = 0
        movies = realm.objects(Movie.self)
    }
    
    private func sort(sortingIndex: Int) -> Results<Movie> {
        if sortingIndex == 0 {
            return movies.sorted(byKeyPath: "year", ascending: false)
        } else if sortingIndex == 1 {
            return movies.sorted(byKeyPath: "title", ascending: true)
        } else {
            return movies
        }
    }
    
    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        movies = sort(sortingIndex: sender.selectedSegmentIndex)
        moviesTable.reloadData()
    }
    
    @IBAction func addMoviePressed(_ sender: UIButton) {
        save()
        titleTextField.text = ""
        yearTextField.text = ""
    }
    
    
    //MARK: - Realm Methods
    private func save() {
        print(movies.isEmpty)
        do {
            try realm.write({
                guard let title = titleTextField.text, let year = yearTextField.text else {
                    Animation.animate(label: warningLabel, newText: "Unexpected error!");
                    return
                }
                guard title != "", year != "" else {
                    Animation.animate(label: warningLabel, newText: "Incorrect info");
                    return
                }
                guard let yearAsInt = Int(year) else {
                    Animation.animate(label: warningLabel, newText: "Incorrect year");
                    return
                }
                let newMovie = Movie()
                newMovie.year = yearAsInt
                newMovie.title = title
                let indexPath: IndexPath = [0, movies.count]
                var isUpdated = true
                for movie in movies {
                    if newMovie.title == movie.title && newMovie.year != movie.year {
                        isUpdated = false
                    }else if newMovie.title != movie.title && newMovie.year == movie.year{
                        isUpdated = false
                    }else if movies.isEmpty{
                        isUpdated = false
                        realm.add(newMovie)
                    }else if newMovie.title != movie.title && newMovie.year != movie.year {
                        isUpdated = false
                    } else if newMovie == movie {
                        Animation.animate(label: warningLabel, newText: "Movie already added")
                        isUpdated = true
                        return
                    }else if movies.count == 0 {
                        isUpdated = false
                    } else {
                        Animation.animate(label: warningLabel, newText: "Movie already added")
                        isUpdated = true
                        return
                    }
                }
                if !isUpdated {
                    realm.add(newMovie)
                    print(7)
                    moviesTable.insertRows(at: [indexPath], with: .fade)
                    moviesTable.endUpdates()
                }else if isUpdated && movies.count == 0 {
                    realm.add(newMovie)
                    print(11)
                    moviesTable.insertRows(at: [indexPath], with: .fade)
                    moviesTable.endUpdates()
                } else {
                    Animation.animate(label: warningLabel, newText: "Unexpected error")
                    realm.cancelWrite()
                    print(8)
                    return
                }
            })
        } catch let error as NSError {
            Animation.animate(label: warningLabel, newText: error.localizedDescription)
        }
        
    }
    
    private func delete(movieToDelete: Movie) {
        do {
            try realm.write({
                realm.delete(movieToDelete)
            })
        } catch let error as NSError {
            Animation.animate(label: warningLabel, newText: error.localizedDescription)
        }
    }
}



//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell {
            cell.titleNameLabel.text = movies[indexPath.row].title
            cell.movieYearLabel.text = String(movies[indexPath.row].year)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard movies.count != 0 else {
            Animation.animate(label: warningLabel, newText: "Nothing to delete");
            return
        }
        if editingStyle == .delete {
            moviesTable.beginUpdates()
            delete(movieToDelete: movies[indexPath.row])
            moviesTable.deleteRows(at: [indexPath], with: .fade)
            
            moviesTable.endUpdates()
        } else {
            Animation.animate(label: warningLabel, newText: "Nothing to delete")
        }
    }
    
}

