//
//  MoviesListSearchController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/11/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class MoviesListSearchController: UISearchController {
    
    var interactor: MoviesFilter?

    func setupSearchController() {
        searchResultsUpdater = self
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        hidesNavigationBarDuringPresentation = true
        searchBar.sizeToFit()
    }
}

extension MoviesListSearchController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //    self.movieCategoryFilter.selectedSegmentIndex = 0
     //   self.segmentedControlValueChanged(self.movieCategoryFilter)
    }
}

extension MoviesListSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let filterRequest = MoviesFilterRequest(queryString: strippedString)
   //     self.movieCategoryFilter.selectedSegmentIndex = UISegmentedControl.noSegment
        interactor?.filterMoviesWith(filterRequest: filterRequest)
    }
}
