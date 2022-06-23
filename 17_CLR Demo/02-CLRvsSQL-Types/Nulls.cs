using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [SqlFunction]
    public static int IntAdd(int n1, int n2)
    {
        return n1 + n2;
    }

    [SqlFunction]
    public static SqlInt32 IntAdd2(SqlInt32 n1, SqlInt32 n2)
    {
        if (n1.IsNull)
        {
            n1 = 0;
        }

        return n1 + n2;
    }

    [SqlFunction]
    public static SqlInt32 NullIfZero(SqlInt32 num)
    {
        if (num == 0)
        {
            return SqlInt32.Null;
        }

        return num;
    }

    [SqlFunction]
    public static SqlString Hello(SqlString name)
    {
        return new SqlString("Hello ") + name;
    }

    [SqlFunction]
    [return: SqlFacet(MaxSize = -1)]
    public static SqlString LongHello1(
        [SqlFacet(MaxSize = -1)] SqlString name)
    {
        return new SqlString("Hello ") + name;
    }

    [SqlFunction]
    public static SqlInt32 IntMax(SqlInt32 n1, SqlInt32 n2)
    {
        var max = Math.Max(n1.Value, (long)n2);
        return (int)max;
    }
}
