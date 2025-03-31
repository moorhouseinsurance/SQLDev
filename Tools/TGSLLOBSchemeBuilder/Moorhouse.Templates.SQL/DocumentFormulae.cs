using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Moorhouse.Templates.SQL
{
    public static class DocumentFormulaeInsert
    {
        public static string CoverText = @"exec SP_DM_INSERT_FORMULA '{PremiumSection}CoverText','{PremiumSection}CoverText',' EXECUTESP ( ""UspPremiumCoverSelect"" , ""$cpdPolicyDetailsID_0_001001|$cpdHistoryID_0_001001|""{PremiumSection}""|""CoverText"""")'
";
        public static string CoverValue = @"exec SP_DM_INSERT_FORMULA '{PremiumSection}CoverValue','{PremiumSection}CoverValue',' EXECUTESP ( ""UspPremiumCoverSelect"" , ""$cpdPolicyDetailsID_0_001001|$cpdHistoryID_0_001001|""{PremiumSection}""|""CoverValue"""")'
";
        public static string Premium = @"exec SP_DM_INSERT_FORMULA '{PremiumSection}Premium','{PremiumSection}Premium',' EXECUTESP ( ""UspPremiumCoverSelect"" , ""$cpdPolicyDetailsID_0_001001|$cpdHistoryID_0_001001|""{PremiumSection}""|""Premium"""")'
";
    }
}
