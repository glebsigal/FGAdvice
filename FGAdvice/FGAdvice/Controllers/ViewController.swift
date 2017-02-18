//
//  ViewController.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import UIKit
import KYDrawerController
import MBProgressHUD

class ViewController: UIViewController, KYDrawerControllerDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var mainAreaLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainAreaRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var shakeCenterConstraint: NSLayoutConstraint!
    
    var isExpanded = false
    var apiRoot = ApiRoot()
    private var drawerController: KYDrawerController?
    let denyArray = ["<", "#"]
    var categoryName = "С цензурой"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSources()
        self.initUI()
    }
    
    // MARK: - Init functions
    
    func initSources() {
        self.initDrawer()
        self.getAdvice()
        self.initObserver()
        self.becomeFirstResponder()
    }
    
    func initUI () {
        self.animateShakeLabel()
    }
    
    func initObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlerTag(notif:)), name: NSNotification.Name(rawValue: "TagChanged"), object: nil)
    }
    
    //MARK: - Api's methods and work with them
    
    func getAdvice() {
        self.showHud()
        apiRoot.getRandomAdvice(tag:categoryName, completionHandler: { (advice, error) in
            self.hideHud()
            if advice != nil {
                self.replaceText(string: advice!.text!)
            }
        })
    }
    
    func replaceText(string:String) {
        for element in denyArray {
            if string.lowercased().range(of:element) != nil {
                self.getAdvice()
            }
        }
        let newString = string.replacingOccurrences(of: "&nbsp;", with: " ")
        self.mainTextView.text = newString
    }
    
    
    func handlerTag(notif: NSNotification) {
        categoryName = notif.userInfo!["newTag"] as! String
        self.tagLabel.text = categoryName.uppercased()
        self.drawerController?.setDrawerState(.closed, animated: true)
        self.getAdvice()
    }
    
    //MARK: - Motion methods
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.getAdvice()
        }
    }
    
    // MARK: - Menu's UI methods
    
    @IBAction func menuTapAction(_ sender: Any) {
        self.drawerController?.setDrawerState(.opened, animated: true)
    }
    
    
    func initDrawer() {
        guard let drawer = self.navigationController?.parent as? KYDrawerController else {
            return
        }
        drawer.delegate = self
        drawer.drawerWidth = self.view.frame.width / 2
        self.drawerController = drawer
        
    }
    
    func animateMenu (state : Bool) {
        switch state {
        case true:
            self.menuLeftConstraint.constant = self.view.frame.width/2 + 15
            self.mainAreaLeftConstraint.constant = self.view.frame.width/2 + 15
            self.shakeCenterConstraint.constant = self.view.frame.width/2 + 15
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x:0,y:0,width:self.view.frame.width+self.mainAreaLeftConstraint.constant,height:self.view.frame.height)
                if self.isExpanded != true {
                self.view.layoutIfNeeded()
                }
                self.menuButton.setImage(UIImage(named: "arrow"), for: UIControlState.normal)
                self.isExpanded = true
            })
        case false:
            self.menuLeftConstraint.constant = 0
            self.mainAreaLeftConstraint.constant = 0
            self.shakeCenterConstraint.constant = 0
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
                self.isExpanded = false
            })
        }
    }
    
    
    func drawerController(_ drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState) {
        if state == .closed {
            animateMenu(state: false)
        } else {
            if isExpanded == false {
            animateMenu(state: true)
            }
        }
    }
    
    // Mark: - other UI methods
    
    func showHud() {
    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
    loadingNotification.mode = MBProgressHUDMode.indeterminate
    loadingNotification.label.text = "Загрузка, бро"
    }
    
    func hideHud() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // Shake label animations (Fix this)
    func animateShakeLabel() {
    self.view.layoutIfNeeded()
    self.shakeLabel.layer.removeAllAnimations()
    UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
    self.shakeLabel.frame.origin.x = self.shakeLabel.frame.origin.x + 20
    }, completion: nil)
}
}

