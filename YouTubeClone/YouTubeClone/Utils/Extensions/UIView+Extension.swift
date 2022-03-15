//
//  UIView+Extension.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 15/03/22.
//

import UIKit

extension UIView{
    func animateBottomSheet(show : Bool, onCompleted : (() -> Void)?){
        if show{
            frame.origin.y += frame.height
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.frame.origin.y -= self.frame.height
                if onCompleted != nil{
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                        onCompleted!()
                    }
                }
            })
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            self.frame.origin.y += self.frame.height
            self.animateOverlay()
            if onCompleted != nil{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    onCompleted!()
                }
            }
        })
    }
    
    func animateOverlay(delay : TimeInterval = 0.0){
        self.alpha = 0
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        })
    }
    
    
}

