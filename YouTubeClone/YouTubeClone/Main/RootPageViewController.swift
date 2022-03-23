//
//  RootPageViewController.swift
//  YouTubeClone
//
//  Created by Victor Roldan on 23/02/22.
//

import UIKit

enum ScrollDirection{
    case goingLeft
    case goingRight
}

protocol RootPageProtocol : AnyObject{
    func currentPage(_ index : Int)
    func scrollDetails(direction: ScrollDirection, percent: CGFloat, index: Int)
}

class RootPageViewController: UIPageViewController{
    
    var subViewControllers = [UIViewController]()
    var currentIndex : Int = 0
    weak var delegateRoot : RootPageProtocol?
    var startOffset : CGFloat = 0.0
    var currentPage : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        delegateRoot?.currentPage(0)
        setupViewControllers()
        setScrollViewDelegate()
    }
    
    private func setupViewControllers(){
        subViewControllers = [
            HomeViewController(),
            VideosViewController(),
            PlaylistsViewController(),
            ChannelViewController(),
            AboutViewController(),
        ]
        
        _ = subViewControllers.enumerated().map({$0.element.view.tag = $0.offset})
        setViewControllerFromIndex(index: 0, direction: .forward)
    }
    
    func setViewControllerFromIndex(index : Int, direction: NavigationDirection, animated: Bool = true){
        setViewControllers([subViewControllers[index]], direction: direction, animated: animated)
        
    }
    
    private func setScrollViewDelegate(){
        guard let scrollView = view.subviews.filter({$0 is UIScrollView}).first as? UIScrollView else {return}
        scrollView.delegate = self
    }
}

extension RootPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index : Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if index <= 0{
            return nil
        }
        return subViewControllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index : Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if index >= (subViewControllers.count-1){
            return nil
        }
        return subViewControllers[index+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("finshed: ", finished)
        if let index = pageViewController.viewControllers?.first?.view.tag{
            currentIndex = index
            delegateRoot?.currentPage(index)
        }
    }
}

extension RootPageViewController : UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
        print("startOffset: \(startOffset)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction = 0 //Scroll stopped
        if startOffset < scrollView.contentOffset.x{
            direction = 1 //right
        }else if startOffset > scrollView.contentOffset.x{
            direction = -1 //left
        }
        
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage /  self.view.frame.width
        delegateRoot?.scrollDetails(direction: (direction == 1) ? .goingRight : .goingLeft, percent: percent, index: currentPage)
        print("percent: \(percent)")
        print("direction: \(direction)")
    }
}
