//
//  ViewController.swift
//  HackingWithSwiftProject5
//
//  Created by Chen, Sihan on 2020-03-22.
//  Copyright © 2020 Chen, Sihan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // Properties
    var allWords = [String]()
    
    // Player's answers
    var usedWords = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Find the path for start.txt
        // Use if let because all the values here are optional
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            // try? means if there is any error, return a nil value
            // There is always a result, but we need to deal with it carefully
            // Separate the words in the file after convert them into string
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                allWords = startWords.components(separatedBy: "\n")
                
            }
            
            // isEmpty is more code efficient than .count == 0
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
            
            startGame()
            
        }
    }
    
    
    func startGame() {
        title = allWords.randomElement()
        
        // Keep Capacity is very efficient when you are trying to grow the collection again
        
        usedWords.removeAll(keepingCapacity: true)
        
        // Calling numberOfRowsInSection and cellForRowAt again
        
        tableView.reloadData()
    }
    
    
    // Two functions to show titles on the cell (number of rows and reusable cell)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
}

