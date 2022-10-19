//
//  ToastUI.swift
//  Toast
//
//  Created by Nguyễn Ngọc Linh on 10/19/22.
//

import SwiftUI

extension View {
    func showToast(message: Binding<String>, position: PositionToast = .center, padding: CGFloat, toastAttributes: ToastAttributes = ToastAttributes()) -> some View {
        
        ToastContainer(superView: {
            self
        }, message: message, position: position, padding: padding, toastAttributes: toastAttributes)
    }
}

private struct ToastContainer<SuperView: View>: View {
    @ViewBuilder var superView: SuperView
    @Binding var message: String
    var position: PositionToast = .center
    var padding: CGFloat = 10
    var toastAttributes: ToastAttributes = ToastAttributes()
    
    var body: some View {
        return ZStack(alignment: getAlignmentByPosition(position: position)) {
            superView
            
            ToastView(message: $message, toastAttributes: toastAttributes)
                .padding(padding)
        }
    }
    
    private func getAlignmentByPosition(position: PositionToast) -> Alignment {
        switch position {
        case .center:
            return Alignment.center
        case .top:
            return Alignment.top
        case .bottom:
            return Alignment.bottom
        }
    }
}

struct ToastView: View {
    @Binding var message: String
    var toastAttributes: ToastAttributes = ToastAttributes()
    
    var body: some View {
        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            EmptyView()
        } else {
            HStack {
                getImage()
                    .resizable()
                    .frame(width: toastAttributes.imageSize.width, height: toastAttributes.imageSize.height)
                    .foregroundColor(toastAttributes.imageTintColor)
                    .background(toastAttributes.imageBackgroundColor)
                    .padding(.leading, 5)
                
                Text(message)
                    .lineLimit(10)
                    .multilineTextAlignment(.center)
                    .font(toastAttributes.fontStyle)
                    .foregroundColor(foregroundColor())
                    .background(toastAttributes.labelBackgroundColor)
                    .padding(.trailing, 5)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: toastAttributes.time, repeats: false) { _ in
                            message = ""
                        }
                    }
            }
            .padding(.vertical, 5)
            .background(backgroundColor())
            .cornerRadius(10)
            .disabled(true)
        }
    }
    
    private func backgroundColor() -> Color {
        switch toastAttributes.toastType {
        case .warning:
            return .yellow.opacity(0.85)
        case .success:
            return .green.opacity(0.85)
        case .error:
            return .red.opacity(0.85)
        case .notify:
            return .black.opacity(0.85)
        case .custom:
            return toastAttributes.customBackgroundColorContainer
        }
    }
    
    private func getImage() -> Image {
        switch toastAttributes.toastType {
        case .warning:
            return Image(systemName: "exclamationmark.circle.fill")
        case .success:
            return Image(systemName: "checkmark.circle.fill")
        case .error:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .notify:
            return Image(uiImage: UIImage())
        case .custom:
            return toastAttributes.customImage
        }
    }
    
    private func foregroundColor() -> Color {
        switch toastAttributes.toastType {
        case .warning, .success, .error:
            return Color(cgColor: CGColor(red: 36/255, green: 71/255, blue: 161/255, alpha: 1))
        case .notify:
            return .white
        case .custom:
            return toastAttributes.customLabelColor
        }
    }
}

struct ToastAttributes {
    var time: CGFloat = 1.5
    var toastType: ToastType = .error
    
    var imageTintColor: Color = .white
    var imageBackgroundColor: Color = .clear
    var imageSize: CGSize = CGSize(width: 40, height: 40)
    var customImage: Image = Image(uiImage: UIImage())
    
    var customLabelColor: Color = .white
    var labelBackgroundColor: Color = .clear
    var fontStyle: Font = .system(size: 20, weight: .bold)
    var textAlignment: TextAlignment = .center
    var numberOfLines: Int = 0
    var lineBreakMode: NSLineBreakMode = .byWordWrapping
    
    var customBackgroundColorContainer: Color = .purple.opacity(0.75)
    var cornerRadiusContainer: CGFloat = 10
    var isMasksToBoundsContainer: Bool = true
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: Binding.constant("Message alert"))
    }
}
