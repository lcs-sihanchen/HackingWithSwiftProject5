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
            // an add button on top right invoking promptForAnswer Function
            navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self,
            action: #selector(promptForAnswer))
        }
    }
    
    @objc func promptForAnswer() {
       let ac = UIAlertController(title: "Enter answer", message:
    nil, preferredStyle: .alert)
       ac.addTextField()
    // action in : let the code that is executed accept a parameter of UIAction
    // weak: don't want strong references, two ways to resolve: 1 is unowned, 2 is weak. unown is like force unwrapped while weak is possibly a nil
    
    // Weak self weak ac means they can never form a strong reference cycle (who owns who)
    
    // Trailing closure syntax
       let submitAction = UIAlertAction(title: "Submit",
    style: .default) { [weak self, weak ac] action in
        
          guard let answer = ac?.textFields?[0].text else {
            return
        }
        
          self?.submit(answer)
       }
       ac.addAction(submitAction)
       present(ac, animated: true)
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
    
    func submit(_ answer: String) {
    }
}

