//
//  TestTests.swift
//  TestTests
//
//  Created by v.sova on 05.07.2018.
//  Copyright © 2018 v.sova. All rights reserved.
//

import XCTest
@testable import Test
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

class TestTests: XCTestCase {
    
//    var feed: FeedPhotosViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        feed = FeedPhotosViewModel.init()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFeedPhotos() {
        
        let feed = FeedPhotosViewModel.init()
        
        do {
            let count = try feed.data.toBlocking().first()?.count
            XCTAssertEqual(count, 30)
        } catch {

            XCTFail(error.localizedDescription)
        }
    }
    
    func testLikePhoto() {
        
        let db = DBManager()
        let api = APIUnsplash.init(db)
        
        do {
            let result = try api.likePhoto("wtxhlHAkpuQ").toBlocking().first()
            XCTAssertEqual(result, true)
        } catch {
            
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUnlikePhoto() {

        let db = DBManager()
        let api = APIUnsplash.init(db)
        
        do {
            let result = try api.unlikePhoto("wtxhlHAkpuQ").toBlocking().first()
            XCTAssertEqual(result, true)
        } catch {
            
            XCTFail(error.localizedDescription)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}



















