package sqlite;

import sqlite.SqliteError;
import sqlite.SqliteResult;

/**
    A wrapper type which can have either a successful? SQLite command (SqliteResult<Bool>)
    or a failure (SqliteError).
**/
enum SqliteOptBool
{
    Success(result:SqliteResult<Bool>);
    Fail(error:SqliteError);
}
/**
    A wrapper type which can have either a successful? SQLite command (SqliteResult<Dynamic>)
    or a failure (SqliteError).
**/
enum SqliteOptDyn
{
    Success(result:SqliteResult<Dynamic>);
    Fail(error:SqliteError);
}
/**
    A wrapper type which can have either a successful? SQLite command (SqliteResult<Array<Dynamic>>)
    or a failure (SqliteError).
**/
enum SqliteOptArrDyn
{
    Success(result:SqliteResult<Array<Dynamic>>);
    Fail(error:SqliteError);
}