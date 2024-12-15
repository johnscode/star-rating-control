//
//  ViewController.swift
//  starrating
//
//  Created by John Fowler on 12/14/24.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet private var starControl: StarControl!
  @IBOutlet private var threeStarControl: ThreeStarRating!
  @IBOutlet private var button: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func btnPressed(_ sender: UIButton) {
    starControl.fillValue = 0.75
    starControl.starColor = UIColor.blue
    threeStarControl.rating = 0.75
    print("btn press")
  }


}

