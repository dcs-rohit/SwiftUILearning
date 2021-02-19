//
//  ContentView.swift
//  SwiftUILearning
//
//  Created by differenz157 on 18/02/21.
//

import SwiftUI

struct ContentView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var dob: Int32 = 1
    @State var email: String = ""
    @State var gender: String = ""
    @State var mobile: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var showingAlert : Bool = false
    @State private var birthDate = Date()
    @State var selection: Int? = nil
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
    var body: some View {
        GeometryReader { geometry in
        NavigationView {
            VStack(alignment:.leading){
                TextField("FirstName", text: $firstName)
                    
                TextField("LastName" ,text:$lastName)
                    
                TextField("Email Id" ,text:$email)
                    .keyboardType(.emailAddress)
                    
                
                TextField("Mobile No" ,text:$mobile)
                    .keyboardType(.numberPad)
                   
                HStack {
                    Text("Gender" )
                        .foregroundColor(.darkGray)
                        .padding(.trailing,20)
                       
                    RadioButtonGroups { selected in
                        print("Selected Gender is: \(selected)")
                    }
                    
                }
               
                HStack {
                    Text("Select Date of birth")
                        .foregroundColor(.darkGray)
                        
//                    Text("\(birthDate, formatter: dateFormatter)")
//                        .foregroundColor(.darkGray)
                    DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date){}
                      
                    .fixedSize()
                   
                        }
                SecureField("Password" ,text:$password)
                  
                SecureField("ConfirmPassword" ,text:$confirmPassword)
                   
               
                HStack(alignment: .center){
                    NavigationLink(destination: MainView(), tag: 1, selection: $selection) {
                        Button(action: {
                            let currentDate = Date()
                            if(firstName.isEmpty || lastName.isEmpty || email.isEmpty && mobile.isEmpty || birthDate == currentDate  || password.isEmpty || confirmPassword.isEmpty){
                                
                                showingAlert = true
                                self.selection = 1
                            }
                            else{
                                
                            }
                           
                        }) {
                            HStack {
                                Spacer()
                                Text("Login")
                                    .foregroundColor(Color.white)
                                    .bold()
                                    
                                Spacer()
                            }
                        }
                        .accentColor(Color.black)
                        .padding()
                        .background(Color(UIColor.darkGray))
                        .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)
                    }
                }
                
//                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .none, alignment: .center)
                Spacer()
            }
                    .padding()
                    .navigationBarTitle("SignUp")
           
                    
            .alert(isPresented: $showingAlert) {
                       Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
                   }
                }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
       
        }
    }
    
    
    func dispSize(_ geometry: GeometryProxy) -> CGFloat {
        return min(geometry.frame(in: .local).width, geometry.frame(in: .local).height)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
