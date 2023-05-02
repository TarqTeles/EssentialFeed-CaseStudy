//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 02/05/23.
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    private let viewModel: ImageCommentViewModel
    
    public init(viewModel: ImageCommentViewModel) {
        self.viewModel = viewModel
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = viewModel.message
        cell.dateLabel.text = viewModel.date
        cell.usernameLabel.text = viewModel.username
        return cell
    }
        
}
