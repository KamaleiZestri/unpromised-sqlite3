package cases;

import cases.util.DBCreator;
import haxe.io.Bytes;
import sqlite.Database;
import utest.Assert;
import utest.Async;
import utest.Test;

class TestPreparedBlob extends Test {
    function setup(async:Async) {
        DBCreator.create();
        async.done();
    }

    function teardown(async:Async) {
        DBCreator.delete();
        async.done();
    }
    
    function testBasicBlobPreparedInsert(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        var res = db.run("INSERT INTO Person (lastName, firstName, iconId, contractDocument) VALUES (?, ?, ?, ?)", ["new last name", "new first name", 1, Bytes.ofString("this is a new contract document")]);
        switch (res)
        {
            case Success(result):
                Assert.notNull(result);
                Assert.notNull(result.data);
                Assert.equals(5, result.data.lastID);
            case Fail(error):
                trace("error", error);
        }

        switch (db.all("SELECT * FROM Person WHERE personId = 5"))
        {
            case Success(result):
                Assert.equals(result.data[0].personId, 5);
                Assert.equals(result.data[0].firstName, "new first name");
                Assert.equals(result.data[0].lastName, "new last name");
                Assert.equals(result.data[0].iconId, 1);
                Assert.isOfType(result.data[0].contractDocument, Bytes);
                Assert.equals(Bytes.ofString("this is a new contract document").toString(), result.data[0].contractDocument.toString());
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }
}