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
            "Write from Dictation",
            "Write from Dictation 2",
        ],
        "speaking": [
            "Answer short question",
            "Describe Image updated",
            "Read aloud",
            "Read aloud 2",
            "Repeat Sentence",
            "Repeat Sentence 2",
        ],
        "reading": [
            "Reading & Writing Fill in the blanks",
            "Reorder paragraphs",
            "Reorder paragraphs 2",
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
