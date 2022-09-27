//
//  HomeViewControllerTests.swift
//  YouTubeCloneTests
//
//  Created by Victor Roldan on 18/09/22.
//

import XCTest
@testable import YouTubeClone

class HomeViewControllerTests: XCTestCase {
    var sut: HomeViewController!
    var provider : HomeProviderProtocol!
    var waiting : TimeInterval = 0.2
    
    @MainActor
    override func setUpWithError() throws {
        PresentMockManger.shared.vc = nil
        provider = HomeProviderMock()
        sut = HomeViewController()
        sut.presenter = HomePresenter(delegate: sut, provider: provider)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        PresentMockManger.shared.vc = nil
        provider = nil
    }

    func testHeaderInfoTableView_ShouldContain_ChannelInfo() throws {
        //Arrange
        let tableView = try XCTUnwrap(sut.tableViewHome, "you should create this IBOutlet")
        
        let expLadingData = expectation(description: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+waiting) {
            expLadingData.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        guard let header = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? ChannelCell else{
            XCTFail("The first position should be the ChannelCell")
            return
        }
        let expectedTitle = "Victor Roldan Dev"
        let expectedSubscriberButton = "SUBSCRIBED"
        let subs = "383 subscribers · 43 videos"
        
        //Act
        
        //Assert
        XCTAssertEqual(expectedTitle, header.channelTitle.text, "-")
        XCTAssertEqual(expectedSubscriberButton, header.subscribeLabel.text, "-")
        XCTAssertEqual(subs, header.subscriberNumbersLabel.text, "-")
    }
    
    func testVideoSection_ValidateItsContent() throws{
        //Arrange
        let tableView = try XCTUnwrap(sut.tableViewHome, "you should create this IBOutlet")
        
        let expLadingData = expectation(description: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+waiting) {
            expLadingData.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        guard let videCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else{
            XCTFail("The first position should be the VideoCell")
            return
        }
        
        let videoName = try XCTUnwrap(videCell.videoName, "you should create this IBOutlet")
        
        XCTAssertNotNil(videoName.text)
        XCTAssertNotNil(videCell.videoImage)
        XCTAssertNotNil(videCell.channelName.text)
        XCTAssertNotNil(videCell.viewsCountLabel.text)
    }
    
    func testVideoSection_ValidateIfThreeDotsButton_HasAction() throws{
        //Arrange
        let tableView = try XCTUnwrap(sut.tableViewHome, "you should create this IBOutlet")
        
        let expLadingData = expectation(description: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+waiting) {
            expLadingData.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        guard let videoCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else{
            XCTFail("The first position should be the VideoCell")
            return
        }
        let dotsButton = try XCTUnwrap(videoCell.dotsButton)
        let dotsActions = try XCTUnwrap(
            dotsButton.actions(
                forTarget:videoCell,
                forControlEvent: .touchUpInside)
        )
        
        XCTAssertEqual(dotsActions.count, 1)
    }
    
    func testShareButtonPressed_ShouldPushTo_HomeViewController() throws {
        //Arrange
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var sut = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        sut.loadViewIfNeeded()
        
        let navigationMock = NavigationControllerMock(rootViewController: sut)
        
        //Act
        sut.shareButtonPressed()
        guard let vc = navigationMock.pushedVC as? HomeViewController else{
            XCTFail("falló")
            return
        }
        
        //Assert
        XCTAssertTrue(vc.isKind(of: HomeViewController.self))
    }
    
    
    func testVideoSection_OpenBottomSheet() throws{
        //Arrange
        let tableView = try XCTUnwrap(sut.tableViewHome, "you should create this IBOutlet")
        
        let expLadingData = expectation(description: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+waiting) {
            expLadingData.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        guard let videoCell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? VideoCell else{
            XCTFail("The first position should be the VideoCell")
            return
        }
        let dotsButton = try XCTUnwrap(videoCell.dotsButton)
        dotsButton.sendActions(for: .touchUpInside)
        
        //Assert
        XCTAssertTrue(PresentMockManger.shared.vc.isKind(of: BottomSheetViewController.self))
        
    }
}

class NavigationControllerMock : UINavigationController{
    var pushedVC : UIViewController!
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushedVC = viewController
    }
}

fileprivate class PresentMockManger{
    static var shared = PresentMockManger()
    init(){}
    var vc : UIViewController!
}

extension HomeViewController{
    override open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil){
        super.present(viewControllerToPresent, animated: flag)
        PresentMockManger.shared.vc = viewControllerToPresent
    }
}
