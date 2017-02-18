//
//  ViewController.swift
//  FGAdvice
//
//  Created by Gleb Sigal on 18.02.17.
//  Copyright © 2017 dutchwheel. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView:UITableView?
    let tagList = ["Дизайнеру", "Кодеру", "Верстальщику", "Фотографу", "Копирайтеру", "Маркетологу",
                   "Сеошнику", "Водителю", "Музыканту", "Фокуснику", "Врачу", "Студенту", "За жизнь",
                   "Для нее", "Для него"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
     
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = tagList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.tableHeaderView?.tintColor = UIColor.white
        return "Категории"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    

}

