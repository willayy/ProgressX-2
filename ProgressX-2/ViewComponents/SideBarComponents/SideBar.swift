
//
//  SideBar.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-06-02.
//

import SwiftUI

struct SideBar<Content: View, MenuView: View, Backgroud: View>: View {
    
    // cutomizations
    public var rotateWhenExpands: Bool = true
    public var disableInteractions: Bool = true
    public var sideMenuWidth: CGFloat = 200
    public var cornerRadius: CGFloat = 25
    @EnvironmentObject private var showMenuController: ShowMenuController
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    @ViewBuilder var Background: Backgroud
    //View properties
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastoffsetX: CGFloat = 0
    // Dim Contentview when side meue is dragged
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader{ _ in
                    menuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                //Clipping Menu interaction beyond its width
                .contentShape(.rect)
                
                GeometryReader{ _ in
                    content(safeArea)
                }
                .frame(width: size.width)
                .overlay {
                    //Resets the hove view when exiting burger menu
                    if disableInteractions && progress > 0 {
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask{
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                // effects for rotating the homeview when burgermeny is tapped
                .scaleEffect(rotateWhenExpands ? 1 - (progress * 0.1): 1, anchor: .trailing)
                .rotation3DEffect(
                    .init(degrees: rotateWhenExpands ? (progress * -15 ) : 0),
                    axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
                )
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(dragGesture)
        }
        .background(Background)
        .foregroundColor(.black)
        .ignoresSafeArea()
        .onChange(of: showMenuController.showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    self.showSideBar()
                } else {
                    self.reset()
                }
            }
            
        }
    }
    
    // Drag gesture
    var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }.onChanged { value in
                
                
                    // can open new view deep in hierarcy. this disables that
                
                if !self.showMenuController.showMenu{
                    guard value.startLocation.x < 100 else {return}
                } else {
                    guard value.startLocation.x > 10 else {return}
                }
                    let translationX = self.isDragging ? max(min(value.translation.width + self.lastoffsetX, self.sideMenuWidth), 0) : 0
                    self.offsetX = translationX
                    self.calculateProgress()
            }.onEnded { value in
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + self.offsetX
                    if total > (self.sideMenuWidth * 0.5){
                        self.showSideBar()
                    } else {
                        self.reset()
                    }
                    
                }
                
            }
    }
    
    //Show side bar
    func showSideBar(){
        self.offsetX = self.sideMenuWidth
        self.lastoffsetX = self.offsetX
        self.showMenuController.showMenu = true
        self.calculateProgress()
    }
    
    //Reset to initial state
    func reset() {
        self.offsetX = 0
        self.lastoffsetX = 0
        self.showMenuController.showMenu = false
        self.calculateProgress()
    }
    
    //Convert progress into serier of progress converging from 1-0
    func calculateProgress(){
        self.progress = max(min(self.offsetX / self.sideMenuWidth, 1), 0)
    }
    
}
