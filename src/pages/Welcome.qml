import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

Page {
//    width: 600
//    height: 400
    property var sessionToken : ""
    property var url : "http://salka.thepajx.pl/apiv2/protected.php";
    header: Label {
        text: qsTr("Drodzy Salkowicze")
        font.pixelSize: Qt.application.font.pixelSize * 2
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
        padding: 10
    }

    Image {
        id: image
        source: "../../images/dario.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Button {
        id: proccessButtonId
        Layout.fillWidth: true
        text: "Login"
        onClicked: loginUser(function(response){
            if ( response) {
//                statusPopupTextId.text = "Logged successfully!"
                console.log(response)
//                var obj = JSON.parse(response)
//                console.log("Received token: " + obj["jwt"])
//                sessionToken = obj["jwt"]
//                loggedSuccessfully()
            }else{
//                statusPopupTextId.text = "Login failed!"
                console.log("error while fetching")
//                sessionToken = ""
            }
//            statusPopupId.open();
        })
    }


    function loginUser(callback) {
//        if(passwordId.text === "" || emailId.text === "") {
//            console.log("Email or password is empty");
//            statusPopupTextId.text = "Email or password empty!"
//            statusPopupId.open();
//            return;
//        }

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
            text : "test"
        }

        //Kick off the download
        xhr.open("POST",url)
//        xhr.setRequestHeader('Content-type', 'application/json')
        xhr.setRequestHeader('Authorization', 'Bearer ' + sessionToken);
        xhr.send(JSON.stringify(params))
    }
}
