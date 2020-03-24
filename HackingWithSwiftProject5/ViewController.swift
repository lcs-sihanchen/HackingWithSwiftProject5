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
    
    func isPossible(word: String) -> Bool {
        // ! means the opposite, in this case it's false because we don't want players to write a word again
        return !usedWords.contains(word)
    }
    
    // This method is used to check if the letter in our answer actually exists in the original word
    func isOriginal(word: String) -> Bool {
        // title is the word we are playing with
        guard var tempWord = title?.lowercased() else {
            return false
        }
        
        for letter in word {
            // first index : the first time a value appears in the array
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
                // if it didn't find the first index of the letter which means the word user creates is not part of the original word
            } else {
                return false
            }
        }
        
        return true
    }
    
    
    func isReal(word: String) -> Bool {
        // UITextChecker is a tool to check if the users spell things correctly
        let checker = UITextChecker()
        // Range is the whole word, starting from 0 to itself
        // Using Unicode Transformation Format (16-bit) because this code will consider emoji a 2-letter string while uikit consider it as 1. Suggestion is that use utf16 when working with UIKit, SpriteKit or any other Apple Framework.
        
        let range = NSRange(location: 0, length: word.utf16.count)
        // Parameter #4 asks to start at the beginning of the range if no spelling error is found
        // This command returns where the error is found, if there isn't an error, it will return NSNotFound
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // NSNotFound tells us the spelling is correct
        return misspelledRange.location == NSNotFound
    }
    
    // An alert will show up when you put a wrong answer
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        
        let ac = UIAlertController(title: errorTitle, message:
            errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        
        
        // Triple if because we need to pass 3 tests before the answers become valid
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                // Not the same word
                if  lowerAnswer == title {
                    showErrorMessage(errorTitle: "It's the same", errorMessage: "Try to make a new word!")
                    
                // Minimum of 3 letters in the word
                } else  if lowerAnswer.count < 3 {
                    showErrorMessage(errorTitle: "Not long enough", errorMessage: "The word should have more than 2 letters.")
                    
                } else if isReal(word: lowerAnswer){
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath],
                                         with: .automatic)
                    return
                } else {
                    showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                }
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        } else {
            guard let title = title?.lowercased() else {
                return
                
            }
            
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title).")
           
        }
        
        
       
    }
}


