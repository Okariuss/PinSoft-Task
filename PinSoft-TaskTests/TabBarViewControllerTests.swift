//
//  TabBarViewControllerTests.swift
//  PinSoft-TaskTests
//
//  Created by Okan Orkun on 3.03.2024.
//

import XCTest
@testable import PinSoft_Task

final class TabBarViewControllerTests: XCTestCase {

    var test: TabBarViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        test = TabBarViewController()
        test.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        test = nil
        super.tearDown()
    }

    func testTabBarHasTwoItems() {
        XCTAssertEqual(test.viewControllers?.count, 2, "TabBar should have two view controllers.")
    }

    func testTabBarFirstItemIsHomeScreenViewController() {
        let firstViewController = test.viewControllers?.first as? UINavigationController
        XCTAssertTrue(firstViewController?.topViewController is HomeScreenViewController, "The first tab should contain HomeScreenViewController.")
    }

    func testTabBarSecondItemIsFavoriteScreenViewController() {
        let secondViewController = test.viewControllers?.last as? UINavigationController
        XCTAssertTrue(secondViewController?.topViewController is FavoriteScreenViewController, "The second tab should contain FavoriteScreenViewController.")
    }
}
