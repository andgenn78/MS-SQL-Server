using System;
using System.Data.SqlTypes;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.SqlServer.Server;

/*
SqlUserDefinedType:

* Format - обязательный, определяет метод сериализации,
    UserDefined - IBinarySerialize, 
    Native - только для struct с "простыми" полями 

* IsByteOrdered - по умолчанию true

* IsFixedLength - по умолчанию false

* MaxByteSize - макс.размер, которого может достигать тип:
    -1 - неограничен(2ГБ, с SQL Server 2008)
    1  - 8000
*/

[Serializable]
[SqlUserDefinedType(
    Format.UserDefined,
    IsByteOrdered = true,
    IsFixedLength = false,
    MaxByteSize = 11)]
public struct PhoneNumber : INullable, IBinarySerialize
{
    private string _number;

    public SqlString Number
    {
        get
        {
            return new SqlString(_number);
        }

        set
        {
            if (value == null)
            {
                _number = string.Empty;
                return;
            }

            string str = (string)value;

            if (Regex.IsMatch(str, "[0-9]{10}"))
            {
                _number = str;
            }
            else
            {
                throw new ArgumentException("Phone numbers must be 10 digits.");
            }
        }
    }

    public override string ToString()
    {
        return _number;
    }

    public string ToFormattedString()
    {
        return string.Format(
            "{0} {1}-{2}-{3}",
            _number.Substring(0, 3),
            _number.Substring(3, 3),
            _number.Substring(6, 2),
            _number.Substring(8, 2));
    }

    public bool IsNull
    {
        get { return string.IsNullOrEmpty(_number); }
    }

    public static PhoneNumber Null
    {
        get
        {
            PhoneNumber n = new PhoneNumber();
            n._number = string.Empty;
            return n;
        }
    }

    public static PhoneNumber Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;

        PhoneNumber n = new PhoneNumber();
        n.Number = s;

        return n;
    }

    public void Read(BinaryReader r)
    {
        _number = r.ReadString();
    }

    public void Write(BinaryWriter w)
    {
        w.Write(_number);
    }
}