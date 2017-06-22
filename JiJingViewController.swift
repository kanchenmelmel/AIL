//
//  JiJingViewController.swift
//  AIL
//
//  Created by Wenyu Zhao on 10/2/17.
//  Copyright © 2017 au.com.melmel. All rights reserved.
//
import UIKit
import M13PDFKit

class JiJingViewController: UITableViewController {

    let folders: [String] = [
        "listening",
        "speaking",
        "reading",
        "writing",
    ]
    let files: [String:[String]] = [
        "listening": [
            "Write from Dictation 17-5",
        ],
        "speaking": [
            "Answer short question",
            "Describe Image 17-5",
            "Read aloud 23-3",
            "Repeat Sentence 23-3",
        ],
        "reading": [
            "Reading Fill in the Blanks 18-5",
            "Reorder paragraphs 23-3",
        ],
        "writing": [
            "Summarize Written Text",
            "Write Essay",
        ],
    ]
    
    func pdfFile(for sender: UITableViewCell) -> (String, String) {
        let index = self.tableView.indexPath(for: sender)
        let folder = folders[index![0]]
        let file = files[folder]![index![1]]
        return (file, Bundle.main.path(forResource: "JiJingPDF/\(folder)/\(file)", ofType: "pdf")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewer: PDFKBasicPDFViewer = segue.destination as! PDFKBasicPDFViewer
        viewer.enableBookmarks = true
        viewer.enableOpening = true
        viewer.enablePreview = true
        viewer.enableSharing = false
        viewer.enablePrinting = false
        viewer.enableThumbnailSlider = true
        
        let (filename, url) = pdfFile(for: sender as! UITableViewCell)
        let document: PDFKDocument = PDFKDocument(contentsOfFile: url, password: nil)
        
        segue.destination.navigationItem.title = filename
        
        viewer.loadDocument(document)
    }
}
