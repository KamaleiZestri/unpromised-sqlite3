package sqlite.impl.cpp;

import sqlite.Sqlite;
import sqlite.SqliteDatabase as NativeDatabase;
import sqlite.SqliteOptions.SqliteOptArrDyn;
import sqlite.SqliteOptions.SqliteOptBool;
import sqlite.SqliteOptions.SqliteOptBool;
import sqlite.SqliteOptions.SqliteOptDyn;
import sqlite.SqliteStatement as NativeStatement;

class SqliteDatabase extends DatabaseBase {
    private var _nativeDB:NativeDatabase = null;

    public override function open():SqliteOptBool{
        _nativeDB = Sqlite.open(this.filename);
        return Success(new SqliteResult(this, true));
    }

    public override function exec(sql:String):SqliteOptBool {
        try {
            if (_nativeDB == null) {
                return Fail(new SqliteError("Error", "Database not open"));
            }
            var stmt = prepareStatement(sql);
            stmt.executeStatement();
            stmt.close();
            var result = new SqliteResult(this, true);
            result.lastID = _nativeDB.lastInsertRowId();
            result.changes = _nativeDB.changes();
            return Success(result);
        } catch (e:Dynamic) {
            return Fail(new SqliteError("Error", "SQLITE_ERROR: " + e));
        }
    }

    public override function get(sql:String, ?param:Dynamic):SqliteOptDyn {
        try {
            if (_nativeDB == null) {
                return Fail(new SqliteError("Error", "Database not open"));
            }
            var stmt = prepareStatement(sql, param);
            var rs = stmt.executeQuery();
            if (!rs.hasNext()) {
                stmt.close();
                return Success(new SqliteResult(this, null));
            }

            var result = rs.next();
            stmt.close();
            var result = new SqliteResult(this, result);
            result.lastID = _nativeDB.lastInsertRowId();
            result.changes = _nativeDB.changes();
            return Success(result);
        } catch (e:Dynamic) {
            return Fail(new SqliteError("Error", "SQLITE_ERROR: " + e));
        }
    }

    public override function all(sql:String, ?param:Dynamic):SqliteOptArrDyn {
        try {
            if (_nativeDB == null) {
                return Fail(new SqliteError("Error", "Database not open"));
            }
            var stmt = prepareStatement(sql, param);
            var rs = stmt.executeQuery();
            var records:Array<Dynamic> = [];
            while (rs.hasNext()) {
                records.push(rs.next());
            }
            stmt.close();
            var result = new SqliteResult(this, records);
            result.lastID = _nativeDB.lastInsertRowId();
            result.changes = _nativeDB.changes();
            return Success(result);
        } catch (e:Dynamic) {
            return Fail(new SqliteError("Error", "SQLITE_ERROR: " + e));
        }
    }

    public override function run(sql:String, ?param:Dynamic):SqliteOptDyn {
        try {
            if (_nativeDB == null) {
                return Fail(new SqliteError("Error", "Database not open"));
            }
            var stmt = prepareStatement(sql, param);
            stmt.executeStatement();
            stmt.close();
            var data = null;
            if (sql.indexOf("INSERT ") != -1) {
                var lastInsertedId = _nativeDB.lastInsertRowId();
                data = {
                    lastID: lastInsertedId
                }
            }
            var result = new SqliteResult(this, data);
            result.lastID = _nativeDB.lastInsertRowId();
            result.changes = _nativeDB.changes();
            return Success(result);
        } catch (e:Dynamic) {
            return Fail(new SqliteError("Error", "SQLITE_ERROR: " + e));
        }
    }

    private function prepareStatement(sql:String, param:Dynamic = null):NativeStatement {
        sql = StringTools.trim(sql);
        var stmt = _nativeDB.prepare(sql);
        if (sql.indexOf("?") == -1) {
            return stmt;
        }

        var params = [];
        if (param != null) {
            params = switch (Type.typeof(param)) {
                case TClass(Array):
                    param;
                case _:
                    [param];
            }
        }

        var r = ~/\?/gm;
        var index = 1; // index is 1-based, nice... :/
        r.map(sql, f -> {
            var p:Any = params.shift();
            switch (Type.typeof(p)) {
                case TClass(String):
                    stmt.bindString(index, p);
                case TBool:
                    stmt.bindInt(index, p == true ? 1 : 0);
                case TFloat:
                    stmt.bindFloat(index, p);
                case TInt:
                    stmt.bindInt(index, p);
                case TClass(haxe.io.Bytes):
                    stmt.bindBytes(index, p);
                case _:
                    trace("UKNONWN:", Type.typeof(p));
            }
            index++;
            return null;
        });

        return stmt;
    }

    public override function close():SqliteOptBool {
        _nativeDB.close();
        return Success(new SqliteResult(this, true));
    }
}