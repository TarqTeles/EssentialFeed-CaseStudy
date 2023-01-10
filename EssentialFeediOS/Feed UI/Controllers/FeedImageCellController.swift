//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 05/01/23.
//

import UIKit

final class FeedImageCellController {
    private var viewModel: FeedImageViewModel<UIImage>
    
    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        viewModel.loadImageData()
        return cell
    }
    
    func preload() {
        viewModel.loadImageData()
    }
    
    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.descriptionLabel.text = viewModel.description
        cell.locationLabel.text = viewModel.location
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.onRetry = viewModel.loadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadingChangeState = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }
        
        return cell
    }
}
