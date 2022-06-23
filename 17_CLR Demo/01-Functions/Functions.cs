using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [SqlFunction(
        Name = "SumDeterministic",
        IsDeterministic = true,
        IsPrecise = true)]
    public static int Add(int a1, int a2)
    {
        return a1 + a2;
    }

    [SqlFunction(
        IsDeterministic = false,
        IsPrecise = true)]
    public static int SumNondeterministic(int a1, int a2)
    {
        return a1 + a2;
    }

    [SqlFunction(DataAccess = DataAccessKind.Read)]
    public static int CountBiggerThen(int n)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
            "select count(*) from Table3 where [Col1] > @limit;", conn))
        {
            cmd.Parameters.AddWithValue("@limit", n);
            conn.Open();
            var count = (int)cmd.ExecuteScalar();
            return count;
        }
    }
}
