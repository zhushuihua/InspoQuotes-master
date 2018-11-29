//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit
class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver{
    
    let productID = "xyz.mymaths.InspoQuotes.PremiumQuotes"
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        if(UserDefaults.standard.bool(forKey: productID))
        {
            showPremium()
        }
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(UserDefaults.standard.bool(forKey: productID))
        {
            return quotesToShow.count
        }
        return quotesToShow.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        // Configure the cell...
        if indexPath.row < quotesToShow.count
        {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else
        {
            cell.textLabel?.text = "Get More Quotes."
            cell.textLabel?.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count
        {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func buyPremiumQuotes()
    {
        if SKPaymentQueue.canMakePayments()
        {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            ProgressHUD.show("Purchasing", interaction: false)
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if(transactions.count == 0)
        {
            print("nothing to restore at all")
        }
        for transaction in transactions
        {
            if transaction.transactionState == .purchased{
                showPremium()
                SKPaymentQueue.default().finishTransaction(transaction)
                 //ProgressHUD.showSuccess("Purchased Successfully")
            }
            else if transaction.transactionState == .failed
                {
                    SKPaymentQueue.default().finishTransaction(transaction)
                    ProgressHUD.showError("Failed to purchase", interaction: true)
            }
            else if transaction.transactionState == .restored
            {
                showPremium()
                SKPaymentQueue.default().finishTransaction(transaction)
                ProgressHUD.showSuccess("Restored Successfully")
            }
        }
    }
    func showPremium()
    {
        quotesToShow.append(contentsOf: premiumQuotes)
        UserDefaults.standard.setValue(true, forKey: productID)
        navigationItem.setRightBarButton(nil, animated: true)
        tableView.reloadData()
    }
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
        /// when the user never purchase the item...
        /// the delegate will not be triggered at all...
    }
}
