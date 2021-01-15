import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQuick.LocalStorage 2.13
import QtQuick.Controls.Material 2.13
import Qt.labs.settings 1.0
//import "Database.js" as DB

Page {
    id: rootId
    signal loggedSuccessfully
    property var url : "http://salka.thepajx.pl/apiv2/login.php";
    property var sessionToken : ""
    //    width: 600
    //    height: 400
    //    header: Label {
    //        text: qsTr("Page 1")
    //        font.pixelSize: Qt.application.font.pixelSize * 2
    //        padding: 10
    //    }

    //    Label {
    //        text: qsTr("You are on Page 1.")
    //        anchors.centerIn: parent
    //    }

    //    Component.onCompleted: {
    //        DB.dbInit()
    //    }

//    Settings {
//        id: settingsId
//        property string token: ""
//    }


//    Component.onDestruction: {
//        settingsId.token = sessionToken
//    }

    Rectangle {
        anchors.centerIn: parent
        color: Qt.rgba(0, 0.2, 0.5, 0.5)
        radius: 10

        Popup {
            anchors.centerIn: parent
            id: statusPopupId
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            Label {
                id: statusPopupTextId
                text : ""
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: 0.5 * rootId.width
            spacing: 5
            TextField {
                id: emailId
                Layout.fillWidth: true
                placeholderText: "Email"
                focus: true
            }

            TextField {
                id: passwordId
                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
            }

            Button {
                id: proccessButtonId
                Layout.fillWidth: true
                text: "Login"
                onClicked: loginUser(function(response){
                    if ( response) {
                        statusPopupTextId.text = "Logged successfully!"
                        console.log(response)
                        var obj = JSON.parse(response)
                        console.log("Received token: " + obj["jwt"])
                        sessionToken = obj["jwt"]
                        loggedSuccessfully()
                    }else{
                        statusPopupTextId.text = "Login failed!"
                        console.log("error while fetching")
                        sessionToken = ""
                    }
                    statusPopupId.open();
                })
            }
            Button {
                id: addUserId
                Layout.fillWidth: true
                text: "Register"
                //                onClicked: DB.addUser()
                //                Keys.onReturnPressed: DB.addUser()

            }
        }
    }

    function loginUser(callback) {
        if(passwordId.text === "" || emailId.text === "") {
            console.log("Email or password is empty");
            statusPopupTextId.text = "Email or password empty!"
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
        //prepare params for user login

        const params = {
            email:  emailId.text,
            password: passwordId.text
        }

        //Kick off the download
        xhr.open("POST",url)
        xhr.setRequestHeader('Content-type', 'application/json')
        xhr.send(JSON.stringify(params))
    }
}
