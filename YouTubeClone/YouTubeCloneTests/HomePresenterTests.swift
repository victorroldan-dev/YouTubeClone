//
//  HomePresenterTests.swift
//  YouTubeCloneTests
//
//  Created by Victor Roldan on 18/09/22.
//

import XCTest
@testable import YouTubeClone

class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var sutDelegate : HomeViewMock!
    var provider : HomeProviderMock!
    
    @MainActor override func setUpWithError() throws {
        MockManager.shared.runAppWithMock = true
        sutDelegate = HomeViewMock()
        provider = HomeProviderMock()
        sut = HomePresenter(delegate: sutDelegate, provider: provider)
    }

    override func tearDownWithError() throws {
        sut = nil
        provider = nil
        sutDelegate = nil
    }

    func testGetHomeObjects_WhenLoad_ObjectsShoutBeInCorrectPosition() async throws {
        //Arrange
        
        //Act
        await sut.getHomeObjects()
        
        //Assert
        XCTAssertTrue(sutDelegate.objectList![0] is [ChannelModel.Items], "this first position should be of type ChannelModel.Items")
        XCTAssertTrue(sutDelegate.objectList![1] is [PlaylistItemsModel.Item], "this second position should be of type PlaylistItemsModel.Item")
        XCTAssertTrue(sutDelegate.objectList![2] is [VideoModel.Item], "this third position should be of type VideoModel.Item")
        XCTAssertTrue(sutDelegate.objectList![3] is [PlaylistModel.Item], "this fourth position should be of type PlaylistModel.Item")
        
    }
    
    func testGetHomeObjects_WhenLoad_SectionTitlesShouldBeCorrect() async throws {
        //Arrange
        let expectSectionTitle0 = ""
        let expectSectionTitle1 = "Curso de Swift Español - Clonando YouTube"
        let expectSectionTitle2 = "Uploads"
        let expectSectionTitle3 = "Created playlists"
        
        //Act
        await sut.getHomeObjects()
        
        //Assert
        XCTAssertEqual(sutDelegate.sectionTitleList![0], expectSectionTitle0)
        XCTAssertEqual(sutDelegate.sectionTitleList![1], expectSectionTitle1)
        XCTAssertEqual(sutDelegate.sectionTitleList![2], expectSectionTitle2)
        XCTAssertEqual(sutDelegate.sectionTitleList![3], expectSectionTitle3)
        
    }

    @MainActor
    func testGetHomeObjects_WhenLoad_ShouldFail() async throws {
        //Arrange
        MockManager.shared.runAppWithMock = false
        sutDelegate = HomeViewMock()
        provider = HomeProviderMock()
        provider.throwError = true
        sut = HomePresenter(delegate: sutDelegate, provider: provider)
        
        //Act
        await sut.getHomeObjects()
        
        //Asset
        XCTAssertTrue(sutDelegate.throwError)
    }

}

class HomeViewMock : HomeViewProtocol{
    var objectList : [[Any]]?
    var sectionTitleList : [String]?
    var throwError : Bool = false
    
    func getData(list: [[Any]], sectionTitleList: [String]) {
        objectList = list
        self.sectionTitleList = sectionTitleList
    }
    
    func loadingView(_ state: LoadingViewState) {
        
    }
    
    func showError(_ error: String, callback: (() -> Void)?) {
        throwError = true
    }
}
