import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQml 2.13
import QtQuick.Layouts 1.13

Page {

    property var visibleTimeItems : 8
    property var visibleDateItems : 3
    property date itemDateTime : new Date("01-01-1970 00:00");

    onItemDateTimeChanged: {
        console.log("Cuurent time " + itemDateTime);
        var hour = parseInt(Qt.formatTime(itemDateTime, "hh"));
        var minute =  parseInt(Qt.formatTime(itemDateTime, "mm"));
        hoursTumbler.contentItem.positionViewAtIndex(hour, ListView.Center);
        hoursTumbler.currentIndex = hour;
        minutesTumbler.contentItem.positionViewAtIndex(minute, ListView.Center);
        minutesTumbler.currentIndex = minute;

        var day = parseInt(Qt.formatDate(itemDateTime, "d"));
        var month = parseInt(Qt.formatDate(itemDateTime, "M"));
        var year = parseInt(Qt.formatDate(itemDateTime, "yyyy"));

        dayTumbler.contentItem.positionViewAtIndex(day-1, ListView.Center);
        dayTumbler.currentIndex = day-1;

        monthTumbler.contentItem.positionViewAtIndex(month-1, ListView.Center);
        monthTumbler.currentIndex = month-1;


        var startIndex = 1970; //corresponds to 0
        var yearIndex = year - 1970;

        yearTumbler.contentItem.positionViewAtIndex(yearIndex, ListView.Center);
        yearTumbler.currentIndex = yearIndex;
    }

    function formatTimeText(count, modelData) {
        return modelData.toString().length < 2 ? "0" + modelData : modelData;
    }

    function formatDayText(modelData) {
        return(modelData + 1).toString().length < 2 ? "0" + (modelData + 1) : modelData + 1;
    }
    function formatMonthText(modelData) {
        return (modelData + 1).toString().length < 2 ? "0" + (modelData + 1) : modelData + 1;
    }
    function formatYearText(modelData) {
        var year = 1970;
        year += modelData;
        return year.toString();
    }

    FontMetrics {
        id: fontMetrics
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


    Column {
        anchors.centerIn: parent
        Row {
            id: dateRow
            anchors.horizontalCenter: parent.horizontalCenter

            Tumbler {
                id: dayTumbler
                model: 31
                delegate: delegateComponent
                visibleItemCount: visibleDateItems

                contentItem: ListView {
                    model: dayTumbler.model
                    delegate: dayTumbler.delegate

                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
                    clip: true
                }
            }
            Tumbler {
                id: monthTumbler
                model: 12
                delegate: delegateComponent
                visibleItemCount: visibleDateItems

                contentItem: ListView {
                    model: monthTumbler.model
                    delegate: monthTumbler.delegate

                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
                    clip: true
                }
            }
            Tumbler {
                id: yearTumbler
                model: 100
                delegate: delegateComponent
                visibleItemCount: visibleDateItems

                contentItem: ListView {
                    model: yearTumbler.model
                    delegate: yearTumbler.delegate

                    snapMode: ListView.SnapToItem
                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
                    clip: true
                }
            }
        }

        Row {
            id: timeRow
            anchors.horizontalCenter: parent.horizontalCenter

            Tumbler {
                id: hoursTumbler
                model: 24
                delegate: delegateComponent
                visibleItemCount: visibleTimeItems

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
                visibleItemCount: visibleTimeItems

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
    }



}
