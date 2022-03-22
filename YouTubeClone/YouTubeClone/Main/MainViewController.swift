//
//  MainViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import UIKit

class MainViewController: BaseViewController {
    var rootPageViewController : RootPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RootPageViewController{
            destination.delegateRoot = self
            rootPageViewController = destination
        }
    }
    
    override func dotsButtonPressed() {
        
    }

}

extension MainViewController : RootPageProtocol{
    func currentPage(_ index: Int) {
        print("currentPage: ", index)
    }
    
    
}
