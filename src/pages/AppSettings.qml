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
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Setting 1"
            }

            Switch {
                id: bluetoothSwitch
                anchors.verticalCenter: parent.verticalCenter
                checked: settings.bluetooth
            }
        }
        Row {
            spacing: 50
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Setting 2"
            }
            Switch {
                id: wirelessSwitch
                anchors.verticalCenter: parent.verticalCenter
                checked: settings.wireless
            }
        }

        Row {
            spacing:  50
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Setting 3"
            }
            Slider {
                id: brightnessSlider
                anchors.horizontalCenter: parent.verticalCenter
                from: 0
                to: 5
                stepSize: 1
                value: settings.brightness
            }
        }
        Row {
            spacing:  50
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "Setting 4"
            }
            Slider {
                id: contrastSlider
                anchors.horizontalCenter: parent.verticalCenter
                from: 0
                to: 10
                stepSize: 1
                value: settings.contrast
            }
        }
    }
}
