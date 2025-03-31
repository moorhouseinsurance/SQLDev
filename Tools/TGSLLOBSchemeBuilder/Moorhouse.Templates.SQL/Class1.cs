using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Moorhouse.Templates.SQL
{
    class tvfDispatcher
    {

        public static string functionBody = @"
    IF @SchemeTableID = {SchemeTableID} 
        SELECT * INTO @ReturnTable FROM [dbo].[{LOBName}_{Insurer}_{LineOfBusiness}_tvfCalculator]
(

)
";
    }
}

