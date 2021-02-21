import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.13
import QtQuick.LocalStorage 2.13
import "../Database.js" as DB
import "../components"

Item {
    id: root
    property var daysWithDrinks;
    property var streak;
    property var sober;
    property var iconSize : 20;
    signal showDay(var date);

    function formatDate(date) {
        var dd = date.getDate() < 9 ? "0" + date.getDate() : date.getDate();
        var mm = date.getMonth() < 9 ? "0" + (date.getMonth() + 1) : date.getMonth() + 1
        var yyyy = date.getFullYear()

        return yyyy + "-" + mm + "-" + dd;
    }

    function loadDaysWithDrinks() {
        var days = DB.daysWithDrink();
        daysWithDrinks = days;

        var sober = true;
        var currentDate = new Date();
        var currentDateString = formatDate(currentDate)
        var currentStreak = 1;
        var firstDrinkDate = new Date(daysWithDrinks[0]);
        var firstDrinkString = formatDate(firstDrinkDate)
        var keep = true;
        var day = new Date(currentDate.getTime() - 24 * 60 * 60 * 1000);
        var dayString = formatDate(day)

        if(daysWithDrinks.length === 0 || firstDrinkDate > currentDate)
        {
            sober = true;
        }
        else if(daysWithDrinks.includes(currentDateString))
        {
            sober = false;
            //check alco days by finding first sober day smaller  than currentDate
            while(daysWithDrinks.includes(dayString))
            {
                day = new Date(day.getTime()  - 24 * 60 * 60 * 1000);
                dayString = formatDate(day)
                currentStreak++;
            }
        }
        else
        {
            //check sober days by finding first alco day smaller than currentDate
            while(!daysWithDrinks.includes(dayString))
            {
                day = new Date(day.getTime()  - 24 * 60 * 60 * 1000);
                dayString = formatDate(day)
                currentStreak++;
            }
        }

        console.log((sober ? "Sober " : "Alco ") + "streak: " + currentStreak)
        root.sober = sober;
        root.streak = currentStreak;
    }

    function isInArray(array, value) {
        var res =  !!array.find(item => {return item === value.toISOString().slice(0,10)});
        return res;
    }

    AddDrinkButton {
    }

    Component.onCompleted: {
        loadDaysWithDrinks();
    }

    Calendar {
        anchors.top: parent.top
        anchors.topMargin: 20
        width: parent.width
        height: 0.7 * parent.height

        style: CalendarStyle {
            dayDelegate: Rectangle {
                Rectangle {
                    anchors.fill: parent
                    color: (styleData.date.toISOString().slice(0,10) === new Date().toISOString().slice(0,10)) ? "lightblue" : "white"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Go to day " +  styleData.date)
                            showDay(styleData.date)
                        }
                    }

                }

                Label {
                    text: styleData.date.getDate()
                    anchors.leftMargin: 5
                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: styleData.visibleMonth ? "black" : "grey"
                }

                Image {
                    id: drinkIconId
                    visible: styleData.date <= new Date()

                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: iconSize
                    height: width
                    source: isInArray(daysWithDrinks, styleData.date) ? "../../images/icons/drink.png" : "../../images/icons/no_drinks.png"

                }
                ColorOverlay {
                    visible: styleData.date <= new Date()
                    anchors.fill: drinkIconId
                    source: drinkIconId
                    color: isInArray(daysWithDrinks, styleData.date) ? "darkorange" : "green"
                }
            }
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        Label {
            text: "Current streak";
        }
        Label {
            text: root.streak;
        }
        Label {
            text: sober ? "sober days" : "alco days";
        }
    }

}
