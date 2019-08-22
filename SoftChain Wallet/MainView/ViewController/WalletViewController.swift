//
//  WalletViewController.swift
//  SoftChain Wallet
//
//  Created by Jerry on 2018/8/6.
//  Copyright © 2018年 SoftChain Foundation Ltd. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var address: String?
    var balance: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAddressLabel), name: NSNotification.Name("walletAddress"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupImportBtn()
        getAccountBalance()
    }
    
    func setupImportBtn() {
        if UserWallet.instance.isLoggedIn {
            importBtn.isHidden = true
            deleteBtn.isHidden = false
        } else {
            importBtn.isHidden = false
            deleteBtn.isHidden = true
        }
    }
    
    func getAccountBalance() {
        guard address != nil else { return }
        GetQKCBalance.instance.getBalance(address: address!) { (success) in
            if success {
                self.balance = GetQKCBalance.instance.QKCBalance
                self.balanceLabel.text = "QKC: \((self.convertor(hex: self.balance!)/1e+18))"
                
            } else {
                print("Error to get balance")
                print(self.address as Any)
            }
        }
    }
    
    func convertor(hex: String) -> Double {
        var hexnumber = hex
        var decimalInt: Double
        if hexnumber != "" {
            hexnumber = hexnumber.replacingOccurrences(of: "0x", with: "")
            decimalInt = String.changeToInt(num: hexnumber)
            return decimalInt
        } else {
            return 0
        }
    }
    
    @objc func updateAddressLabel(notif: Notification) {
        
        guard let address = notif.object as? String else { return }
        addressLabel.text = address
        self.address = address
        print("function called")
    }
    
    @IBAction func importWallet(_ sender: Any) {
        performSegue(withIdentifier: TO_IMPORTVC, sender: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
    }
    
    
}


extension String {
    
    static func changeToInt(num: String) -> Double {
        let str = num.uppercased
        var sum: Double = 0
        for i in str().utf8 {
            sum = sum * 16 + Double(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
}
