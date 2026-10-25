<a href="https://github.com/core-haxe/sqlite3/actions/workflows/nodejs.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/nodejs.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/hl.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/hl.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/hxcpp.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/hxcpp.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/neko.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/neko.yaml/badge.svg">

# sqlite3
sqlite3 for all relevant haxe targets

# basic usage

```haxe
var db = new Database("somedb.db");
db.open();
db.exec("CREATE TABLE Persons (PersonID int, LastName varchar(50), FirstName varchar(50));");
db.exec("INSERT INTO Persons (PersonID, LastName, FirstName) VALUES (1, 'Ian', 'Harrigan');");
switch (db.all("SELECT * FROM Persons;"))
{
    case Success(result):
        for (person in result.data) {
            trace(person.FirstName, person.LastName);
        }
    case Fail(error):
        trace(result.data.FirstName, result.data.LastName);
}
switch db.get("SELECT * FROM Persons WHERE PersonID = ?", [1]); // use prepared statement
{
    case Success(result):
        trace(result.data.FirstName, result.data.LastName);
    case Fail(error):
        trace(result.data.FirstName, result.data.LastName);
}
```

# dependencies 

* nodejs - [__sqlite3__](https://www.npmjs.com/package/sqlite3) (`npm install sqlite3`)
* hxcpp - [__libsqlite3__](https://github.com/core-haxe/libsqlite3) (better than haxe's internal sqlite)
* sys - haxe's internal sqlite
