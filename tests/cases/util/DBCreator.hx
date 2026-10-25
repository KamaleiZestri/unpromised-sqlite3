package cases.util;

import sqlite.Database;
import sqlite.SqliteError;
import sys.FileSystem;
import sys.io.File;

class DBCreator {
    private static var counter:Int = 0;
    private static var db:Database;
    public static var filename:String;

    public static function create(createDummyData:Bool = true):Bool {
        // While .close() guarantees the database itself is "closed" for read/write purposes on callback, the OS cannot be guaranteed to immediately release the file lock.
        var mangleNames = true;

        if (db != null) {
            db.close();
        }

        if (mangleNames == true) {
            filename = "persons" + counter + ".db";
            counter++;
        } else {
            filename = "persons.db";
        }

        if (FileSystem.exists(filename)) {
            FileSystem.deleteFile(filename);
        }
        File.saveContent(filename, "");
        db = new Database(filename);
        db.open();
        var res = db.exec("CREATE TABLE Person (
            personId INTEGER PRIMARY KEY AUTOINCREMENT,
            lastName varchar(50),
            firstName varchar(50),
            iconId int,
            contractDocument blob
        );");
        if (res.getName() == "SqliteError")
        {
            trace(res.getParameters()[0]);
            return false;
        }
        res = db.exec("CREATE TABLE Icon (
            iconId int,
            path varchar(50)
        );");
        if (res.getName() == "SqliteError")
        {
            trace(res.getParameters()[0]);
            return false;
        }
        res = db.exec("CREATE TABLE Organization (
            organizationId int,
            name varchar(50),
            iconId int
        );");
        if (res.getName() == "SqliteError")
        {
            trace(res.getParameters()[0]);
            return false;
        }
        res = db.exec("CREATE TABLE Person_Organization (
            Person_personId int,
            Organization_organizationId int
        );");
        if (res.getName() == "SqliteError")
        {
            trace(res.getParameters()[0]);
            return false;
        }
        db.close();

        if (createDummyData) {
            return addDummyData();
        } else {
            return true;
        }
    }
    private static inline function printError(error:SqliteError)
    {
        trace("error", error.name, error.message);
    }

    public static function addDummyData():Bool {
        db.open();

        db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (1, '/somepath/icon1.png');");
        db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (2, '/somepath/icon2.png');");
        db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (3, '/somepath/icon3.png');");

        db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId, contractDocument) VALUES (1, 'Ian', 'Harrigan', 1, X'746869732069732069616e7320636f6e747261637420646f63756d656e74');");
        db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (2, 'Bob', 'Barker', 3);");
        db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (3, 'Tim', 'Mallot', 2);");
        db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (4, 'Jim', 'Parker', 1);");

        db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (1, 'ACME Inc', 2);");
        db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (2, 'Haxe LLC', 1);");
        db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (3, 'PASX Ltd', 3);");

        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (1, 1);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (2, 1);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (3, 1);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (2, 2);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (4, 2);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (1, 3);");
        db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (4, 3);");

        db.close();
        return true;
    }

    public static function delete() {
        db.close();
        //FileSystem.deleteFile(filename);
    }
}