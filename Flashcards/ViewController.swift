//
//  ViewController.swift
//  Flashcards
//
//  Copyright © 2020 Patriz Elaine Daroy. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    var flashcardsController: ViewController!
    var alert: UIAlertController!
    var flashcards = [Flashcard]()
    var currentIndex = 0;
    var userAttemptAnswer: String = ""
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var answerAttemptField: UITextField!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        
        if flashcards.count==0
        {
            updateFlashcard(question: "Who is the best CS professor at CPP?", answer: "Dr. Yang")
        }
        else
        {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapOnCheck(_ sender: Any) {
        userAttemptAnswer = answerAttemptField.text ?? ""
        checkAnswer(question: flashcards[currentIndex].question, answer: flashcards[currentIndex].answer)
        print (userAttemptAnswer)
    }
    
    func checkAnswer(question: String, answer: String)
    {
        let flashcard = Flashcard (question: question, answer: answer)
        if(userAttemptAnswer == flashcard.answer)
        {
            answerAttemptField.layer.borderColor = UIColor.clear.cgColor
            answerAttemptField.layer.borderWidth = 0
            if(frontLabel.isHidden == false)
            {
                frontLabel.isHidden = true;
                answerAttemptField.text = "";
                answerAttemptField.layer.borderColor = UIColor.gray.cgColor;
            }
        }
        else {
            answerAttemptField.text = "";
            answerAttemptField.layer.borderColor = UIColor.red.cgColor
            answerAttemptField.layer.borderWidth = 1.0
            answerAttemptField.layer.cornerRadius = 5.0
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
           if(frontLabel.isHidden == false)
           {
               frontLabel.isHidden = true;
           }
           else
           {
               frontLabel.isHidden = false;
           }
       }
    
    func updateFlashcard(question: String, answer: String)
    {
        let flashcard = Flashcard (question: question, answer: answer)
        answerAttemptField.layer.borderColor = UIColor.gray.cgColor;
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        print ("Added a new flashcard")
        print ("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print ("Our current index is \(currentIndex)")
        updateNextPrevButtons()
        updateLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //we know the destination of the segue is the navigation controller
        let navigationController = segue.destination as! UINavigationController
        
        //we know the navigation controller only contains a creation view controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue"{
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
    }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards [currentIndex]
        frontLabel.isHidden = false;
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
    }
    
    func updateNextPrevButtons () {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        answerAttemptField.layer.borderColor = UIColor.gray.cgColor;
        currentIndex = currentIndex - 1
        print("current Index", currentIndex)
        updateLabels()
        updateNextPrevButtons()
        animateCardout2()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        answerAttemptField.layer.borderColor = UIColor.gray.cgColor;
        currentIndex = currentIndex + 1
        updateLabels()
        updateNextPrevButtons()
        animateCardout()
    }
    
    func animateCardout() {
        UIView.animate(withDuration: 0.1, animations: { self.card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0.0)}, completion: {finished in
            
            self.updateLabels()
            self.animateCardin()
            
        })
        
    }
    
    func animateCardin() {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        UIView.animate(withDuration: 0.1) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animateCardout2(){
        UIView.animate(withDuration: 0.1, animations: { self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)}, completion: { finished in
            
            self.updateLabels()
            self.animateCardin2()
            
        })
        
    }
    
    func animateCardin2() {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.1) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func saveAllFlashcardsTodisk (){
        let dictionaryArray = flashcards.map { (card) -> [String: String]  in
            return ["question": card.question,  "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcard")
        
        print("Flashcards saved to UserDefaults")
    
        func readSavedFlashcards () {
            if let dictionaryArray = UserDefaults.standard.array (forKey: "flashcards") as? [[String:String]]{
                
                let savedCards = dictionaryArray.map{ dictionary -> Flashcard in return Flashcard(question:dictionary["question"]!, answer:dictionary["answer"]!)
                    
                }
                flashcards.append(contentsOf: savedCards)
            }
        }
    }
}

