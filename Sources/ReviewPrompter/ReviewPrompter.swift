import Foundation
import StoreKit
import EventTracker

/// `ReviewPrompter` tracks the occurences of named events and prompts the user to review the app when the number of events is equal to the `condition`
open class ReviewPrompter: EventTracker {

	//------------------------------------
	// MARK: Properties
	//------------------------------------
	// # Public/Internal/Open
	/// The minimum number of seconds between each prompt
	public let minimumPromptInterval: TimeInterval

	// # Private/Fileprivate
	/// A identifier for storing prompt `Date`s in UserDefaults
	static private let kDatesKEY: String = "EventTracker_Dates"

	//------------------------------------
	// MARK: Initilisers
	//------------------------------------
	/// Initialise an instance
	/// - Parameters:
	///   - minimumPromptInterval: The minimum number of seconds between each prompt.
	///   - isLoggingEnabled: If `true`, log messages will be printed out, defaults to `false`.
	public init(minimumPromptInterval: TimeInterval,
				isLoggingEnabled: Bool = false) {
		self.minimumPromptInterval = minimumPromptInterval
		super.init(isLoggingEnabled: isLoggingEnabled)
	}

	//=======================================
	// MARK: Public Methods
	//=======================================
	/// Requests a review prompt regardless of if a condition has been met.
	///
	/// - This function is used internally when a condition has been met if using `increaseEventCountWithReviewPrompting()`.
	/// - This function can be called to request a review prompt when the caller is using `increaseEventCount()` directly and then checking `hasEventMetCondition()`.
	/// - This function can be called at any time to trigger a review request and the request date will be stored so as not to prompt again automatically before the `minimumPromptInterval`.
	///
	/// - Returns: A boolean indicating whether the review prompt was requested or not.
	open func requestReviewPrompt() -> Bool {

		var intervalSinceLastPrompt: TimeInterval = 0
		guard shouldRequestReviewPrompt(intervalSinceLastPrompt: &intervalSinceLastPrompt) else {
			if isLoggingEnabled {
				print("<ReviewPrompter> Will NOT request ReviewPrompt. intervalSinceLastPrompt: \(intervalSinceLastPrompt), minimumPromptInterval: \(minimumPromptInterval)")
			}
			return false
		}

		if isLoggingEnabled {
			print("<ReviewPrompter> Will request ReviewPrompt. intervalSinceLastPrompt: \(intervalSinceLastPrompt), minimumPromptInterval: \(minimumPromptInterval)")
		}

		// Request a Review Prompt. StoreKit might decide we can't prompt.
		SKStoreReviewController.requestReview()

		// Store Date
		var storedPromptDates = self.storedPromptDates()
		storedPromptDates.append(Date())
		UserDefaults.standard.set(storedPromptDates, forKey: ReviewPrompter.kDatesKEY)
		return true
	}

	// =======================================
	// MARK: Inherited Methods
	// =======================================
	//------------------------------------
	// MARK: Tracking
	//------------------------------------
	/// Increases the event count and requests a review prompt if the condition is met.
	///
	/// Once the event count has been increased this method will check if the event condition has been met and if so, will attempt to request a review prompt and if the review is requested will then reset the event count for the given identifier. If a review prompt was requested this will be indicated in the closure.
	///
	/// - Parameters:
	///   - identifier: The identifier for the event
	///   - didRequestReview: A closure that is called with a boolean indicating whether the review prompt was requested or not.
	/// - Throws: An error if increasing the event count or resetting the event count fails.
	open func increaseEventCountWithReviewPrompting(forIdentifier identifier: String, didRequestReview: @escaping (Bool) -> Void) throws {

		try increaseEventCount(forIdentifier: identifier)
		if hasEventMetCondition(forIdentifier: identifier) {
			let didRequest = requestReviewPrompt()
			if didRequest {
				try resetEventCount(forIdentifier: identifier)
			}
			didRequestReview(didRequest)
		} else {
			didRequestReview(false)
		}
	}

	//------------------------------------
	// MARK: Resetting
	//------------------------------------
	/// Delete the history of dates when the user has been prompted to review the app
	open func deleteHistoryOfReviewPromptDates() {
		UserDefaults.standard.removeObject(forKey: ReviewPrompter.kDatesKEY)
	}

	//=======================================
	// MARK: Private Methods
	//=======================================
	/// Determines whether a review prompt should be requested based on the time elapsed since the last prompt.
	/// - Parameter intervalSinceLastPrompt: The time interval since the last prompt.
	/// - Returns: A boolean value indicating whether a review prompt should be requested.
	private func shouldRequestReviewPrompt(intervalSinceLastPrompt: inout TimeInterval) -> Bool {
		let storedPromptDates = self.storedPromptDates()
		guard let lastPromptDate = storedPromptDates.last else {
			return true
		}
		intervalSinceLastPrompt = -lastPromptDate.timeIntervalSinceNow
		return intervalSinceLastPrompt >= minimumPromptInterval
	}

	/// Retrieves the stored prompt dates from UserDefaults.
	/// - Returns: An array of `Date` objects representing the dates when review prompts were shown.
	private func storedPromptDates() -> [Date] {
		if let dates = UserDefaults.standard.object(forKey: ReviewPrompter.kDatesKEY) as? [Date] {
			return dates
		}
		return []
	}
}
