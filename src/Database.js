function dbInit() {
    console.log("Initializing database");

    db = LocalStorage.openDatabaseSync("sqlitedemodb", "1.0", "DemoDatabase", 100000);

    db.transaction( function(tx) {
        print('... create table')
        tx.executeSql('CREATE TABLE IF NOT EXISTS users(name TEXT, password TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS users(name TEXT, password TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS users(name TEXT, password TEXT)');
    });

}

function addUser(){
    console.log("Storing data...")

    if(!db || login.text === "" || password.text === "")
        return;

    db.transaction(function(tx){
        var result = tx.executeSql("SELECT * FROM users WHERE name = '%1'".arg(login.text));

        if(result.rows.length === 1) {
            //update
            console.log("Updating the user %1".arg(login.text));
        }
        else {
            console.log("Inserting the user %1".arg(login.text));
            tx.executeSql('INSERT INTO users VALUES (?,?)',[login.text, password.text]);
        }

    });
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
