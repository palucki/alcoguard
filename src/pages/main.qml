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
            drinkListModel: drinkModel
            drinkListDelegate: drinkDelegate
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

                if(drink.id === null)
                {
                    drink.id = currentDrinkId++;
                    drinkModel.append(drink)
                }
                else
                {
                    console.log(drink.id, drink.timestamp)
                    var index = find(drinkModel, function(item) { return item.id === drink.id })
                    drinkModel.set(index, drink);
                }
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

    ListModel {


        id: drinkModel
//        ListElement { timestamp: "13-12-2020 21:00"; beverage: "vodka"; amount: 50; unit: "ml" }
//        ListElement { timestamp: "12-12-2020 21:10"; beverage: "vodka"; amount: 50; unit: "ml" }
//        ListElement { timestamp: "12-12-2020 21:20"; beverage: "vodka"; amount: 50; unit: "ml" }
//        ListElement { timestamp: "12-12-2020 21:30"; beverage: "vodka"; amount: 50; unit: "ml" }
//        ListElement { timestamp: "12-12-2020 21:40"; beverage: "vodka"; amount: 50; unit: "ml" }
    }

    Component {
        id: drinkDelegate
        RowLayout {
            //                height: 50
            Text {
                //text: Qt.formatDateTime(Date.fromLocaleString(Qt.locale(), timestamp, "dd-MM-yyyy hh:mm"), "hh:mm") + " " + amount + unit + " of " + beverage;
                text: Qt.formatDateTime(timestamp, "hh:mm") + " " + amount + unit + " of " + beverage;
                font.pixelSize: 24

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        swipeView.currentIndex = 5;
                        editDrink.drinkId = drinkModel.get(index).id;
                        editDrink.itemDateTime = drinkModel.get(index).timestamp;
                    }
                }
            }

            Button {
                id: editOneButton
                text: "Edit"
                icon.source: "../../images/icons/edit.png"
                onClicked: {
                    swipeView.currentIndex = 5;
                    editDrink.drinkId = drinkModel.get(index).id;
                    editDrink.itemDateTime = drinkModel.get(index).timestamp;
                }
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
