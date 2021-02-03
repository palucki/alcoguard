import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import QtQuick.LocalStorage 2.13
import "../Database.js" as DB

Item {
    property var daysWithDrinks;

    function loadDaysWithDrinks() {
        daysWithDrinks = DB.daysWithDrink();
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
        anchors.centerIn: parent

        style: CalendarStyle {
            dayDelegate: Rectangle {
                Label {
                    text: styleData.date.getDate()
                    anchors.left: parent.left
                    anchors.top: parent.top
                    color: styleData.visibleMonth ? "black" : "grey"
                }

                Image {
                    id: drinkIconId
                    visible: styleData.date <= new Date()

                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: parent.width / 2
                    height: width
                    source: isInArray(daysWithDrinks, styleData.date) ? "../../images/icons/drink.png" : "../../images/icons/no_drinks.png"

                }
                ColorOverlay {
                    visible: styleData.date <= new Date()
                    anchors.fill: drinkIconId
                    source: drinkIconId
                    color: isInArray(daysWithDrinks, styleData.date) ? "orange" : "green"
                }
            }
        }
    }
}
