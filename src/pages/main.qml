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
    property var currentDrinkId : 0;

    //    Settings {
    //        id: settingsId
    //        property string token: ""
    //    }

    function find(model, criteria) {
      for(var i = 0; i < model.count; ++i) if (criteria(model.get(i))) return i;
      return null
    }

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
            onAddDrink: {
                swipeView.currentIndex = 5
                editDrink.drinkId = null;
                editDrink.itemDateTime = new Date();
            }
        }

        EditDrink {
            id: editDrink
            onSaveDrink: {
                swipeView.currentIndex = 4

                var drink = editDrink.getDrink();
                alcometerScreen.saveDrink(drink);
            }
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
