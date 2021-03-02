//
//  LucidAnimationsSwiftTests.swift
//  LucidAnimationsSwiftTests
//
//  Created by Chandan Karmakar on 27/01/21.
//

import XCTest

class LucidAnimationsSwiftTests: XCTestCase {

    func testLucidGlobal() throws {
        let exp = expectation(description: #function)

        let view = UIView()
        let lucid = LucidAnim()
        lucid.isTesting = true
        lucid.anim { view.alpha = 0 }
        lucid.anim { view.alpha = 0 }
        lucid.anim { view.alpha = 0 }
        lucid.flat { exp.fulfill() }
        lucid.execute()
        
        waitForExpectations(timeout: 5) { (_) in
            XCTAssert(lucid.queue.isEmpty)
            XCTAssert(!lucid.backupQueue.isEmpty)
        }
    }
    
    func testLucidLocal() throws {
        let exp = expectation(description: #function)

        let view = UIView()
        let lucid = LucidAnim()
        lucid.isTesting = true
        lucid.anim { view.alpha = 0 }
        XCTAssert(lucid.currentValues == lucid.defaultValues)
        lucid.anim { view.alpha = 0 }
        lucid.anim { view.alpha = 0 }
        lucid.flat { exp.fulfill() }
        XCTAssert(lucid.currentValues == lucid.defaultValues)
        lucid.execute()
        
        waitForExpectations(timeout: 5) { (_) in
            XCTAssert(lucid.queue.isEmpty)
            XCTAssert(lucid.backupQueue.count == 4)
        }
    }
    
    func testLucidGloablSerial() throws {
        let exp = expectation(description: #function)

        let view = UIView()
        let lucid = LucidAnim()
        lucid.isTesting = true
        lucid.serially(count: 10, interval: 0.1, anim: { _ in view.alpha = 1 })
        lucid.flat { exp.fulfill() }
        XCTAssert(lucid.backupQueue.count == 11)
        lucid.execute()
        
        waitForExpectations(timeout: 5) { (_) in
            XCTAssert(lucid.queue.isEmpty)
            XCTAssert(!lucid.backupQueue.isEmpty)
        }
    }
    
    func testLucidLocalSerial() throws {
        let exp = expectation(description: #function)

        let view = UIView()
        let lucid = LucidAnim()
        lucid.isTesting = true
        lucid.serially(count: 10, interval: 0.1, anim: { _ in view.alpha = 1 })
        lucid.flat { exp.fulfill() }
        lucid.execute()
        
        waitForExpectations(timeout: 5) { (_) in
            XCTAssert(lucid.queue.isEmpty)
            XCTAssert(lucid.backupQueue.count == 11)
        }
    }
    
    func testLucidClear() throws {
        let view = UIView()
        let lucid = LucidAnim()
        lucid.isTesting = true
        lucid.serially(count: 10, interval: 0.1, anim: { _ in view.alpha = 1 })
        lucid.flat { }
        lucid.execute()
        lucid.clear()
        XCTAssert(lucid.queue.isEmpty)
        XCTAssert(lucid.backupQueue.isEmpty)
        XCTAssert(lucid.currentValues == lucid.defaultValues)
    }

}
