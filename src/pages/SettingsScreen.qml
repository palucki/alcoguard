import QtQuick 2.13
import Qt.labs.settings 1.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import QtQuick.LocalStorage 2.13
import "../Database.js" as DB

Item {
    id: settingsPageId

    Settings {
        id: settings
        property alias wireless: wirelessSwitch.checked
        //        property alias bluetooth: bluetoothSwitch.checked
        //        property alias contrast: contrastSlider.value
        //        property alias brightness: brightnessSlider.value
    }

    Component.onCompleted: {
        DB.dbInit();
        var beverages = DB.loadBeverages();
        if(beverages.length > 0)
            root.usedBeverages = beverages

        for(var i = 0 ; i < beverages.length; i++)
            beveragesModel.append({"id" : beverages[i].id, "name" : beverages[i].name })
    }

    Component {
        id: beverageDelegateId
        RowLayout {
            width: beveragesList.width
            Text {
                id: beverageNameId
                text: name;
                font.pixelSize: 15

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Will edit " + index + " which containst id: " + usedBeverages[index].id + " " + usedBeverages[index].name)
                    }
                }
            }

            RoundButton {
                id: removeBeverageButtonId
                Layout.alignment: Qt.AlignRight
                height: 50
                width: 50
                icon.source: "../../images/icons/delete.png"
                onClicked: {
                    console.log("Will remove " + index);// + " which containst id: " + usedBeverages.get(index).id + " " + usedBeverages.get(index).name)
                    beveragesModel.remove(index)
                }
            }
        }
    }

    ColumnLayout {
        spacing: 10
        anchors.centerIn: parent

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            id: layout
            spacing: 6
            Text {
                text: "Setting 2"
            }
            Switch {
                id: wirelessSwitch
                checked: settings.wireless
            }
        }

        ListView {
            id: beveragesList
            model: ListModel {
                id: beveragesModel
            }

            height: 400
            width: 400
            header: Label {
                width: parent.width
                text: "List of beverages"
                horizontalAlignment: Text.AlignHCenter
            }

            delegate: beverageDelegateId

            footer:  RowLayout {
                width: parent.width

                TextField {
                    id: addBeverageName
                    Layout.alignment: Qt.AlignLeft
                    placeholderText: "type beverage name..."
                }

                RoundButton {
                    id: addBeverageButtonId
                    Layout.alignment: Qt.AlignRight
                    height: 50
                    width: 50
                    icon.source: "../../images/icons/add.png"
                    onClicked: {
                        console.log("Will add new beverage: " + addBeverageName.text)
                        beveragesModel.append({"name" : addBeverageName.text})
                        addBeverageName.text = ""
                    }

                }
            }
        }
    }
}
