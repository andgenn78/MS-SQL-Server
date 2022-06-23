using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [SqlProcedure]
    public static void Add(SqlInt32 n1, SqlInt32 n2, out SqlInt32 result)
    {
        result = n1 + n2;
    }

    [SqlProcedure]
    public static void Inc(SqlInt32 n, ref SqlInt32 result)
    {
        result += n;
    }

    [SqlProcedure]
    public static void Echo(SqlString message)
    {
        var pipe = SqlContext.Pipe;
        pipe.Send(message.Value);
    }

    [SqlProcedure]
    public static void Fibonacci(SqlInt32 first, SqlInt32 second, SqlInt32 length)
    {
        var metadata = new SqlMetaData[2];
        metadata[0] = new SqlMetaData("position", SqlDbType.Int);
        metadata[1] = new SqlMetaData("value", SqlDbType.Int);

        var dataRecord = new SqlDataRecord(metadata);
        var pipe = SqlContext.Pipe;
        pipe.SendResultsStart(dataRecord);

        var position = 1;
        dataRecord.SetSqlInt32(0, position);
        dataRecord.SetSqlInt32(1, first);
        pipe.SendResultsRow(dataRecord);
        position += 1;
        dataRecord.SetSqlInt32(0, position);
        dataRecord.SetSqlInt32(1, second);
        pipe.SendResultsRow(dataRecord);
        var preceding2 = first;

        while (position < length)
        {
            position += 1;
            dataRecord.SetSqlInt32(0, position);
            var preceding1 = dataRecord.GetSqlInt32(1);
            dataRecord.SetSqlInt32(1, preceding2 + preceding1);
            pipe.SendResultsRow(dataRecord);
            preceding2 = preceding1;
        }

        pipe.SendResultsEnd();
    }


    [SqlProcedure]
    public static void sp_CountBiggerThen(int n)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
            "select count(*) from Table3 where [Col1] > @limit;", conn))
        {
            cmd.Parameters.AddWithValue("@limit", n);
            conn.Open();
            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }

    [SqlProcedure]  
    public static void GetAllObjects()
    {
        using (SqlConnection con = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand("select name, object_id from sys.all_objects", con))
        {
            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            SqlContext.Pipe.Send(reader);
        }
    }
}