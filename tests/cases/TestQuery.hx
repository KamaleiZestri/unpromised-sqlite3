package cases;

import cases.util.DBCreator;
import sqlite.Database;
import utest.Assert;
import utest.Async;
import utest.Test;

class TestQuery extends Test {
    function setup(async:Async) {
        DBCreator.create();
        async.done();
    }

    function teardown(async:Async) {
        DBCreator.delete();
        async.done();
    }
    
    function testBasicSelect(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.all("SELECT * FROM Person"))
        {
            case Success(result):
                Assert.equals(4, result.data.length);

                Assert.equals(result.data[0].personId, 1);
                Assert.equals(result.data[0].firstName, "Ian");
                Assert.equals(result.data[0].lastName, "Harrigan");
                Assert.equals(result.data[0].iconId, 1);
        
                Assert.equals(result.data[2].personId, 3);
                Assert.equals(result.data[2].firstName, "Tim");
                Assert.equals(result.data[2].lastName, "Mallot");
                Assert.equals(result.data[2].iconId, 2);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }

    function testBasicSelectOne(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.get("SELECT * FROM Person"))
        {
            case Success(result):
                Assert.equals(result.data.personId, 1);
                Assert.equals(result.data.firstName, "Ian");
                Assert.equals(result.data.lastName, "Harrigan");
                Assert.equals(result.data.iconId, 1);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }

    function testBasicSelectWhere(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.all("SELECT * FROM Person WHERE personId = 1"))
        {
            case Success(result):
                Assert.equals(1, result.data.length);

                Assert.equals(result.data[0].personId, 1);
                Assert.equals(result.data[0].firstName, "Ian");
                Assert.equals(result.data[0].lastName, "Harrigan");
                Assert.equals(result.data[0].iconId, 1);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }

    function testBasicSelectWhereOr(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.all("SELECT * FROM Person WHERE personId = 1 OR personId = 4"))
        {
            case Success(result):
                Assert.equals(2, result.data.length);

                Assert.equals(result.data[0].personId, 1);
                Assert.equals(result.data[0].firstName, "Ian");
                Assert.equals(result.data[0].lastName, "Harrigan");
                Assert.equals(result.data[0].iconId, 1);
        
                Assert.equals(result.data[1].personId, 4);
                Assert.equals(result.data[1].firstName, "Jim");
                Assert.equals(result.data[1].lastName, "Parker");
                Assert.equals(result.data[1].iconId, 1);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }

    function testBasicSelectWhereAnd(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open();
        switch (db.all("SELECT * FROM Person WHERE personId = 1 AND firstName = 'Ian'"))
        {
            case Success(result):
                Assert.equals(1, result.data.length);

                Assert.equals(result.data[0].personId, 1);
                Assert.equals(result.data[0].firstName, "Ian");
                Assert.equals(result.data[0].lastName, "Harrigan");
                Assert.equals(result.data[0].iconId, 1);
            case Fail(error):
                trace("error", error);
        }
        db.close();
        async.done();
    }
}