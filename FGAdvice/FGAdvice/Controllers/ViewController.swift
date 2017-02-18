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
    @IBOutlet weak var mainAreaLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainAreaRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var shakeCenterConstraint: NSLayoutConstraint!
    
    var isExpanded = false
    var apiRoot = ApiRoot()
    private var drawerController: KYDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSources()
        
    }
    
    // MARK: - Init functions
    
    func initSources() {
        self.initDrawer()
        self.getAdvice()
    }
    
    //MARK: - Api's methods
    
    func getAdvice() {
        self.showHud()
        apiRoot.getRandomAdvice(completionHandler: { (advice, error) in
            self.hideHud()
            if advice != nil {
                self.mainTextView.text = advice?.text
            }
        })
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
                self.view.layoutIfNeeded()
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
    loadingNotification.label.text = "Loading"
    }
    
    func hideHud() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

