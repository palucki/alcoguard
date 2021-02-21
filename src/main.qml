import QtQuick 2.13
import QtQuick.Controls 2.13
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.13
import QtQuick.Controls.Styles 1.4

import "components"
import "pages"

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

    property var usedCurrencies: ["PLN", "USD", "EUR", "GBP"]

    readonly property int homePageIndex : 0;
    readonly property int calendarPageIndex : 1;
    readonly property int addDrinkPageIndex : 2;
    readonly property int statsPageIndex : 3;
    readonly property int settingsPageIndex : 4;

    function find(model, criteria) {
        for(var i = 0; i < model.count; ++i) if (criteria(model.get(i))) return i;
        return null
    }

    function addNewDrink() {
        swipeView.setCurrentIndex(root.addDrinkPageIndex);
        editDrink.drinkId = null;
        editDrink.itemDateTime = new Date();
    }



    onIsLoggedInChanged: {
        //        swipeView.removeItem(loginScreen);
    }

    SwipeView {
        //        property bool isInteractive : isInitialized && isLoggedIn

        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        onCurrentIndexChanged: {
            if(currentIndex !== root.addDrinkPageIndex)
                editDrink.returnToIndex = currentIndex;
        }

        //        Splash {
        //            id: splashScreen
        //            RotationAnimator on rotation {
        //                from: 0;
        //                to: 360;
        //                duration: splashScreenPeriod
        //                loops: Animation.Infinite
        //            }
        //        }

        //        SignupForm {
        //            id: signupForm
        //        }

        //        LoginForm {
        //            id: loginScreen
        //            onLoggedSuccessfully: {
        //                root.sessionToken = loginScreen.sessionToken
        //                console.log(sessionToken)
        //            }
        //        }

        //        Welcome {
        //            id: welcomeScreen
        //            sessionToken : root.sessionToken
        //        }

        Item {
            id: homeScreen
            AddDrinkButton {
            }

        }


        CalendarScreen {
            id: calendarScreen
            onShowDay: {
                statsScreen.filterByDate(date);
                swipeView.setCurrentIndex(statsPageIndex)
            }
        }

        EditDrinkScreen {
            id: editDrink
            onSaveDrink: {
                var drink = editDrink.getDrink();
                statsScreen.saveDrink(drink);
                console.log("Returning to " + editDrink.returnToIndex)
                swipeView.setCurrentIndex(editDrink.returnToIndex)
            }
        }

        StatsScreen {
            id: statsScreen
            sessionToken : root.sessionToken
            onDrinksModified: {
                calendarScreen.loadDaysWithDrinks()
            }
        }


        SettingsScreen {
            id: settings
            onBeverageChanged: {
                editDrink.updateBeverages();
            }
        }

        //        Timer {
        //            id: splashScreenTimer
        //            interval: splashScreenDuration;
        //            running: true;
        //            repeat: false
        //            onTriggered: {
        //                console.log("Timeout")
        //                //                swipeView.isInteractive = true
        //                //                swipeView.removeItem(splashScreen)
        //                isInitialized = true

        //                console.log("Session token: " + sessionToken )
        //                if(sessionToken !== "") {
        //                    swipeView.currentIndex = 2
        //                }

        //            }
        //        }

    }



    footer: TabBar {
        id: tabBar

        visible: true
        currentIndex: swipeView.currentIndex

        onCurrentIndexChanged: {
            console.log("Tab bar index: " + currentIndex)
        }



        TabButtonWithIcon {
            buttonText: qsTr("Home")
            buttonSize: 20
            iconSource: "../../images/icons/home.png"
        }

        TabButtonWithIcon {
            buttonText: qsTr("Calendar")
            buttonSize: 20
            iconSource: "../../images/icons/calendar.png"
        }

        TabButtonWithIcon {
            buttonText: qsTr("Add")
            buttonSize: 20
            iconSource: "../../images/icons/add.png"
            onClicked: {
                editDrink.drinkId = null;
                editDrink.itemDateTime = new Date();
            }
        }

        TabButtonWithIcon {
            buttonText: qsTr("Stats")
            buttonSize: 20
            iconSource: "../../images/icons/stats.png"
        }

        TabButtonWithIcon {
            buttonText: qsTr("Settings")
            buttonSize: 20
            iconSource: "../../images/icons/settings.png"
        }
    }
}
