//
//  StarControl.swift
//  starrating
//
//  Created by John Fowler on 12/14/24.
//

import UIKit

@IBDesignable
class StarControl: UIControl {
    
    // MARK: - Properties
    
    private let starLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    
    /// Value between 0 and 1 representing how filled the star should be
  @IBInspectable
    var fillValue: CGFloat = 0 {
        didSet {
            // Ensure value is between 0 and 1
            fillValue = min(1, max(0, fillValue))
            updateFillLayer()
        }
    }
    
  @IBInspectable
    var starColor: UIColor = .systemYellow {
        didSet {
            starLayer.strokeColor = starColor.cgColor
            fillLayer.fillColor = starColor.cgColor
        }
    }
  
  // Additional customizable properties
  @IBInspectable
  var borderWidth: CGFloat = 1.0 {
      didSet {
          starLayer.lineWidth = borderWidth
          setNeedsLayout()
      }
  }
  
  @IBInspectable var borderColor: UIColor = .black {
          didSet {
              layer.borderColor = borderColor.cgColor
          }
      }
  
  var starInset: CGFloat = 2.0 {
      didSet {
          setNeedsLayout()
      }
  }
  
  // Animation duration for fill changes
  var animationDuration: TimeInterval = 0.2
  
  // Animate the fill value change
  func setFillValue(_ value: CGFloat, animated: Bool) {
      if animated {
          CATransaction.begin()
          CATransaction.setAnimationDuration(animationDuration)
          fillValue = value
          CATransaction.commit()
      } else {
          fillValue = value
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
      // Setup fill layer first (should be behind the stroke)
      fillLayer.fillColor = starColor.cgColor
      fillLayer.strokeColor = UIColor.clear.cgColor
      layer.addSublayer(fillLayer)
      
      // Setup star outline layer
      starLayer.fillColor = UIColor.clear.cgColor
      starLayer.strokeColor = starColor.cgColor
      starLayer.lineWidth = borderWidth
      layer.addSublayer(starLayer)
      
      updateFillLayer()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
      super.layoutSubviews()
      
      let starPath = createStarPath()
      starLayer.path = starPath.cgPath
      fillLayer.path = starPath.cgPath
      
      // Update the frame of both layers
      starLayer.frame = bounds
      fillLayer.frame = bounds
      
      updateFillLayer()
    }
    
    // MARK: - Star Path Creation
    
    private func createStarPath() -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let outerRadius = min(bounds.width, bounds.height) / 2
        let innerRadius = outerRadius * 0.4
        
        // Calculate points for a 5-pointed star
        var points: [CGPoint] = []
        for i in 0..<10 {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let angle = CGFloat(i) * CGFloat.pi / 5 - CGFloat.pi / 2
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            points.append(point)
        }
        
        // Create the star path
        path.move(to: points[0])
        for point in points[1...] {
            path.addLine(to: point)
        }
        path.close()
        
        return path
    }
    
    // MARK: - Fill Update
    
  private func updateFillLayer() {
      // Create a filled path up to the fill value
      let starPath = createStarPath()
      let fillPath = UIBezierPath()
      
      // Create a rectangle that covers the desired fill amount
      let fillRect = CGRect(x: 0, y: 0, width: bounds.width * fillValue, height: bounds.height)
      let maskPath = UIBezierPath(rect: fillRect)
      
      // Create mask layer
      let maskLayer = CAShapeLayer()
      maskLayer.path = maskPath.cgPath
      
      // Apply the mask to the fill layer
      fillLayer.mask = maskLayer
  }
  
  override func prepareForInterfaceBuilder() {
      super.prepareForInterfaceBuilder()
      setup()
  }
}
