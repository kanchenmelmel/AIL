//
//  VideoCoursesController.swift
//  AIL
//
//  Created by Wenyu Zhao on 21/9/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//

import UIKit

class VideoCourseCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    func setVideoTitle(_ title: String) {
        self.title.text = title
    }
}


class VideoCoursesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoCourseCell
        //cell?.textLabel?.text = "测试数据\(indexPath.row)"
        cell.setVideoTitle("Video Title 1")
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
    }
}
