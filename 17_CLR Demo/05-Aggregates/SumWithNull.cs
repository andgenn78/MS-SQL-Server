using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[SqlUserDefinedAggregate(Format.Native)]
public struct SumWithNull
{
    private SqlInt32 _sum;

    public void Init()
    {
        _sum = new SqlInt32(0);
    }

    public void Accumulate(SqlInt32 value)
    {
        _sum += value;
    }

    public void Merge(SumWithNull group)
    {
        _sum += group._sum;
    }

    public SqlInt32 Terminate()
    {
        return _sum;
    }
}