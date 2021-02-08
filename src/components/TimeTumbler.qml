import QtQuick 2.13
import QtQml 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Item {
    property var visibleItemCount;
    property var tumblerHeight;
    id: root

    Row {
        id: timeRow
        height: tumblerHeight
        Tumbler {
            id: hoursTumbler
            model: 24
            delegate: delegateComponent
            visibleItemCount: visibleItemCount
            height: parent.height
            contentItem: ListView {
                height: 100
                model: hoursTumbler.model
                delegate: hoursTumbler.delegate

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
                clip: true
            }
        }

        Tumbler {
            id: minutesTumbler
            model: 60
            delegate: delegateComponent
            visibleItemCount: visibleItemCount
            height: parent.height
            contentItem:

                ListView { //change to PathView to have better effects and wrappig around
                model: minutesTumbler.model
                delegate: minutesTumbler.delegate

                snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: height / 2 - (height / minutesTumbler.visibleItemCount / 2)
                preferredHighlightEnd: height / 2 + (height / minutesTumbler.visibleItemCount / 2)
                clip: true
            }
        }
    }

    function formatTimeText(count, modelData) {
        return modelData.toString().length < 2 ? "0" + modelData : modelData;
    }

    Component {
        id: delegateComponent
        Label {
            text: Tumbler.tumbler.count === 24 || Tumbler.tumbler.count == 60 ? formatTimeText(Tumbler.tumbler.count, modelData) :
                                                                                Tumbler.tumbler.count === 31 ? formatDayText(modelData) :
                                                                                                               Tumbler.tumbler.count === 12  ? formatMonthText(modelData) : formatYearText(modelData);
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
