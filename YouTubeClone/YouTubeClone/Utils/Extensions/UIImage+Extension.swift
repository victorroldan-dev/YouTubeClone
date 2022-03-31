//
//  UIImage+Extension.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 18/03/22.
//

import Foundation
import UIKit

extension UIImage{
    @nonobjc class var bellImage: UIImage {
        return (UIImage(named: "bell")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var dotsImage: UIImage {
        return (UIImage(named: "dots")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var magnifyingIcon: UIImage {
        return (UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var castImage: UIImage {
        return (UIImage(named: "cast")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var chevronBackwardIcon: UIImage {
        return (UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var micFillIcon: UIImage {
        return (UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var xmarkIcon: UIImage {
        return (UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate))!
    }
    
    @nonobjc class var chevronDown: UIImage {
        return (UIImage(systemName: "chevron.down"))!
    }
    
    @nonobjc class var personCircleFill: UIImage {
        return (UIImage(systemName: "person.circle.fill"))!
    }
    
    @nonobjc class var magnifyingImage: UIImage {
        return (UIImage(named: "magnifying")?.withRenderingMode(.alwaysTemplate))!
    }

    @nonobjc class var videoPlaceholder: UIImage {
        guard let image = UIImage(named: "maxresdefault") else{
            fatalError("You should add the videoPlaceholder to the assets")
        }
        return image
    }
}
