//
//  ThreesStarRating.swift
//  starrating
//
//  Created by John Fowler on 12/14/24.
//

import UIKit

@IBDesignable
class ThreeStarRating: UIControl {
  // MARK: - Properties
  
  private let stackView = UIStackView()
  private let star1 = StarControl()
  private let star2 = StarControl()
  private let star3 = StarControl()
  
  @IBInspectable
  var rating: CGFloat = 0 {
      didSet {
          // Ensure rating is between 0 and 1
          let clampedRating = min(1, max(0, rating))
          updateStarFills(for: clampedRating)
      }
  }
  
  @IBInspectable
  var starColor: UIColor = .systemYellow {
      didSet {
          star1.starColor = starColor
          star2.starColor = starColor
          star3.starColor = starColor
      }
  }
  
  @IBInspectable
  var spacing: CGFloat = 8 {
      didSet {
          stackView.spacing = spacing
      }
  }
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
      setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
      // Configure stack view
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually
      stackView.alignment = .center
      stackView.spacing = spacing
      
      // Add stack view to control
      addSubview(stackView)
      
      // Configure stack view constraints
      stackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          stackView.topAnchor.constraint(equalTo: topAnchor),
          stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
          stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
          stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])
      
      // Configure individual stars
      [star1, star2, star3].forEach { star in
          star.starColor = starColor
          stackView.addArrangedSubview(star)
          
          // Set equal width and height for each star
          star.translatesAutoresizingMaskIntoConstraints = false
          star.heightAnchor.constraint(equalTo: star.widthAnchor).isActive = true
      }
      
      updateStarFills(for: rating)
  }
  
  private func updateStarFills(for rating: CGFloat) {
      // Convert 0-1 rating to 0-3 scale
      let totalStars = rating * 3
      
      // Update each star's fill value
      star1.setFillValue(min(1, totalStars), animated: true)
      star2.setFillValue(min(1, max(0, totalStars - 1)), animated: true)
      star3.setFillValue(min(1, max(0, totalStars - 2)), animated: true)
  }
  
  // MARK: - Interface Builder Support
  
  override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
      setup()
  }

}
