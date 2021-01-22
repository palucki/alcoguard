import QtQuick 2.13
import QtQml 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13

Page {

    property var visibleTimeItems : 6
    property int timeTumberHeight : 120
    property int dateTumblerHeight: 60
    property var visibleDateItems : 3
    property date itemDateTime;
    property var drinkId : null;
    signal saveDrink;
    property var beverages;
    function getDrink() {
        return {
            "id" : drinkId,
            "timestamp": selectedDate(),
            "beverage" : beverageCombo.currentText,
            "amount" : amountSpinBox.value,
            "unit" : "ml"
        }
    }

    function selectedDate() {
        var day = dayTumbler.currentIndex + 1;
        var month = monthTumbler.currentIndex;
        var year = yearTumbler.currentIndex + 1970 ;
        var hour = hoursTumbler.currentIndex;
        var minute = minutesTumbler.currentIndex;

        console.log(Qt.formatDateTime(new Date(year, month, day, hour, minute), "dd-MM-yyyy hh:mm"))

        //        return Qt.formatDateTime(new Date(year, month, day, hour, minute), "dd-MM-yyyy hh:mm")
        return new Date(year, month, day, hour, minute)
    }

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


    ColumnLayout {
        id: masterLayout
        spacing: 10
        anchors.centerIn: parent

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Row {
                id: dateRow
                //                anchors.horizontalCenter: parent.horizontalCenter
                height: dateTumblerHeight
                Tumbler {
                    id: dayTumbler
                    model: 31
                    delegate: delegateComponent
                    visibleItemCount: visibleDateItems
                    height: parent.height
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
                    height: parent.height
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
                    height: parent.height
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
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Row {
                id: timeRow
                //                anchors.horizontalCenter: parent.horizontalCenter
                height: timeTumberHeight
                Tumbler {
                    id: hoursTumbler
                    model: 24
                    delegate: delegateComponent
                    visibleItemCount: visibleTimeItems
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
                    visibleItemCount: visibleTimeItems
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
        }


        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            SpinBox {
                id: amountSpinBox
                value: 50
                stepSize: 5

                textFromValue: function(value, locale) {
                    return qsTr("%1 ml").arg(value);
                }
            }

            ComboBox {
                id: beverageCombo
                model: beverages
            }
        }


    }


    ColumnLayout {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        ColumnLayout {
            Button {
                id: addButtonOptions
                Layout.preferredHeight: 50
                Layout.preferredWidth: 150
                text: "Save"
                icon.source: "../../images/icons/add.png"
                onClicked: saveDrink()
            }
        }
    }


    //    Column {
    //        anchors.centerIn: parent
    //        Row {
    //            id: dateRow
    //            anchors.horizontalCenter: parent.horizontalCenter
    //            height: dateTumblerHeight
    //            Tumbler {
    //                id: dayTumbler
    //                model: 31
    //                delegate: delegateComponent
    //                visibleItemCount: visibleDateItems
    //                height: parent.height
    //                contentItem: ListView {
    //                    model: dayTumbler.model
    //                    delegate: dayTumbler.delegate

    //                    snapMode: ListView.SnapToItem
    //                    highlightRangeMode: ListView.StrictlyEnforceRange
    //                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
    //                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
    //                    clip: true
    //                }
    //            }
    //            Tumbler {
    //                id: monthTumbler
    //                model: 12
    //                delegate: delegateComponent
    //                visibleItemCount: visibleDateItems
    //                height: parent.height
    //                contentItem: ListView {
    //                    model: monthTumbler.model
    //                    delegate: monthTumbler.delegate

    //                    snapMode: ListView.SnapToItem
    //                    highlightRangeMode: ListView.StrictlyEnforceRange
    //                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
    //                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
    //                    clip: true
    //                }
    //            }
    //            Tumbler {
    //                id: yearTumbler
    //                model: 100
    //                delegate: delegateComponent
    //                visibleItemCount: visibleDateItems
    //                height: parent.height
    //                contentItem: ListView {
    //                    model: yearTumbler.model
    //                    delegate: yearTumbler.delegate

    //                    snapMode: ListView.SnapToItem
    //                    highlightRangeMode: ListView.StrictlyEnforceRange
    //                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
    //                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
    //                    clip: true
    //                }
    //            }
    //        }

    //        Row {
    //            id: timeRow
    //            anchors.horizontalCenter: parent.horizontalCenter
    //            height: timeTumberHeight
    //            Tumbler {
    //                id: hoursTumbler
    //                model: 24
    //                delegate: delegateComponent
    //                visibleItemCount: visibleTimeItems
    //                height: parent.height
    //                contentItem: ListView {
    //                    height: 100
    //                    model: hoursTumbler.model
    //                    delegate: hoursTumbler.delegate

    //                    snapMode: ListView.SnapToItem
    //                    highlightRangeMode: ListView.StrictlyEnforceRange
    //                    preferredHighlightBegin: height / 2 - (height / hoursTumbler.visibleItemCount / 2)
    //                    preferredHighlightEnd: height / 2 + (height / hoursTumbler.visibleItemCount / 2)
    //                    clip: true
    //                }
    //            }

    //            Tumbler {
    //                id: minutesTumbler
    //                model: 60
    //                delegate: delegateComponent
    //                visibleItemCount: visibleTimeItems
    //                height: parent.height
    //                contentItem:

    //                    ListView { //change to PathView to have better effects and wrappig around
    //                    model: minutesTumbler.model
    //                    delegate: minutesTumbler.delegate

    //                    snapMode: ListView.SnapToItem
    //                    highlightRangeMode: ListView.StrictlyEnforceRange
    //                    preferredHighlightBegin: height / 2 - (height / minutesTumbler.visibleItemCount / 2)
    //                    preferredHighlightEnd: height / 2 + (height / minutesTumbler.visibleItemCount / 2)
    //                    clip: true
    //                }
    //            }



    //        }
    //    }



}
