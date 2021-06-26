//
//  HomeViewController.swift
//  Instagrid
//
//  Created by Valc0d3 on 07/05/2021.
//

import UIKit

final class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var viewTitleLabel: UILabel!
    @IBOutlet private weak var swipeLabel: UILabel!
    @IBOutlet private weak var swipeArrowImageview: UIImageView!
    
    @IBOutlet private weak var topLeftView: UIView!
    @IBOutlet private weak var topRightView: UIView!
    @IBOutlet private weak var bottomLeftView: UIView!
    @IBOutlet private weak var bottomRightView: UIView!
    
    @IBOutlet private weak var layoutOneButton: UIButton!
    @IBOutlet private weak var layoutTwoButton: UIButton!
    @IBOutlet private weak var layoutThreeButton: UIButton!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    @IBOutlet weak var gridContainerView: UIView!
    
    // MARK: - Properties
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
    var currentSelectedSpot: UIView? = nil
    var currentSelectedButton: UIButton? = nil
    var currentSelectedGridFormatButton: UIButton? = nil
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction private func didPressLayoutOne() {
        bottomRightView.isHidden = false
        topRightView.isHidden = true
        layoutOneButton.alpha = 0.4
        layoutTwoButton.alpha = 1
        layoutThreeButton.alpha = 1
        currentSelectedGridFormatButton = layoutOneButton
        currentSelectedButton = layoutOneButton
    }
    
    @IBAction private func didPressLayoutTwo() {
        bottomRightView.isHidden = true
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 0.4
        layoutThreeButton.alpha = 1
        currentSelectedGridFormatButton = layoutTwoButton
        currentSelectedButton = layoutTwoButton
    }
    
    @IBAction private func didPressLayoutTree() {
        bottomRightView.isHidden = false
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 1
        layoutThreeButton.alpha = 0.4
        currentSelectedGridFormatButton = layoutThreeButton
        currentSelectedButton = layoutThreeButton
    }
    
    @IBAction func didPressTopLeftButton() {
        openPhotoLibrary()
        currentSelectedSpot = topLeftView
        currentSelectedButton = topLeftButton
        
    }
    
    @IBAction func didPressTopRightButton() {
        openPhotoLibrary()
        currentSelectedSpot = topRightView
        currentSelectedButton = topRightButton
        
    }
    
    @IBAction func didPressBottomLeftButton() {
        openPhotoLibrary()
        currentSelectedSpot = bottomLeftView
        currentSelectedButton = bottomLeftButton
        
    }
    
    @IBAction func didPressBottomRightButton() {
        openPhotoLibrary()
        currentSelectedSpot = bottomRightView
        currentSelectedButton = bottomRightButton
        
    }
    
    @IBAction private func gestureReconizerSwipeUp(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformPositionGridContainerView(gesture: sender, screenVerticaly: isVerticaly())
        case .ended, .cancelled:
            resetPositionGridContainerView()
        default:
            break
        }
    }
    
    // MARK: - Functions
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Function UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        set(imageView, on: currentSelectedSpot)
        buttonDidPressAlpha(btn: currentSelectedButton!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func set(_ subView: UIView, on parentView: UIView?) {
        guard let _parentView = parentView, let lastView = _parentView.subviews.last else { return }
        _parentView.cleanAllSubviewsExceptLast()
        _parentView.insertSubview(subView, belowSubview: lastView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leftAnchor.constraint(equalTo: _parentView.leftAnchor),
            subView.rightAnchor.constraint(equalTo: _parentView.rightAnchor),
            subView.topAnchor.constraint(equalTo: _parentView.topAnchor),
            subView.bottomAnchor.constraint(equalTo: _parentView.bottomAnchor)
        ])
    }
    
    private func buttonDidPressAlpha(btn: UIButton) {
        btn.alpha = 0.02
    }
    
    // MARK: - Function gridContainerView
    fileprivate func displayAlert() {
        if VerifyIfGridIsCompletForScreenShotFormat() {
            UIGraphicsBeginImageContext(gridContainerView.bounds.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return
            }
            gridContainerView.layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                return
            }
            
            UIGraphicsEndImageContext()
            
            let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Erreur", message: "Le template photo n'est pas complet.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fermer", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func VerifyIfGridIsCompletForScreenShotFormat() -> Bool {
        if currentSelectedGridFormatButton != nil {
            if currentSelectedGridFormatButton! == layoutOneButton {
                if topLeftView.subviews.count > 1 && bottomLeftView.subviews.count > 1 && bottomRightView.subviews.count > 1 {
                    return true
                } else {
                    return false
                }
            } else if currentSelectedGridFormatButton! == layoutThreeButton {
                if topLeftView.subviews.count > 1 && topRightView.subviews.count > 1 && bottomLeftView.subviews.count > 1 && bottomRightView.subviews.count > 1 {
                    return true
                } else {
                    return false
                }
            } else {
                if topLeftView.subviews.count > 1 && topRightView.subviews.count > 1 && bottomLeftView.subviews.count > 1 {
                    return true
                } else {
                    return false
                }
            }
        } else {
            if topLeftView.subviews.count > 1 && topRightView.subviews.count > 1 && bottomLeftView.subviews.count > 1 {
                return true
            } else {
                return false
            }
        }
    }
    
    private func transformPositionGridContainerView(gesture: UIPanGestureRecognizer, screenVerticaly: Bool = false) {
        let translation = gesture.translation(in: gridContainerView)
        if screenVerticaly {
            var translationYPositon = 0;
            if translation.y <= 0 {
                translationYPositon = Int(translation.y)
            }
            gridContainerView.transform = CGAffineTransform(translationX: 0, y: CGFloat(translationYPositon))
            if translationYPositon <= -80 {
                displayAlert ()
            }
        } else {
            var translationXPositon = 0;
            if translation.x <= 0 {
                translationXPositon = Int(translation.x)
            }
            gridContainerView.transform = CGAffineTransform(translationX: CGFloat(translationXPositon), y:0)
            if translationXPositon <= -80 {
                displayAlert()
            }
        }
    }
    
    private func resetPositionGridContainerView(){
        gridContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    // MARK: - Orientation detection
    func isVerticaly() -> Bool {
        switch UIDevice.current.orientation{
        case .portrait:
            return true
        case .portraitUpsideDown:
            return false
        case .landscapeLeft:
            return false
        case .landscapeRight:
            return false
        default:
            return true
        }
    }
}

extension UIView {
    func cleanAllSubviewsExceptLast() {
        var nbr = 0
        while nbr <= self.subviews.count - 2 {
            self.subviews[nbr].removeFromSuperview()
            nbr+=1
        }
    }
}
