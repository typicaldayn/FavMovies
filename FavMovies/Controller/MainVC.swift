//
//  ViewController.swift
//  FavMovies
//
//  Created by Stas Bezhan on 31.08.2022.
//

import UIKit
import Collections

class MainVC: UIViewController {
    
    private var collectionManager = CollectionManager()
    
    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTable.delegate = self
        moviesTable.dataSource = self
        warningLabel.alpha = 0
    }
    
    private func sort(sortingIndex: Int) -> OrderedSet<MoviesCollectionModel> {
        if sortingIndex == 0 {
            return OrderedSet(collectionManager.getMovies().sorted {$0.year < $1.year})
        } else {
            return OrderedSet(collectionManager.getMovies().sorted {$0.title > $1.title})
        }
    }
    
    @IBAction func sortingChanged(_ sender: UISegmentedControl) {
        sort(sortingIndex: sender.selectedSegmentIndex)
        moviesTable.reloadData()
    }
    
    @IBAction func addMoviePressed(_ sender: UIButton) {
        guard let yearAsInt = Int(yearTextField.text!) else {
            Animation.animate(label: warningLabel, newText: "Incorrect year");
            return
        }
        let newMovie = MoviesCollectionModel(title: titleTextField.text!, year: yearAsInt)
        collectionManager.save(movie: newMovie, labelToAnimate: warningLabel)
        let index: IndexPath = [0, collectionManager.getMovies().count]
        moviesTable.beginUpdates()
        moviesTable.insertRows(at: [index], with: .fade)
        moviesTable.endUpdates()
        titleTextField.text = ""
        yearTextField.text = ""
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionManager.getMovies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell {
            cell.movieYearLabel.text = String(collectionManager.getMovies()[indexPath.row].year)
            cell.titleNameLabel.text = collectionManager.getMovies()[indexPath.row].title
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard collectionManager.getMovies().count != 0 else {
            Animation.animate(label: warningLabel, newText: "Nothing to delete");
            return
        }
        if editingStyle == .delete {
            moviesTable.beginUpdates()
            collectionManager.delete(at: indexPath.row, labelToAnimate: warningLabel)
            moviesTable.deleteRows(at: [indexPath], with: .fade)
            moviesTable.endUpdates()
        } else {
            Animation.animate(label: warningLabel, newText: "Nothing to delete")
        }
    }
    
}

