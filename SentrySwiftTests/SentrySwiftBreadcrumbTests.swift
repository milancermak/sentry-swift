//
//  SentrySwiftBreadcrumbTests.swift
//  SentrySwift
//
//  Created by Josh Holtz on 3/25/16.
//
//
import XCTest
import SentrySwift

class SentrySwiftBreadcrumbTests: XCTestCase {
	
	let client = SentryClient(dsnString: "https://username:password@app.getsentry.com/12345")!
	
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testGeneralCrumbs() {
		let dateString = "2011-05-02T17:41:36"
		let date = NSDate.fromISO8601(dateString)!
		
		let crumb = Breadcrumb(type: "some_type", timestamp: date, data: ["foo": "bar"])
		
		let serialized = crumb.serialized
		
		XCTAssertEqual(serialized["type"] as? String, "some_type")
		XCTAssertEqual(serialized["timestamp"] as? String, dateString)
	}
	
	func testBreadcrumbStorage() {
		
		let store = BreadcrumbStore()
		store.maxCrumbsForType = 3
		
		let test1 = Breadcrumb(message: "Test 1")
		let test2 = Breadcrumb(message: "Test 2")
		let test3 = Breadcrumb(message: "Test 3")
		let test4 = Breadcrumb(message: "Test 4")
		
		let view1 = Breadcrumb(to: "View 1")
		
		store.add(view1)
		XCTAssertEqual(store.get("navigation")?.count, 1)
		
		store.add(test1)
		XCTAssertEqual(store.get("message")?.count, 1)
		XCTAssertEqual(store.get("message")!, [test1])
		
		store.add(test2)
		XCTAssertEqual(store.get("message")?.count, 2)
		XCTAssertEqual(store.get("message")!, [test2, test1])
		
		store.add(test3)
		XCTAssertEqual(store.get("message")?.count, 3)
		XCTAssertEqual(store.get("message")!, [test3, test2, test1])
		
		store.add(test4)
		XCTAssertEqual(store.get("message")?.count, 3)
		XCTAssertEqual(store.get("message")!, [test4, test3, test2])
	}

}