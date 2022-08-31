//
//  AnimationDelegate.swift
//  FavMovies
//
//  Created by Stas Bezhan on 31.08.2022.
//

import Foundation
import UIKit

protocol Animations {
    static func animate(label: UILabel, newText: String)
}

struct Animation: Animations {
    
    static func animate(label: UILabel, newText: String) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
            label.text = newText
            label.alpha = 0.5
            label.alpha = 1
            label.alpha = 0
        } completion: { _ in
            label.layer.removeAllAnimations()
        }

    }
    
}
