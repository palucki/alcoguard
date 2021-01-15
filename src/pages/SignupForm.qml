import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.LocalStorage 2.13
import QtQuick.Controls.Material 2.13
//import "Database.js" as DB

Page {
    id: rootId
    signal loggedSuccessfully

    property var url : "http://salka.thepajx.pl/apiv2/register.php";

//    width: 600
//    height: 400

    Rectangle {
        anchors.centerIn: parent
        color: Qt.rgba(0, 0.2, 0.5, 0.5)
        radius: 10


        ColumnLayout {
            anchors.centerIn: parent
            width: 0.5 * rootId.width

            spacing: 5
            TextField {
                id: usernameId
                Layout.fillWidth: true
                placeholderText: "Name"
                focus: true
            }

            TextField {
                id: emailId
                Layout.fillWidth: true
                placeholderText: "Email"
            }

            TextField {
                id: passwordId
                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
            }

            TextField {
                id: repeatedPasswordId
                Layout.fillWidth: true
                placeholderText: "Repeat password"
                echoMode: TextInput.Password
            }

            Button {
                id: registerUserButtonId
                Layout.fillWidth: true
                text: "Register"
                onClicked: registerUser(function(response){
                    if ( response) {
//                        var obj = JSON.parse(response)
                        statusPopupTextId.text = "Registered successfully!"
                        console.log(response)
                    }else{
                        statusPopupTextId.text = "Unable to register!"
                        console.log("error while fetching")
                    }
                    statusPopupId.open();
                })
                //                Keys.onReturnPressed: registerUser()
            }

            Popup {
                anchors.centerIn: parent
                id: statusPopupId
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                Label {
                    id: statusPopupTextId
                    text : ""
                }
            }

        }
    }

    function registerUser(callback) {
        if(passwordId.text !== repeatedPasswordId.text) {
            console.log("Passwords are not the same");
            statusPopupTextId.text = "Passwords are not the same!"
            statusPopupId.open();
            return;
        }

        if(usernameId.text === "" ||passwordId.text === "" || emailId.text === "") {
            console.log("Email or password is empty");
            statusPopupTextId.text = "Username, email or password empty!"
            statusPopupId.open();
            return;
        }


        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function(){
            if ( xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED){
                console.log("HEADERS RECEIVED")
            }else if(xhr.readyState === XMLHttpRequest.DONE ){
                if( xhr.status === 200){
                    callback(xhr.responseText.toString())
                }else{
                    callback(null)
                }
            }
        }
        //prepare params for user registration

        const params = {
            name : usernameId.text,
            email:  emailId.text,
            password: passwordId.text
        }

        //Kick off the download
        xhr.open("POST",url)
        xhr.setRequestHeader('Content-type', 'application/json')
        xhr.send(JSON.stringify(params))
    }

}


