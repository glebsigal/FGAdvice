//
//  ViewController.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import UIKit
import KYDrawerController

class ViewController: UIViewController, KYDrawerControllerDelegate {
    @IBOutlet weak var menuButton: UIButton!
    
    var defaultMenuFrame = CGRect(x:0,y:0,width:0,height:0)
    private var drawerController: KYDrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSources()
        self.initUI()

    }
    
    // MARK: - init functions
    
    func initSources() {
        self.initDrawer()
    }
    
    func initUI() {
        defaultMenuFrame = self.menuButton.frame
        self.drawerController?.containerViewTapGesture.view?.tag = 1002
        self.addViewTapGesture()
    }
    
    // MARK: - Menu's UI methods
    
    @IBAction func menuTapAction(_ sender: Any) {
        self.showMenu(state: true)
    }
    
    
    func initDrawer() {
        guard let drawer = self.navigationController?.parent as? KYDrawerController else {
            return
        }
        drawer.delegate = self
        self.drawerController = drawer
        
    }
    
    func addViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkTap(sender:)))
        self.drawerController?.containerViewTapGesture.view?.addGestureRecognizer(tapGesture)
    }
    
    func checkTap(sender:UITapGestureRecognizer) {
        if sender.view?.tag == 1002 {
            self.animateMenu(state: false)
            self.drawerController?.setDrawerState(.closed, animated: true)
        }
    }
    
    
    func showMenu (state:Bool) {
            animateMenu(state: true)
            self.drawerController?.setDrawerState(.opened, animated: true)
    
    }
    
    func animateMenu (state : Bool) {
        switch state {
        case true:
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.menuButton.frame.origin.x = self.defaultMenuFrame.origin.x + 210
            })
        case false:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.menuButton.frame.origin.x = self.defaultMenuFrame.origin.x
            })
        }
    }
    
    func drawerController(_ drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState) {
        if state == .closed {
            animateMenu(state: false)
        } else {
            animateMenu(state: true)
        }
    }
}

