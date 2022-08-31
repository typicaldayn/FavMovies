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
    
    private let realm = try! Realm()
    private var movies: Results<Movie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTable.delegate = self
        moviesTable.dataSource = self
        warningLabel.alpha = 0
        movies = realm.objects(Movie.self)
        moviesTable.reloadData()
    }
    
    private func sort(sortingIndex: Int) -> Results<Movie> {
        if sortingIndex == 0 {
            return movies!.sorted(byKeyPath: "year", ascending: false)
        } else if sortingIndex == 1 {
            return movies!.sorted(byKeyPath: "title", ascending: true)
        } else {
            return movies!
        }
    }
    
    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
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
        do {
            try realm.write({
                guard let title = titleTextField.text, let year = yearTextField.text else {fatalError()}
                guard title != "", year != "" else {
                    Animation.animate(label: warningLabel, newText: "Incorrect info");
                    return
                }
                guard let yearAsInt = Int(year) else {
                    Animation.animate(label: warningLabel, newText: "Incorrect year");
                    return
                }
                let newMovie = Movie(value: ["title" : title, "year" : yearAsInt])
                movies?.forEach({ movie in
                    if movie.title == newMovie.title {
                        Animation.animate(label: warningLabel, newText: "Movie already added")
                    } else {
                        realm.add(newMovie)
                    }
                })
                moviesTable.reloadData()
            })
        } catch let error as NSError {
            Animation.animate(label: warningLabel, newText: error.localizedDescription)
        }
        
    }
    
    private func delete(movieToDelete: Movie) {
        try! realm.write({
            realm.delete(movieToDelete)
            moviesTable.reloadData()
        })
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard movies?.count != nil else {return 0}
        return movies!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell {
            guard movies != nil else {return UITableViewCell()}
            cell.titleNameLabel.text = movies![indexPath.row].title
            cell.movieYearLabel.text = String(movies![indexPath.row].year)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard movies != nil && movies?.count != 0 else {fatalError()}
        if editingStyle == .delete {
            delete(movieToDelete: movies![indexPath.row])
        } else {
            Animation.animate(label: warningLabel, newText: "Nothing to delete")
        }
    }
    
}

