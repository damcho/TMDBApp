//
//  TMDBAppTests.swift
//  TMDBAppTests
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import XCTest
@testable import TMDBApp

class ModelObjectAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieModelCreation() {
        /*
        let json = """
{
  "adult": false,
  "backdrop_path": "/6xKCYgH16UuwEGAyroLU6p8HLIn.jpg",
  "belongs_to_collection": {
    "id": 230,
    "name": "The Godfather Collection",
    "poster_path": "/sSbkKCHtIEakht5rnEjrWeR2LLG.jpg",
    "backdrop_path": "/3WZTxpgscsmoUk81TuECXdFOD0R.jpg"
  },
  "budget": 6000000,
  "genres": [
    {
      "id": 18,
      "name": "Drama"
    },
    {
      "id": 80,
      "name": "Crime"
    }
  ],
  "homepage": "http://www.thegodfather.com/",
  "id": 238,
  "imdb_id": "tt0068646",
  "original_language": "en",
  "original_title": "The Godfather",
  "overview": "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
  "popularity": 26.798,
  "poster_path": "/d4KNaTrltq6bpkFS01pYtyXa09m.jpg",
  "production_companies": [
    {
      "id": 4,
      "logo_path": "/fycMZt242LVjagMByZOLUGbCvv3.png",
      "name": "Paramount",
      "origin_country": "US"
    },
    {
      "id": 10211,
      "logo_path": null,
      "name": "Alfran Productions",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "1972-03-14",
  "revenue": 245066411,
  "runtime": 175,
  "spoken_languages": [
    {
      "iso_639_1": "en",
      "name": "English"
    },
    {
      "iso_639_1": "it",
      "name": "Italiano"
    },
    {
      "iso_639_1": "la",
      "name": "Latin"
    }
  ],
  "status": "Released",
  "tagline": "An offer you can't refuse.",
  "title": "The Godfather",
  "video": false,
  "vote_average": 8.6,
  "vote_count": 9092,
  "videos": {
    "results": [
      {
        "id": "592199669251414ab10568ec",
        "iso_639_1": "en",
        "iso_3166_1": "US",
        "key": "fBNpSRtfIUA",
        "name": "The Godfather- Offer He Can't Refuse",
        "site": "YouTube",
        "size": 1080,
        "type": "Clip"
      },
      {
        "id": "5b73e18f92514140681c2cba",
        "iso_639_1": "en",
        "iso_3166_1": "US",
        "key": "_IqFJLdV13o",
        "name": "The Godfather - Official® Trailer [HD]",
        "site": "YouTube",
        "size": 1080,
        "type": "Trailer"
      }
    ]
  }
}

""".data(using: .utf8)!
        let movie = Movie(data:json)
        XCTAssertEqual(movie.title, "")
        XCTAssertEqual(movie.popularity, 0)
        XCTAssertEqual(movie.voteAverage, 0)
        XCTAssertEqual(movie.movieId, 0)
        XCTAssertEqual(movie.imageData, nil)
        XCTAssertEqual(movie.imageURLPath, nil)
        XCTAssertEqual(movie.overview, "")
         */

    }
}
