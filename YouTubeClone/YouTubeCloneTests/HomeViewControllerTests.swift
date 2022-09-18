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
    
    override func setUpWithError() throws {
        sut = HomeViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testHeaderInfoTableView_ShouldContain_ChannelInfo() throws {
        //Arrange
        let tableView = try XCTUnwrap(sut.tableViewHome, "you should create this IBOutlet")
        
        let expLadingData = expectation(description: "loading")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
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
}
