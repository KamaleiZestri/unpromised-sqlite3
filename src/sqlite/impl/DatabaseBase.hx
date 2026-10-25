package sqlite.impl;

import sqlite.SqliteOptions.SqliteOptArrDyn;
import sqlite.SqliteOptions.SqliteOptBool;
import sqlite.SqliteOptions.SqliteOptDyn;

class DatabaseBase {
    public var filename:String;
    public var openMode:Null<SqliteOpenMode>;

    public function new(filename:String, ?openMode:SqliteOpenMode) {
        this.filename = filename;
        this.openMode = openMode;
    }

    public function open():SqliteOptBool {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::open" not implemented'));
    }

    public function exec(sql:String):SqliteOptBool {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::exec" not implemented'));
    }

    public function get(sql:String, ?param:Dynamic):SqliteOptDyn {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::get" not implemented'));
    }

    public function run(sql:String, ?param:Dynamic):SqliteOptDyn {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::run" not implemented'));
    }

    public function all(sql:String, ?param:Dynamic):SqliteOptArrDyn {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::all" not implemented'));
    }

    public function close():SqliteOptBool {
        return Fail(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::close" not implemented'));
    }
}