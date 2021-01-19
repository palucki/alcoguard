import QtQuick 2.15
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtCharts 2.15
//import QtQml 2.15
Page {
    property var sessionToken : ""
    property var drinkListModel;
    property var drinkListDelegate;
    property var beverages: ["vodka", "beer", "wine", "whisky"]
    signal addDrink;
    //    property var locale: Qt.locale()

    //    Component.onCompleted: {
    //        addSeries()
    //    }

    //    function addSeries()
    //    {
    //        for(var i = 0; i < beverages.count; ++i)
    //            console.log(beverages[i]);
    //    }

    function updateGraph(model) {
        chartViewId.removeAllSeries();

        //        var min = new Date()
        //        var max = new Date(1970,0,1);

        var series = chartViewId.createSeries(ChartView.SeriesTypeLine, beverages[0], dateTimeAxis, valueAxis);

        for(var j = 0; j < model.count; j ++)
        {
            var x = toMsecsSinceEpoch(model.get(j).timestamp);
            var y = j+1;
            series.append(x, y);

            //            min = min > model.get(j).timestamp ? model.get(j).timestamp : min;
            //            max = max < model.get(j).timestamp ? model.get(j).timestamp : max;
        }

        dateTimeAxis.min = new Date(2021,0,20,0,0);
        dateTimeAxis.max = new Date();

        valueAxis.min = 0;
        valueAxis.max = model.count + 1;
    }

    function toMsecsSinceEpoch(date) {
        var msecs = date.getTime();
        return msecs;
    }

    ColumnLayout {
        id: masterLayout
        spacing: 10
        anchors.fill:parent

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            ChartView { //different types
                id: chartViewId
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: masterLayout.width
                Layout.preferredHeight: 0.3 * masterLayout.height
                antialiasing: true
                title: "Drinks consumption over time"
                //                LineSeries {
                //                    id : vodkaSeries
                //                    axisX: DateTimeAxis {
                //                        format: "hh:mm"
                //                    }
                //                    axisY: ValueAxis {
                //                        min: 0
                //                        max: 150
                //                    }

                //                    name: beverages[0]
                //                    XYPoint { x: toMsecsSinceEpoch(new Date(2021, 0, 19, 23, 00)); y: 1 }
                //                    XYPoint { x: toMsecsSinceEpoch(new Date(2021, 0, 19, 23, 10)); y: 2 }
                //                    XYPoint { x: toMsecsSinceEpoch(new Date(2021, 0, 19, 23, 20)); y: 3 }
                //                    XYPoint { x: toMsecsSinceEpoch(new Date(2021, 0, 19, 23, 25)); y: 4 }
                //                    XYPoint { x: toMsecsSinceEpoch(new Date(2021, 0, 19, 23, 30)); y: 5 }
                //                }

                axes: [
                    DateTimeAxis {
                        id: dateTimeAxis
                        format: "hh:mm"
                    },
                    ValueAxis {
                        id: valueAxis
//                        min: 0
//                        max: 30
                    }
                ]
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            ListView {
                id: alcoListId
                //            anchors.top: chartViewId.bottom
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: masterLayout.width
                Layout.preferredHeight: 0.6 * masterLayout.height
                Layout.fillHeight: true

                clip: true
                model: drinkListModel
                delegate: drinkListDelegate
                ScrollBar.vertical: ScrollBar { id: scrollBarId}
            }

        }


        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Button {
                id: addButtonOptions
                Layout.preferredHeight: 50
                Layout.preferredWidth: 150
                Layout.alignment: Qt.AlignHCenter
                text: "Add"
                icon.source: "../../images/icons/add.png"
                onClicked: addDrink()
            }
        }
    }
}
