import QtQuick 2.13
import Qt.labs.settings 1.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import QtQuick.LocalStorage 2.13
import "../Database.js" as DB
import "../components"

Page {
    id: settingsPageId

    signal beverageChanged;
    property var dayStartTime : startHourId.text + ":" + startMinuteId.text

    Settings {
        id: settings
        property alias newDayStartHour: settingsPageId.dayStartTime
    }

    function saveBeverage(beverage) {
        DB.saveBeverage(beverage);
        beveragesModel.append(beverage);
        // TODO: handle update
        //        var index = find(drinkModel, function(item) { return item.id === drink.id })
        //        if(index !== null)
        //            drinkModel.remove(index);
        //        addDrink(drink);
        beverageChanged();
    }

    function deleteBeverage(index, id) {
        DB.deleteBeverage(id)
        beveragesModel.remove(index)
        beverageChanged();
    }

    Component.onCompleted: {
        DB.dbInit();
        var beverages = DB.loadBeverages();
        //        if(beverages.length > 0)
        //            root.usedBeverages = beverages

        for(var i = 0 ; i < beverages.length; i++)
            beveragesModel.append({"id" : beverages[i].id, "name" : beverages[i].name })

        var hourMinute = settings.newDayStartHour.split(':')
        var hour = hourMinute[0]
        var minute = hourMinute[1]

        if(hour === "" || minute === "") {
            startHourId.text = "07"
            startMinuteId.text = "00"
        }
        else {
            startHourId.text = hour
            startMinuteId.text = minute
        }
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
                    deleteBeverage(index, beveragesModel.get(index).id);
                }
            }
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "red"
        height: colLayoutId.height
        width: colLayoutId.width

        ColumnLayout {
            id: colLayoutId
            spacing: 10
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: 400

            Rectangle {
                color: "lightgreen"
                height: 50;
                width: parent.width
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: layout
                    spacing: 10
                    Label {
                        Layout.fillWidth: true
                        text: "New day starts at:"
                    }
                    TextField {
                        id: startHourId
                        validator: IntValidator {bottom: 0; top: 23;}
                        Layout.maximumWidth: 25
                        horizontalAlignment: TextInput.AlignRight
                        placeholderText: "HH"
                        onTextChanged: {
                            if(!acceptableInput)
                                startHourId.undo()
                        }
                    }
                    Label {
                        Layout.fillWidth: true
                        text: ":"
                    }
                    TextField {
                        id: startMinuteId
                        //                        inputMask: "HH"
                        horizontalAlignment: TextInput.AlignLeft
                        validator: IntValidator {bottom: 0; top: 59;}
                        Layout.maximumWidth: 25
                        placeholderText: "MM"
                        onTextChanged: {
                            if(!acceptableInput)
                                startMinuteId.undo()
                        }
                    }
                }
            }

            ListView {
                id: beveragesList
                clip: true
                model: ListModel {
                    id: beveragesModel
                }

                height: 400
                width: parent.width
                header: Label {
                    width: parent.width
                    text: "List of beverages"
                    horizontalAlignment: Text.AlignHCenter
                }

                delegate: beverageDelegateId

                footer: rectId
            }

            Rectangle {
                id: rectId
                height: stackView.height
                width: parent.width
                color: "lightblue"

                StackView {
                    id: stackView
                    width: parent.width
                    height: 50
                    initialItem: index0

                }
            }
        }
    }
    Component {
        id: index0
        RowLayout {
            RoundButton {
                id: addBeverageButtonId
                Layout.alignment: Qt.AlignCenter
                height: 50
                width: 50
                icon.source: "../../images/icons/add.png"
                onClicked: {
                    stackView.push(index1)
                }
            }
        }
    }

    Component {
        id: index1

        RowLayout {
            TextField {
                id: addBeverageName
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                placeholderText: "type beverage name...                 "
            }

            RoundButton {
                id: saveBeverageButtonId
                Layout.alignment: Qt.AlignRight
                height: 50
                width: 50
                icon.source: "../../images/icons/save.png"
                onClicked: {
                    if(addBeverageName.text && addBeverageName.text.trim().length) {
                        console.log("Will add new beverage: " + addBeverageName.text)
                        saveBeverage({"name" : addBeverageName.text});
                    }
                    addBeverageName.text = ""
                    stackView.pop();
                }
            }
        }
    }
}
