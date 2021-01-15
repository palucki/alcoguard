import QtQuick 2.13
import QtQuick.Controls 2.13

Page {
//    width: 600
//    height: 400

    Image {
        id: image
        anchors.centerIn: parent
        width: 200
        height: 200
        source: "../../images/splash.png"
        fillMode: Image.PreserveAspectFit
    }
}
