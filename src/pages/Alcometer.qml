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


    ColumnLayout {
        id: masterLayout
        spacing: 10
        anchors.fill:parent

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            ChartView { //different types
                id: chartViewId
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: masterLayout.width
                Layout.preferredHeight: 0.3 * masterLayout.height
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
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            ListView {
                id: alcoListId
                //            anchors.top: chartViewId.bottom
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: masterLayout.width
                Layout.preferredHeight: 0.6 * masterLayout.height
                Layout.fillHeight: true

                clip: true
                model: drinkListModel
                delegate: drinkListDelegate
                ScrollBar.vertical: ScrollBar { id: scrollBarId}
            }

        }


        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Button {
                id: addButtonOptions
                Layout.preferredHeight: 0.1 * masterLayout.height
                Layout.preferredWidth: 180
                Layout.alignment: Qt.AlignHCenter
                text: "Add"
                icon.source: "../../images/icons/add.png"
                onClicked: addDrink()
            }
        }
    }
}
