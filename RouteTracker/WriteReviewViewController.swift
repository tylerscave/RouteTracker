//
//  WriteReviewViewController.swift
//  RouteTracker
//
//  Controller for the view presented when user has clicked on "Write Review"
//  from the Menu. This view is a simple form fill with a text field
//
//  Created by Tyler Jones, Pete Curtis, Marshall Cargle, Matt Nowzari on 4/15/17.
//  Copyright © 2017 Front Row Crew. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {

    @IBOutlet weak var feedbackView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        feedbackView.layer.borderWidth = 0.5
        feedbackView.layer.borderColor = borderColor.cgColor
        feedbackView.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
