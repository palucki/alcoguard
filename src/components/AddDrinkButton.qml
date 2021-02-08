import QtQuick 2.13
import QtQuick.Controls 2.13

RoundButton {
    id: addButtonOptions
    x: parent.width - width - 25
    y: parent.height - height -25
    z: 1
    height: 50
    width: 50
    icon.source: "../../images/icons/add.png"
    onClicked: addNewDrink()
}
