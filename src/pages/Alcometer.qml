import QtQuick 2.15
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtCharts 2.15
//import QtQml 2.15
Page {
    property var sessionToken : ""
    property var drinkListModel;
    property var drinkListDelegate;
    signal addDrink;
    //    property var locale: Qt.locale()


    Column {
        anchors.fill: parent
        ChartView { //different types
            id: chartViewId
            width: parent.width
            height: 0.3 * parent.height
            antialiasing: true
            title: "Tytul"
            LineSeries {
                name: "LineSeries"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
            }
        }

        //        ListView {
        //            //            width: 180; height: 200
        //            anchors.top: chartViewId.bottom
        //            width: parent.width
        //            height: 0.6 * parent.height
        //            model: contactModel
        //            delegate: Text {
        //                text: name + ": " + number
        //            }
        //        }

        ListView {
            id: alcoListId
            //            anchors.top: chartViewId.bottom
            width: parent.width
            height: 0.6 * parent.height

            clip: true
            model: drinkListModel
            delegate: drinkListDelegate
            ScrollBar.vertical: ScrollBar { id: scrollBarId}
        }

        Button {
            id: addButtonOptions
            height: 0.1 * parent.height
            //            anchors.bottom: parent.bottom
            Layout.alignment: Qt.AlignBottom
            text: "Add"
            icon.source: "../../images/icons/add.png"
            onClicked: addDrink()
        }

    }



}
