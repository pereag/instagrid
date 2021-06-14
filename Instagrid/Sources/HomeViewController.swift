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
    }
    @IBAction private func didPressLayoutTwo() {
        bottomRightView.isHidden = true
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 0.4
        layoutThreeButton.alpha = 1
    }
    @IBAction private func didPressLayoutTree() {
        bottomRightView.isHidden = false
        topRightView.isHidden = false
        layoutOneButton.alpha = 1
        layoutTwoButton.alpha = 1
        layoutThreeButton.alpha = 0.4
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
    private func transformPositionGridContainerView(gesture: UIPanGestureRecognizer, screenVerticaly: Bool = false) {
        let translation = gesture.translation(in: gridContainerView)
        if screenVerticaly {
            var translationYPositon = 0;
            if translation.y <= 0 {
                translationYPositon = Int(translation.y)
            }
            gridContainerView.transform = CGAffineTransform(translationX: 0, y: CGFloat(translationYPositon))
            if translationYPositon <= -80 {
                print("envoyer photo")
                let alert = UIAlertController(title: "Alerte", message: "Montage incomplet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Fermer", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            var translationXPositon = 0;
            if translation.x <= 0 {
                translationXPositon = Int(translation.x)
            }
            gridContainerView.transform = CGAffineTransform(translationX: CGFloat(translationXPositon), y:0)
            if translationXPositon <= -80 {
                print("envoyer photo")
                let alert = UIAlertController(title: "Alerte", message: "Montage incomplet.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Fermer", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
        print(self.subviews.count)
        var nbr = 0
        while nbr <= self.subviews.count - 2 {
            self.subviews[nbr].removeFromSuperview()
            nbr+=1
        }
    }
}
