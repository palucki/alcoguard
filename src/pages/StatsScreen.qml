import QtQuick 2.15
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtCharts 2.15
//import QtQml 2.15
import QtQml.Models 2.13

import QtQuick.LocalStorage 2.13

import "../Database.js" as DB
import "../components"

Page {
    signal drinksModified;
    property var sessionToken : ""
    //    property var drinkListModel ;
    //    property var drinkListDelegate;
    //    signal addNewDrink;

    Component.onCompleted: {
        DB.dbInit()
        loadDrinks()
    }

    function updateAxes() {
        if(drinkSortedModel.items.count == 0)
            return;

        var mint = drinkSortedModel.items.get(0).model.timestamp;
        var maxt = drinkSortedModel.items.get(drinkSortedModel.items.count - 1).model.timestamp

        mint.setMinutes(0);
        maxt.setHours(maxt.getHours() + 1);
        maxt.setMinutes(0);

        console.log("new axes [%1 - %2]".arg(Qt.formatDateTime(mint, "hh:mm")).arg(Qt.formatDateTime(maxt, "hh:mm")))

        dateTimeAxis.min = mint;
        dateTimeAxis.max = maxt;
        dateTimeAxis.format = "hh:mm"
        var hoursRange = maxt.getHours() - mint.getHours();
        dateTimeAxis.tickCount = hoursRange > 8 ? 8 : hoursRange; //drinkSortedModel.items.count

        valueAxis.min = 0;
        valueAxis.max = drinkSortedModel.items.count + 1;
        valueAxis.tickAnchor = 0;
        valueAxis.tickType = ValueAxis.TicksDynamic;
        valueAxis.tickInterval = 1;
        valueAxis.labelFormat = "%d"
    }

    function updateGraph() {
        chartViewId.removeAllSeries();

        var series = chartViewId.createSeries(ChartView.SeriesTypeLine, 'vodka', dateTimeAxis, valueAxis);

        for(var j = 0; j < drinkSortedModel.items.count; j ++)
        {
            var x = drinkSortedModel.items.get(j).model.timestamp;
            var y = j+1;
            series.append(x, y);
            //            console.log(x)
        }
    }

    function toMsecsSinceEpoch(date) {
        var msecs = date.getTime();
        return msecs;
    }

    function loadDrinks() {
        var drinks = DB.loadDrinks();

        for(var i = 0; i < drinks.length; i++) {
            addDrink(drinks[i]);
        }

        updateGraph()
        updateAxes();
    }

    function addDrink(drink) {
        drinkModel.append(drink);
    }

    function saveDrink(drink) {
        DB.saveDrink(drink)

        console.log(drink.id, drink.timestamp)
        var index = find(drinkModel, function(item) { return item.id === drink.id })
        if(index !== null)
            drinkModel.remove(index);
        addDrink(drink);

        updateGraph()
        updateAxes();

        drinksModified();
    }

    function removeDrink(id, index) {
        DB.deleteDrink(id)

        if(index !== null)
            drinkModel.remove(index);

        updateGraph()
        updateAxes();

        drinksModified();
    }

    Component {
        id: drinkDelegate
        RowLayout {
            //                height: 50
            Text {
                //text: Qt.formatDateTime(Date.fromLocaleString(Qt.locale(), timestamp, "dd-MM-yyyy hh:mm"), "hh:mm") + " " + amount + unit + " of " + beverage;
                id: textDelegate
                text: Qt.formatDateTime(timestamp, "dddd hh:mm") + " " + amount + unit + " of " + beverage;
                font.pixelSize: 12

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //                        swipeView.currentIndex = main.ScreenIndex.Edit;
                        swipeView.setCurrentIndex(root.addDrinkPageIndex);
                        editDrink.setDrink(drinkModel.get(index))
//                        editDrink.drinkId = drinkModel.get(index).id;
//                        editDrink.itemDateTime = drinkModel.get(index).timestamp;

                    }
                }
            }

            //            Button {
            //                id: editOneButton
            //                text: "Edit"
            ////                icon.source: "../../images/icons/edit.png"
            ////                icon.height: 15
            //                onClicked: {
            //                    swipeView.currentIndex = 5;
            //                    editDrink.drinkId = drinkModel.get(index).id;
            //                    editDrink.itemDateTime = drinkModel.get(index).timestamp;
            //                }
            //            }

            Button {
                id: removeOneButton
                //                anchors.right: masterLayout.right
                text: "Remove"
                //                icon.source: "../../images/icons/remove.png"
                //                icon.height: 15
                onClicked: {
                    removeDrink(drinkModel.get(index).id, index);
                }
            }
        }
    }

    ListModel {
        id: drinkModel
    }

    DelegateModel {
        id: drinkSortedModel
        property var lessThan: [
            function(left, right) {
                return left.timestamp < right.timestamp
            },
            //            function(left, right) { return left.type < right.type },
            //            function(left, right) { return left.age < right.age },
            //            function(left, right) {
            //                if (left.size == "Small")
            //                    return true
            //                else if (right.size == "Small")
            //                    return false
            //                else if (left.size == "Medium")
            //                    return true
            //                else
            //                    return false
            //            }
        ]

        property int sortOrder: 0; //orderSelector.selectedIndex
        onSortOrderChanged: items.setGroups(0, items.count, "unsorted")

        //![6]
        //![3]
        function insertPosition(lessThan, item) {
            var lower = 0
            var upper = items.count
            while (lower < upper) {
                var middle = Math.floor(lower + (upper - lower) / 2)
                var result = lessThan(item.model, items.get(middle).model);
                if (result) {
                    upper = middle
                } else {
                    lower = middle + 1
                }
            }
            return lower
        }

        function sort(lessThan) {
            while (unsortedItems.count > 0) {
                var item = unsortedItems.get(0)
                var index = insertPosition(lessThan, item)

                item.groups = "items"

                items.move(item.itemsIndex, index)
            }
        }
        //![3]

        //![1]
        items.includeByDefault: false
        //![5]
        groups: DelegateModelGroup {
            id: unsortedItems
            name: "unsorted"

            includeByDefault: true
            //![1]
            onChanged: {
                if (drinkSortedModel.sortOrder == drinkSortedModel.lessThan.length)
                    setGroups(0, count, "items")
                else
                    drinkSortedModel.sort(drinkSortedModel.lessThan[0])
            }
            //![2]
        }
        //![2]
        //![5]
        model: drinkModel
        delegate: drinkDelegate
    }


    AddDrinkButton {
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
            //            ListView {
            //                id: alcoListId
            //            anchors.top: chartViewId.bottom
            //                Layout.alignment: Qt.AlignHCenter
            //                Layout.preferredWidth: masterLayout.width
            //                Layout.preferredHeight: 0.3 * masterLayout.height
            ////                Layout.fillHeight: true

            //                clip: true
            //                model: drinkSortedModel
            //                delegate: drinkListDelegate
            //                ScrollBar.vertical: ScrollBar { id: scrollBarId}
            //            }

            ListView {
                id: alcoListId
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: masterLayout.width
                Layout.preferredHeight: 0.6 * masterLayout.height
                //                anchors {
                //                    left: parent.left; top: parent.top; right: parent.right;// bottom: orderSelector.top;
                //                    margins: 2
                //                }
                clip: true
                model: drinkSortedModel
                ScrollBar.vertical: ScrollBar { id: scrollBarId}

                spacing: 4
                cacheBuffer: 50
            }

        }

    }
}
