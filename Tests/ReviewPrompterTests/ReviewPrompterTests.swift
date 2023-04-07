import XCTest
@testable import ReviewPrompter

final class ReviewPrompterTests: XCTestCase {

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open

	// # Private/Fileprivate
	private var sut: ReviewPrompter!
	private let identifier: String = "testEvent"

	// =======================================
	// MARK: Setup / Teardown
	// =======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = ReviewPrompter(minimumPromptInterval: 2)
		sut.stopTrackingEvent(forIdentifier: identifier)
		sut.deleteHistoryOfReviewPromptDates()
	}

	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}

	// =======================================
	// MARK: Tests
	// =======================================
	// ------------------------------------
	// MARK: increaseEventCount(forIdentifier: didRequestReview:)
	// ------------------------------------
	func testIncreaseEventCountWithReviewPrompting_ToLessThanCondition() throws {

		// EXPECT
		let expectation:XCTestExpectation = self.expectation(description: #function)

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)
		try sut.increaseEventCount(forIdentifier: identifier)

		// WHEN
		try sut.increaseEventCountWithReviewPrompting(forIdentifier: identifier, didRequestReview: { [weak self] didRequestReview in

			// THEN
			XCTAssertFalse(didRequestReview)
			guard let self else { XCTFail("Self is nil"); return }
			XCTAssertEqual(self.sut.eventCount(forIdentifier: self.identifier), 2)
			expectation.fulfill()
		})

		// WAIT
		waitForExpectations(timeout: 1.0) { (error) in
			print(String(describing: error?.localizedDescription))
		}
	}

	func testIncreaseEventCountWithRequestReview_ToEqualCondition() throws {

		// EXPECT
		let expectation:XCTestExpectation = self.expectation(description: #function)

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)
		try sut.increaseEventCount(forIdentifier: identifier)
		try sut.increaseEventCount(forIdentifier: identifier)

		// WHEN
		try sut.increaseEventCountWithReviewPrompting(forIdentifier: identifier, didRequestReview: { [weak self] didRequestReview in

			// THEN
			XCTAssertTrue(didRequestReview)
			// Event count gets reset automatically
			guard let self else { XCTFail("Self is nil"); return }
			XCTAssertEqual(self.sut.eventCount(forIdentifier: self.identifier), 0)
			expectation.fulfill()
		})

		// WAIT
		waitForExpectations(timeout: 1.0) { (error) in
			print(String(describing: error?.localizedDescription))
		}
	}

	//------------------------------------
	// MARK: hasEventMetCondition()
	//------------------------------------
	func testHasEventMetCondition() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)
		try sut.increaseEventCount(forIdentifier: identifier)
		try sut.increaseEventCount(forIdentifier: identifier)
		XCTAssertFalse(sut.hasEventMetCondition(forIdentifier: identifier))

		// WHEN
		try sut.increaseEventCount(forIdentifier: identifier)

		// THEN
		XCTAssertTrue(sut.hasEventMetCondition(forIdentifier: identifier))
	}

	// ------------------------------------
	// MARK: requestReview()
	// ------------------------------------
	func testRequestReview_ReturnsTrue() {

		// GIVEN
		sut.isLoggingEnabled = true // Increase code coverage
		sut.trackEvent(forIdentifier: identifier, withCondition: 2)

		// WHEN
		let result = sut.requestReviewPrompt()

		// THEN
		XCTAssertTrue(result)
	}

	func testRequestReview_SecondRequestIsTooSoon_ReturnsFalse() {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 2)

		// WHEN
		let result1 = sut.requestReviewPrompt()
		let result2 = sut.requestReviewPrompt()

		// THEN
		XCTAssertTrue(result1)
		XCTAssertFalse(result2)
	}
}
