
//
//  SideBar.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-06-02.
//

import SwiftUI

struct SideBar<Content: View, MenuView: View, Backgroud: View>: View {
    
    // cutomizations
    var rotateWhenExpands: Bool = true
    var disableInteractions: Bool = true
    var sideMenuWidth: CGFloat = 200
    var cornerRadius: CGFloat = 25
    @Binding var showMenu: Bool
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
                    if disableInteractions && progress > 0{
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)){
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
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue{
                    showSideBar()
                } else {
                    reset()
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
                guard value.startLocation.x > 10 else {return}
                let translationX = isDragging ? max(min(value.translation.width + lastoffsetX, sideMenuWidth), 0) : 0
                offsetX = translationX
                calculateProgress()
            }.onEnded { value in
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    
                    if total > (sideMenuWidth * 0.5){
                        showSideBar()
                    } else {
                        reset()
                    }
                    
                }
                
            }
    }
    
    //Show side bar
    func showSideBar(){
        offsetX = sideMenuWidth
        lastoffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    //Reset to initial state
    func reset() {
        offsetX = 0
        lastoffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    //Convert progress into serier of progress converging from 1-0
    func calculateProgress(){
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
    
    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case Statistics = "chart.xyaxis.line"
        case Routines = "rectangle.stack"
        case Exercises = "dumbbell"
        case Profile = "person.crop.circle"
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .Statistics: return "Statistics"
            case .Routines: return "Routines"
            case .Exercises: return "Exercises"
            case .Profile: return "Profile"
            }
        }
    }
}



#Preview {
    HomeView()
        .environmentObject(ViewRouter())
}

