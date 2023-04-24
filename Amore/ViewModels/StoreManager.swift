//
//  StoreManager.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/28/22.
//  Refer tutorial https://blckbirds.com/post/how-to-use-in-app-purchases-in-swiftui-apps/ if you want to learn

import Foundation
import StoreKit
import Firebase

// To fetch the products, we adapt the NSObject and SKProductsRequestDelegate protocols.
class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var productIDs = [
        //Use your product IDs instead
        "Amore.ProductId.3.SuperLikes.v3",
        "Amore.ProductId.5.SuperLikes.v3",
        "Amore.ProductId.10.SuperLikes.v3",
        "Amore.ProductId.1.Boosts.v3",
        "Amore.ProductId.2.Boosts.v3",
        "Amore.ProductId.3.Boosts.v3",
        "Amore.ProductId.5.Messages.v3",
        "Amore.ProductId.10.Messages.v3",
        "Amore.ProductId.15.Messages.v3",
        "Amore.ProductId.2.Rewinds.v3",
        "Amore.ProductId.5.Rewinds.v3",
        "Amore.ProductId.10.Rewinds.v3",
        "Amore.ProductId.1M.Gold.v3",
        "Amore.ProductId.3M.Gold.v3",
        "Amore.ProductId.6M.Gold.v3"]
    
    let db = Firestore.firestore()
    
    // Initalized from the Apples In App Purchase Model.
    @Published var superLikesPricing: [String: SKProduct] = [:]
    @Published var boostsPricing: [String: SKProduct] = [:]
    @Published var messagesPricing: [String: SKProduct] = [:]
    @Published var rewindsPricing: [String: SKProduct] = [:]
    @Published var amoreGoldPricing: [String: SKProduct] = [:]
    @Published var amorePlatinumPricing: [String: SKProduct] = [:]
    
    
    // Initalized with data from firestore
    @Published var purchaseDataDetails = ConsumableCountAndSubscriptionModel()
//    @Published var oldpurchaseDataDetails = ConsumableCountAndSubscriptionModel()
    // This field is used to hold payment when user initaes a payment but it's not complete
    @Published var tempPurchaseHold = ConsumableCountAndSubscriptionModel()
    @Published var paymentCompleteDisplayMyAmore : Bool = false
    @Published var displayProductModalWindow : Bool = false
    var purchaseDataFetched = false
    
    // SKProductsRequest property in our StoreManager, which we will use to start the fetching process
    var request: SKProductsRequest!
    
    // Sends a request to the Apple servers based on given product IDs. At the same time we use the StoreManager class itself as the delegate of the request  so that the request knows that the didReceive response method should be called as soon as the Apple servers send a response.
    // Get Products from IAP
    func getProducts() {
//        print("Store Manager: Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    // didReceive response method
    // To conform to the SKProducutsRequestDelegate, we add the following function to our class
    // As soon as we receive a response from App Store Connect, this function is called.
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Store Manager: Did receive response")
        // we check if the response also contains produts
        if !response.products.isEmpty {
            // If we are sure that we have received products, we can add any of these products to our myProducts array using a for-in loop.
            for fetchedProduct in response.products {
//                print("Product List " + fetchedProduct.localizedTitle)
                DispatchQueue.main.async {
                    // Localized Titles Are Stored in Apple InApp Purchase Developer account
                    // Please make sure Localized Titles are always same even when you create new products
                    // other wise the application will break
                    if fetchedProduct.localizedTitle.contains("Super Likes") {
                        self.superLikesPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Boosts") {
                        self.boostsPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Messages") {
                        self.messagesPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Rewinds") {
                        self.rewindsPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Amore Gold") {
                        self.amoreGoldPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    } else if fetchedProduct.localizedTitle.contains("Amore Platinum") {
                        self.amorePlatinumPricing[fetchedProduct.localizedTitle] = fetchedProduct
                    }
                }
            }
        }
        
        // If for some reason our response contains product IDs that are invalid, we want to be notified. We use a corresponding for-in loop for this purpose as well.
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Store Manager: Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
    // Notifies that we got no response from Apple servers & the request fails
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Store Manager: Request did fail: \(error)")
    }
    
    //HANDLE TRANSACTIONS - state of a transaction
    @Published var transactionState: SKPaymentTransactionState?
    
    // Once we have started a transaction(paymentQueue), this function is called every time something changes in the status of the transaction(s) currently processed.
    func purchaseProduct(product: SKProduct) {
        // Make sure a user can start the transaction. Eg. a parent control is setup
        if SKPaymentQueue.canMakePayments() {
            // Start the payment process using SKPayment & add it to the queue
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("Store Manager: User can't make payment.")
        }
    }
    
    // start the purchase process as soon as the user taps on the respective “Purchase” Button.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                transactionState = .purchasing
            case .purchased:
                // UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                queue.finishTransaction(transaction)
                transactionState = .purchased
                // Only store data in firebase when payment is successfull
                // If Purchase is Successfull, update the new purchase data
                // Check if the object is not nil & the call is being actually done by the user
                if self.purchaseDataDetails.subscriptionTypeId != nil && self.purchaseDataDetails != self.tempPurchaseHold {
                    self.purchaseDataDetails = self.tempPurchaseHold
                    // Store the details of consumables and subscription to firebase
                    _ = self.storePurchaseNoParams()
                    // Store the transaction in payment activity
                    _ = self.storePurchaseActivityDetails(transaction:transaction)
                }
            case .restored:
                // UserDefaults.standard.setValue(true, forKey: transaction.payment.productIdentifier)
                self.getPurchase()
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                print("Store Manager: Payment Queue Error: \(String(describing: transaction.error))")
                self.tempPurchaseHold = self.purchaseDataDetails
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    // Restore the purchase
    func restoreProducts() {
        print("Store Manager: Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // ************ Save Purchase to Firestore ********** //
    
    // Call this function to store the user purchase data into firebase
    func storePurchase(product: ConsumableCountAndSubscriptionModel) -> Bool {
        
        if let userId = Auth.auth().currentUser?.uid {
            do {
                _ = try db.collection("InAppPurchase").document(userId).setData(from: product)
                return true
            }
            catch let error {
                print("storePurchase: Can't store the purchase data in firestore: \(error)")
            }
            self.tempPurchaseHold = self.purchaseDataDetails
        } else {
            print("No User Id")
        }
        return false
    }
    
    // Call this function to store the details of the payment which was just made
    func storePurchaseActivityDetails(transaction:SKPaymentTransaction) -> Bool  {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss 'UTC'"
        if let userId = Auth.auth().currentUser?.uid {
            do {
                _ = try db.collection("InAppPurchase").document(userId).collection("PurchaseActivity")
                    .addDocument(data: ["timeOfPurchase": Date(),
                                        "productRefernceId": transaction.payment.productIdentifier])
                self.paymentCompleteDisplayMyAmore = true
                return true
            }
            catch let error {
                print("storePurchase: Can't store the purchase activity in firestore: \(error)")
            }
        } else {
            print("No User Id")
        }
        return false
    }
    
    
    // Call this function when you want to store firestore object without an object
    func storePurchaseNoParams() -> Bool {
        return self.storePurchase(product:self.purchaseDataDetails)
    }
    
    // Call this function when you don't want to pass an object to be stored
    func storePurchaseWithParams(product:ConsumableCountAndSubscriptionModel) -> Bool {
        return self.storePurchase(product:product)
    }
    
    // Get the purchase data to firebase
    func getPurchase() {
        
        self.purchaseDataFetched = false
        let collectionRef = db.collection("InAppPurchase")
        if let documentId = Auth.auth().currentUser?.uid {
            let docRef = collectionRef.document(documentId)
            // Get Data from Firestore. Network Action -- Async Behaviour at this point
             .getDocument { [self] document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            // Get User Purchase Data from firestore
                            self.purchaseDataDetails = try document.data(as: ConsumableCountAndSubscriptionModel.self) ?? ConsumableCountAndSubscriptionModel()
                            self.tempPurchaseHold = self.purchaseDataDetails
                            self.purchaseDataFetched = true
                            // Check user subscription and if user subscriptions need to be updated
                            self.checkDailySubscriptionIncrement()
                        }
                        catch {
                            print(error)
                            self.purchaseDataFetched = false
                        }
                    } // if document
                } // else
            } // docref
        } // documentID
    } // getPurchase
    
    
    // Call this function when you want to check if the subscription of the user qualifies for a daily increment on Super Likes, No of messages and Boost count.
    // A User on Free Subscription will not get an increment on their consumables
    // A User with Paid Subscription will get a increment on cosumables
    // Under Amore Gold Plan a user will get
    /// 5 Super likes everyday
    /// 1 Boost a day
    /// 3 messages everyday
    func checkDailySubscriptionIncrement() {
        // if False:
        // update the InAppPurchase for the user
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        if let subscriptionUpdatedDateTime = self.purchaseDataDetails.subscriptionUpdateDateTime {
            let todaysDate = dateFormatter.string(from: Date())
            let lastFirestoreUpdate = dateFormatter.string(from: subscriptionUpdatedDateTime)
            // Check if last firestore update wasn't today
            if todaysDate != lastFirestoreUpdate{
                // Get the user subscription
                let subscriptionId = self.purchaseDataDetails.subscriptionTypeId ?? ""
                // Check if the plan is a Paid Plan like Amore Gold
                if subscriptionId.contains("Gold") {
                    // Boosts are only update once a month therefore it's necessary to only update once a month if subscription is active
                    // Check when was subcription purchased to count current month from upgrade to perform monthly consumables upgrade
                    if let subscriptionPurchaseDateTime = self.purchaseDataDetails.subscriptionPurchaseDateTime {
                        var monthlyBoostCount = self.purchaseDataDetails.subscriptonBoostCount ?? 0
                        // Calculate number of months passed since sunscription was purchased
                        let dateDiffs = Calendar.current.dateComponents([.year, .month, .day],
                                                                           from: subscriptionPurchaseDateTime,
                                                                           to: Date())
                        var subscriptionUpdatedForMonth = self.purchaseDataDetails.subscriptionUpdatedForMonth ?? 0
                        let monthsAfterSubscription = (dateDiffs.month ?? 0)+1 //+1 for first month; otherwise differnece is 0
                        if monthsAfterSubscription > (self.purchaseDataDetails.subscriptionUpdatedForMonth ?? 0) {
                            // Only update monthly consumables
                            monthlyBoostCount = 1
                        }
                        
                        // monthlyBoostCount will be either 0 or 1 depending if it's a new month
                        self.updateDailySubscriptions(dailySuperLike:5,
                                                      monthlyBoostCount: monthlyBoostCount,
                                                      dailyMessageCount: 2,
                                                      dailyRewindCount:3,
                                                      subscriptionUpdatedForMonth:monthsAfterSubscription)
                    }
                } else {
                    print("User has free subscription and doesn't IAP doesn't needs to be updated")
                    self.updateDailySubscriptions(dailySuperLike:1,
                                                  monthlyBoostCount: 0,
                                                  dailyMessageCount: 0,
                                                  dailyRewindCount:1,
                                                  subscriptionUpdatedForMonth:self.purchaseDataDetails.subscriptionUpdatedForMonth ?? 0)
                }
            }
        } else {
            // The User IAP storage doesn't have a date. Error
            print("Why user doesn't have a date stored in firestore ?")
            // Adding date and pushing to user IAP Purchases in firestore
            self.updateDailySubscriptions(dailySuperLike:1,
                                          monthlyBoostCount: 0,
                                          dailyMessageCount: 0,
                                          dailyRewindCount:1,
                                          subscriptionUpdatedForMonth:self.purchaseDataDetails.subscriptionUpdatedForMonth ?? 0)
        }
        
    }
    
    // User this function to update firestore with new daily subscription counts
    func updateDailySubscriptions(dailySuperLike:Int, monthlyBoostCount:Int, dailyMessageCount:Int, dailyRewindCount:Int, subscriptionUpdatedForMonth:Int) {
        self.purchaseDataDetails.subscriptionSuperLikeCount = dailySuperLike
        self.purchaseDataDetails.subscriptionMessageCount = dailyMessageCount
        self.purchaseDataDetails.subscriptonBoostCount = monthlyBoostCount
        self.purchaseDataDetails.subscriptionRewindsCount = dailyRewindCount
        self.purchaseDataDetails.subscriptionUpdatedForMonth = subscriptionUpdatedForMonth
        self.purchaseDataDetails.subscriptionUpdateDateTime = Date()
        _ = self.storePurchaseNoParams()
    }
    
}


extension SKProduct {

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var isFree: Bool {
        price == 0.00
    }

    var localizedPrice: String? {
        guard !isFree else {
            return nil
        }
        
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale

        return formatter.string(from: price)
    }

}
