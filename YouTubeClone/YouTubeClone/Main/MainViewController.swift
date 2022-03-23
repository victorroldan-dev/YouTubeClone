//
//  MainViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import UIKit

class MainViewController: BaseViewController {
    @IBOutlet weak var tabsView: TabsView!
    var rootPageViewController : RootPageViewController!
    private var options : [String] = ["HOME","VIDEOS","PLAYLIST","CHANNEL","ABOUT"]
    
    var currentPageIndex : Int = 0{
        willSet{
            print("wilSet: \(currentPageIndex)")
            let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
            cell?.isSelected = false
        }
        didSet{
            print("didSet: \(currentPageIndex)")
            if let _ = rootPageViewController{
                rootPageViewController.currentPage = currentPageIndex
                let cell = tabsView.collectionView.cellForItem(at: IndexPath(item: currentPageIndex, section: 0))
                cell?.isSelected = true
            }
        }
    }
    
    var didTapOption : Bool = false{
        didSet{
            if didTapOption{
                tabsView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now()+0.35) {
                    self.didTapOption.toggle()
                    self.tabsView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    var prevPercent : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        tabsView.buildView(delegate: self, options: options)
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
        currentPageIndex = index
        tabsView.selectedItem = IndexPath(item: index, section: 0)
    }
    
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int) {
        if percent == 0.0 || didTapOption{
            return
        }
        
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))
        // ----->>>[view]
        if direction == .goingRight{
            if index == options.count-1 { return}
            
            //El next index sería el actual +1
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index+1, section: 0))
            
            //Se suma el acumulado, mas el % escroleado de la celda actual.
            let calculateNewLeading = currentCell!.frame.origin.x + (currentCell!.frame.width * percent)
            let newWidth = (prevPercent < percent) ? nextCell?.frame.width : currentCell?.frame.width
            
            //Se actualizan las variables con los constraints
            updateUnderlineConstraints(calculateNewLeading, newWidth!)
            
        }else{//left [view] <<<<------
            //Si está en la primera pagina, y trata de moverse hacea la derecha, retorna
            if index == 0 { return }
            
            //El next index sería el actual menos 1
            let nextCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index-1, section: 0))
            
            //Se suma el acumulado, mas el % escroleado de la celda actual.
            let calculateNewLeading = currentCell!.frame.origin.x - (nextCell!.frame.width * percent)
            let newWidth = (prevPercent) < percent ? nextCell?.frame.width : currentCell?.frame.width
            
            //Se actualizan las variables con los constraints
            updateUnderlineConstraints(calculateNewLeading, newWidth!)
        }
        
        //Se guarda el valor previo para saber si va de derecha a izquerda dentro de la misma pagina.
        prevPercent = percent
    }
    
    func updateUnderlineConstraints(_ leading: CGFloat, _ width: CGFloat){
        tabsView.leadingConstraint?.constant = leading
        tabsView.widthConstraint?.constant = width
        tabsView.layoutIfNeeded()
    }
}

extension MainViewController : TabsViewProtocol{
    func didSelectOption(index: Int) {
        print("index: ", index)
        didTapOption = true
        
        let currentCell = tabsView.collectionView.cellForItem(at: IndexPath(item: index, section: 0))!
        tabsView.updateUnderline(xOrigin: currentCell.frame.origin.x, width: currentCell.frame.width)
        
        var direction : UIPageViewController.NavigationDirection = .forward
        if index < currentPageIndex{
            direction = .reverse
        }
        rootPageViewController.setViewControllerFromIndex(index: index, direction: direction)
        
        currentPageIndex = index
    }
}
