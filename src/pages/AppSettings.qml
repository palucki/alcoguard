import QtQuick 2.13
import Qt.labs.settings 1.0
import QtQuick.Controls 2.13

Item {

        Settings {
            id: settings
            property alias wireless: wirelessSwitch.checked
            property alias bluetooth: bluetoothSwitch.checked
            property alias contrast: contrastSlider.value
            property alias brightness: brightnessSlider.value
        }

    Column {
        anchors.centerIn: parent
        spacing: 25

        Row {
            spacing: 50
            Image {
                anchors.verticalCenter: parent.verticalCenter
//                source: "images/bluetooth.png"
            }
            Switch {
                id: bluetoothSwitch
                anchors.verticalCenter: parent.verticalCenter
                checked: settings.bluetooth
            }
        }
        Row {
            spacing: 50
            Image {
                anchors.verticalCenter: parent.verticalCenter
//                source: "images/wifi.png"
            }
            Switch {
                id: wirelessSwitch
                anchors.verticalCenter: parent.verticalCenter
                checked: settings.wireless
            }
        }

        Column {
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
//                source: "images/brightness.png"
            }
            Slider {
                id: brightnessSlider
                anchors.horizontalCenter: parent.horizontalCenter
                from: 0
                to: 5
                stepSize: 1
                value: settings.brightness
            }
        }
        Column {
            spacing: 2
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
//                source: "images/contrast.png"
            }
            Slider {
                id: contrastSlider
                anchors.horizontalCenter: parent.horizontalCenter
                from: 0
                to: 10
                stepSize: 1
                value: settings.contrast
            }
        }
    }
}
