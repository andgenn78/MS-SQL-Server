using System.Data.SqlTypes;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public class Demo
{
    public static int Multiply(int num1, int num2)
    {
        return num1 * num2;
    }

    public static void GetCustomer(SqlInt32 customerId)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        {
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandText = @"SELECT * FROM Sales.Customers
                                WHERE CustomerID = @CustomerID";
            cmd.Parameters.AddWithValue("@CustomerID", customerId);
            conn.Open();

            SqlContext.Pipe.ExecuteAndSend(cmd);
        }
    }
}