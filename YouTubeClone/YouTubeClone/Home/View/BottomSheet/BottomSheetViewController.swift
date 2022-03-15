//
//  BottomSheetViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 14/03/22.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet weak var optionContainer: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay(_:)))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        optionContainer.animateBottomSheet(show: true){}
    }

    
    @objc func didTapOverlay(_ sender : UITapGestureRecognizer){
        optionContainer.animateBottomSheet(show: false) {
            self.dismiss(animated: false)
        }
    }
}
