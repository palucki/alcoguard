import QtQuick 2.13
import QtQuick.Controls 2.13
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.13

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 640
    title: qsTr("Tabs")

    property var db;
    property int splashScreenDuration : 1500
    property int splashScreenPeriod : splashScreenDuration / 1.5
    property bool isInitialized: false
    property bool isLoggedIn: false
    property var sessionToken : ""

    //    Settings {
    //        id: settingsId
    //        property string token: ""
    //    }

    Component.onCompleted: {

    }

    onIsLoggedInChanged: {
//        swipeView.removeItem(loginScreen);
    }

    SwipeView {
        property bool isInteractive : isInitialized && isLoggedIn

        id: swipeView
        anchors.fill: parent
        //        currentIndex: currentIndex
        //        interactive: isInteractive

        Splash {
            id: splashScreen
            RotationAnimator on rotation {
                from: 0;
                to: 360;
                duration: splashScreenPeriod
                loops: Animation.Infinite
            }
        }

        SignupForm {
            id: signupForm
        }

        LoginForm {
            id: loginScreen
            onLoggedSuccessfully: {
                root.sessionToken = loginScreen.sessionToken
                console.log(sessionToken)
            }
        }

        Welcome {
            id: welcomeScreen
            sessionToken : root.sessionToken
        }

        Alcometer {
            id: alcometerScreen
            sessionToken : root.sessionToken
            drinkListModel: drinkModel
            drinkListDelegate: drinkDelegate
            onAddDrink: {
                swipeView.currentIndex = 5
                editDrink.itemDateTime = new Date();
//                drinkModel.append({
//                                          "timestamp": Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss"),
//                                          "beverage" : "vodka",
//                                          "amount" : 50,
//                                          "unit" : "ml"})
            }

        }

        EditDrink {
            id: editDrink
        }

        Timer {
            id: splashScreenTimer
            interval: splashScreenDuration;
            running: true;
            repeat: false
            onTriggered: {
                console.log("Timeout")
                //                swipeView.isInteractive = true
//                swipeView.removeItem(splashScreen)
                isInitialized = true

                console.log("Session token: " + sessionToken )
                if(sessionToken !== "") {
                    swipeView.currentIndex = 2
                }

            }
        }

    }

    ListModel {
        id: drinkModel
        ListElement { timestamp: "2020-12-12 21:00:00"; beverage: "vodka"; amount: 50; unit: "ml" }
        ListElement { timestamp: "2020-12-12 21:10:00"; beverage: "vodka"; amount: 50; unit: "ml" }
        ListElement { timestamp: "2020-12-12 21:20:00"; beverage: "vodka"; amount: 50; unit: "ml" }
        ListElement { timestamp: "2020-12-12 21:30:00"; beverage: "vodka"; amount: 50; unit: "ml" }
        ListElement { timestamp: "2020-12-12 21:40:00"; beverage: "vodka"; amount: 50; unit: "ml" }
    }

    Component {
        id: drinkDelegate

        RowLayout {
            //            width: parent.width
            Text {
                text: Qt.formatDateTime(Date.fromLocaleString(Qt.locale(), timestamp, "yyyy-MM-dd hh:mm:ss"), "hh:mm") + " " + amount + unit + " of " + beverage;
                font.pixelSize: 24
            }
            Button {
                id: removeOneButton
                text: "Remove"
                icon.source: "../../images/icons/remove.png"
                onClicked: {
                    drinkModel.remove(index);
                }
            }
        }
    }

    //    footer: TabBar {
    //        id: tabBar

    //        visible: isInitialized && isLoggedIn
    //        currentIndex: swipeView.currentIndex

    ////        TabButton {
    ////            text: qsTr("Login")
    ////        }
    //        TabButton {
    //            text: qsTr("Home")
    //        }
    //    }
}
