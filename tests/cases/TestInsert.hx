package cases;

import cases.util.DBCreator;
import sqlite.Database;
import utest.Assert;
import utest.Async;
import utest.Test;

class TestInsert extends Test {
    function setup(async:Async) {
        DBCreator.create();
        async.done();
    }

    function teardown(async:Async) {
        DBCreator.delete();
        async.done();
    }
    
    function testBasicInsert(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.run("INSERT INTO Person (lastName, firstName, iconId) VALUES ('new last name', 'new first name', 1)"))
        {
            case Success(result):
                Assert.notNull(result);
                Assert.notNull(result.data);
                Assert.equals(5, result.data.lastID);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }
}