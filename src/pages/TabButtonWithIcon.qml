import QtQuick 2.13
import QtQuick.Controls 2.13


TabButton {
    property var buttonText;
    property var iconSource;
    property var buttonSize;
    contentItem: Item {
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            Image {
                id: img
                source: iconSource
                width: buttonSize
                height: buttonSize
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: buttonText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: img.bottom
            }
        }
    }
}
