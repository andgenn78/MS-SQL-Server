using System;
using System.Collections;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [SqlFunction(
        TableDefinition = "word nvarchar(max), length int",
        FillRowMethodName = "MakeTableRow")]
    public static IEnumerable Splitter(string str, string splitOn)
    {
        foreach (var word in str.Split(splitOn.ToCharArray(),
            StringSplitOptions.RemoveEmptyEntries))
        {
            yield return new WordInfo
            {
                Word = word,
                Length = word.Length
            };
        }
    }

    public static void MakeTableRow(object obj, out string word, out int length)
    {
        var wi = obj as WordInfo;
        word = wi.Word;
        length = wi.Length;
    }

    class WordInfo
    {
        public string Word { get; set; }
        public int Length { get; set; }
    }
}