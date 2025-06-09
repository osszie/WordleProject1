//
//  BoardController.swift
//  Wordle
//
//  Created by Mari Batilando on 2/20/23.
//

import Foundation
import UIKit

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {

  // MARK: - Properties
  let numItemsPerRow = 5
  let numRows = 6
  let collectionView: UICollectionView
  let goalWord: [String]

  var numGuesses = 0
  var currRow: Int {
    return numGuesses / numItemsPerRow
  }

  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.goalWord = WordGenerator.generateRandomWord()!.map { String($0) }
    super.init()
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  // MARK: - Public Methods
  func enter(_ string: String) {
    guard numGuesses < numItemsPerRow * numRows else { return }
    let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses, section: 0)) as! LetterCell
    cell.set(letter: string)
    UIView.animate(withDuration: 0.1,
                   delay: 0.0,
                   options: [.autoreverse],
                   animations: {
      // Exercise 7: Change the scale of the cell by 1.05
      // Tip: Use the transform property of the cell. Use transform.scaledBy to modify the scale. This should feel familiar to lab 1.
      // Checkpoint: After finishing this exercise, you should now be able to see that the board animates whenever you enter a new letter! If it's not animating, check your work on this exercise.
      // START YOUR CODE HERE
      cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      // END YOUR CODE HERE
    }, completion: { finished in
      cell.transform = CGAffineTransformIdentity
    })
    if isFinalGuessInRow() {
      markLettersInRow()
    }
    numGuesses += 1
  }

  func deleteLastCharacter() {
    guard numGuesses > 0 && numGuesses % numItemsPerRow != 0 else { return }
    let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses - 1, section: 0)) as! LetterCell
    numGuesses -= 1
    // Exercise 6: Look at the available LetterCell's methods to clear the letter and set the style to `initial`
    // Tip: Checkout the public methods on LetterCell.swift
    // Checkpoint: After finishing this exercise, you should now be able to tap on the delete keyboard cell and have the last letter deleted on the board! If it's not working, check your work on this exercise and make sure deleteLastCharacter() is called properly in exercise 3.
    // START YOUR CODE HERE
    cell.set(letter: "")
    cell.set(style: .initial)
  }
  func markLettersInRow() {
    var currentRowLetters: [String] = []
    let start = currRow * numItemsPerRow
    let end = start + numItemsPerRow

    for index in start..<end {
      if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? LetterCell,
         let letter = cell.letter {
        currentRowLetters.append(letter)
      } else {
        currentRowLetters.append("")
      }
    }
        for (i, letter) in currentRowLetters.enumerated() {
      guard let cell = collectionView.cellForItem(at: IndexPath(item: start + i, section: 0)) as? LetterCell else {
        continue
      }

      if letter == goalWord[i] {
        cell.set(style: .correct)      // Green
      } else if goalWord.contains(letter) {
        cell.set(style: .inWord)       // Yellow
      } else {
        cell.set(style: .notInWord)    // Gray
      }
    }
  }

  func isFinalGuessInRow() -> Bool {
    return numGuesses % numItemsPerRow == 0
  }

 func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numItemsPerRow * numRows
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: "LetterCell", for: indexPath)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let spacing: CGFloat = 4.0
    let totalSpacing = spacing * CGFloat(numItemsPerRow - 1)
    let cellWidth = (collectionView.bounds.width - totalSpacing) / CGFloat(numItemsPerRow)
    return CGSize(width: cellWidth, height: cellWidth)
    // END YOUR CODE HERE
  }
                         
}
