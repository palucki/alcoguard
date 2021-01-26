function dbInit() {
    console.log("Opening database");
    db = LocalStorage.openDatabaseSync("drinks", "1.0", "DrinksDatabase", 100000);
}

function saveDrink(drink) {
    console.log("Adding drink...")

    if(!db)
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT id FROM drink WHERE id = %1".arg(drink.id));

        if(result.rows.length === 1) {
            tx.executeSql('UPDATE drink SET beverage_id = ?, amount_ml = ?, consumed = ? WHERE id = ?',
                          [1, drink.amount, drink.timestamp, drink.id]);
        }
        else {
            result = tx.executeSql('INSERT INTO drink (beverage_id, amount_ml, consumed) VALUES (?,?,?)',
                          [1, drink.amount, drink.timestamp]);
            drink.id = result.insertId;
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
