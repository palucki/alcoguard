function dbInit() {
    console.log("Opening database");
    db = LocalStorage.openDatabaseSync("drinks", "1.0", "DrinksDatabase", 100000);
}

function daysWithDrink() {
    if(!db)
        return;

    var days = [];

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT distinct date(consumed) as drinkdate FROM drink order by date(consumed);");

        for(var i = 0; i < result.rows.length; i++) {
            days.push(result.rows.item(i).drinkdate);
        }
    });

    return days;
}

function deleteBeverage(id) {
    console.log("Deleting beverage. Id: " + id)

    if(!db)
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("DELETE FROM beverage WHERE id = %1".arg(id));
    });

    console.log("Beverage deleted")
}

function saveBeverage(beverage) {
    if(!db)
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT id FROM beverage WHERE id = ?", [beverage.id]);

        if(result.rows.length === 1) {
            tx.executeSql('UPDATE beverage SET name = ? WHERE id = ?',
                          [beverage.name, beverage.id]);
        }
        else {
            result = tx.executeSql('INSERT INTO beverage (name) VALUES (?)',
                                   [beverage.name]);
            beverage.id = parseInt(result.insertId);
        }
    });
}

function loadBeverages() {
    if(!db)
        return;

    var beverages = [];

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT id, name FROM beverage ORDER BY id");

        for(var i = 0; i < result.rows.length; i++) {
            var beverage = {
                "id" : parseInt(result.rows.item(i).id),
                "name": result.rows.item(i).name
            }
            beverages.push(result.rows.item(i));
        }
    });

    return beverages;
}

function loadDrinks(date) {
    if(!db)
        return;

    var drinks = [];

    db.transaction(function(tx){
        var result;
        if(date === undefined)
            result = tx.executeSql("SELECT d.id, beverage_id, b.name AS beverage_name, amount_ml, consumed FROM drink AS d LEFT JOIN beverage AS b on d.beverage_id = b.id;");
        else
            result = tx.executeSql("SELECT d.id, beverage_id, b.name AS beverage_name, amount_ml, consumed " +
                                   "FROM drink AS d LEFT JOIN beverage AS b on d.beverage_id = b.id WHERE date(consumed) = date(?);",[date]);

        for(var i = 0; i < result.rows.length; i++) {
            var res = result.rows.item(i);

            var drink = {
                "id" : parseInt(result.rows.item(i).id),
                "timestamp": new Date(result.rows.item(i).consumed),
                "beverageId" : result.rows.item(i).beverage_id,
                "beverage" : result.rows.item(i).beverage_name,
                "amount" : parseInt(result.rows.item(i).amount_ml),
                "unit" : "ml"
            }

            drinks.push(drink);
        }
    });

    return drinks;
}

function saveDrink(drink) {
    console.log("Adding drink...")

    if(!db)
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT id FROM drink WHERE id = ?", [drink.id]);

        if(result.rows.length === 1) {
            tx.executeSql('UPDATE drink SET beverage_id = ?, amount_ml = ?, consumed = ? WHERE id = ?',
                          [drink.beverage_id, drink.amount, drink.timestamp, drink.id]);
        }
        else {
            result = tx.executeSql('INSERT INTO drink (beverage_id, amount_ml, consumed) VALUES (?,?,?)',
                                   [drink.beverage_id, drink.amount, drink.timestamp]);
            drink.id = parseInt(result.insertId);
        }
    });

    console.log("Drink added. Id: " + drink.id)
}

function deleteDrink(id) {
    console.log("Deleting drink. Id: " + id)

    if(!db)
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("DELETE FROM drink WHERE id = %1".arg(id));
    });

    console.log("Drink deleted")
}

function loginUser() {
    console.log("Storing data...")

    if(!db || login.text === "" || password.text === "")
        return false;

    if(db.transaction(function(tx){
        var result = tx.executeSql("SELECT password FROM users WHERE name = '%1'".arg(login.text));

        if(result.rows.length === 1) {
            console.log("Loging the user %1".arg(login.text));

            var dbPass = result.rows.item(0).password;
            if(dbPass === password.text) {
                console.log("Login successful")
                isLoggedIn = true;
                //                loggedUser.loggedText = "Logged as " + login.text;
                //                return true;
            }
            else {
                console.log("Login failed - incorrect password")
                console.log(dbPass)
                isLoggedIn = false;
                //                loggedUser.loggedText = "Unauthorized";
            }

            //            return false;
        }
        else {
            console.log("No such user: %1".arg(login.text));
        }

    })) {
        console.log("Transaction successed ")
        return true;
    }

    console.log("Transaction failed ")
    return false;
}
