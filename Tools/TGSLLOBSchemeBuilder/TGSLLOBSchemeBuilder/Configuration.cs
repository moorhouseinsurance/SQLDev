using System;
using System.Collections.Generic;
using System.Configuration;

namespace TGSLLOBSchemeBuilder
{
    public static class Configuration
    {
        public static class Paths
        {
            public static string ProjectRoot { get { return  ConfigurationManager.AppSettings["ProjectRootPath"]; } }
            public static string LOB { get { return ProjectRoot + LOBName + @"\"; } }
            public static string LOBSQL { get { return LOB + @"Schemes\SQL\"; } }
            public static string LOBWebsite { get { return LOB + @"Website\"; } }
            public static string LOBWebsiteContent { get { return string.Format( @"{0}Content\{1}_content.xml", LOBWebsite, LOBName); } }
            public static string Scheme { get { return LOB + @"Schemes\" + Insurer1  +" - " + LineOfBusiness1 + @"\"; } }
            public static string SchemeSQL { get { return Scheme + @"SQL\"; } }
            public static string Test { get { return ConfigurationManager.AppSettings["TestPath"]; } }
        }
        public static class Execute
        {
            public static bool CAQ { get { return bool.Parse(ConfigurationManager.AppSettings["ExecuteCAQ"]); } }
            public static bool WPD { get { return bool.Parse(ConfigurationManager.AppSettings["ExecuteWPD"]); } }
            public static bool Calculator { get { return bool.Parse(ConfigurationManager.AppSettings["ExecuteCalculator"]); } }
            public static bool XBroker { get { return bool.Parse(ConfigurationManager.AppSettings["ExecuteXBroker"]); } }
        }
        public static class QuestionSetBuilder
        {
            public static bool LabelDescPrefixed { get { return bool.Parse(ConfigurationManager.AppSettings["QuestionSetBuilder.LabelDescriptionControlPrefixed"]); } }
        }

        public static class ProjectLevels
        {
            public static ProjectLevel Assumptions { get {return ConfigurationManager.AppSettings["ProjectLevelAssumptions"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Claims { get { return ConfigurationManager.AppSettings["ProjectLevelClaims"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Limits { get { return ConfigurationManager.AppSettings["ProjectLevelLimits"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel LoadDiscounts { get { return ConfigurationManager.AppSettings["ProjectLevelLoadDiscounts"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Rates { get { return ConfigurationManager.AppSettings["ProjectLevelRates"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Synonyms { get { return ConfigurationManager.AppSettings["ProjectLevelSynonyms"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Calculator { get { return ConfigurationManager.AppSettings["ProjectLevelCalculator"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel AddScheme { get { return ConfigurationManager.AppSettings["ProjectLevelAddScheme"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Endorsements { get { return ConfigurationManager.AppSettings["ProjectLevelEndorsements"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Trades { get { return ConfigurationManager.AppSettings["ProjectLevelTrades"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Excesses { get { return ConfigurationManager.AppSettings["ProjectLevelExcesses"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel RiskBordereaux { get { return ConfigurationManager.AppSettings["ProjectLevelRiskBordereaux"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel Wpd { get { return ConfigurationManager.AppSettings["ProjectLevelWpd"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel RiskTableTypes { get { return ConfigurationManager.AppSettings["ProjectLevelRiskTableTypes"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel SchemeDispatcher { get { return ConfigurationManager.AppSettings["ProjectLevelSchemeDispatcher"].ToEnum<ProjectLevel>(); } }
            public static ProjectLevel DocumentFormulae { get { return ConfigurationManager.AppSettings["ProjectLevelDocumentFormulae"].ToEnum<ProjectLevel>(); } }            
        }
        public static List<string> CAQLOBSections { get { return new List<string>(ConfigurationManager.AppSettings["CAQLOBSections"] == "" ? new string[] { } :ConfigurationManager.AppSettings["CAQLOBSections"].Split(',')) ; } }
        public static string CAQLOBSectionsString { get { return ConfigurationManager.AppSettings["CAQLOBSections"]; } }
        public static List<string> CAQLOBQuestions { get { return new List<string>(ConfigurationManager.AppSettings["CAQLOBQuestions"] == "" ? new string[] { } : ConfigurationManager.AppSettings["CAQLOBQuestions"].Split(',')); } }
        public static string CAQLOBQuestionsString { get { return ConfigurationManager.AppSettings["CAQLOBQuestions"]; } }
        public static int CAQLOBQuestionSetIDOverride { get { return int.Parse(ConfigurationManager.AppSettings["CAQLOBQuestionSetIDOverride"]); } }
        public static int CAQLOBGroupIDOverride { get { return int.Parse(ConfigurationManager.AppSettings["CAQLOBGroupIDOverride"]); } }
        public static string System { get { return ConfigurationManager.AppSettings["System"]; } }
        //public static string ProductDatabase { get { return System == "UAT" ? (ConfigurationManager.ConnectionStrings["ProductUAT"].ToString()) : (ConfigurationManager.ConnectionStrings["ProductDev"].ToString()); } }
        //public static string ProductDatabase { get { return System == "LIVE" ? (ConfigurationManager.ConnectionStrings["ProductLive"].ToString()) : (ConfigurationManager.ConnectionStrings["ProductDev"].ToString()); } }
        public static string ProductDatabase
        {
            get
            {
                if (System == "UAT")
                {
                    return ConfigurationManager.ConnectionStrings["ProductUAT"].ToString();
                }
                if (System == "DEV")
                {
                    return ConfigurationManager.ConnectionStrings["ProductDev"].ToString();
                }
                if (System == "LIVE")
                {
                    return (ConfigurationManager.ConnectionStrings["ProductLive"].ToString());
                }
                else
                {
                    return null;
                }
            }
        }
        public static bool Test { get { return bool.Parse(ConfigurationManager.AppSettings["Test"]); } }
        public static string Insurer1 { get { return ConfigurationManager.AppSettings["Insurer"]; } }
        public static string Insurer { get { return Insurer1.Replace(" ", ""); } }
        public static string SchemeInsurerName { get { return ConfigurationManager.AppSettings["SchemeInsurerName"]; } }
        public static string LOBName { get { return ConfigurationManager.AppSettings["LOBName"]; } }
        public static string LineOfBusiness1 { get { return ConfigurationManager.AppSettings["LineOfBusiness"]; } }
        public static string LineOfBusiness { get { return LineOfBusiness1.Replace(" ", ""); } }
        public static string SchemeName1 { get { return (SchemeInsurerName == "" ? Insurer : SchemeInsurerName) + " - " + LineOfBusiness1; } }
        public static string SchemeName { get { return (SchemeInsurerName == "" ? Insurer : SchemeInsurerName) + " - " + LineOfBusiness; } }      
        public static string wpdFileName { get { return ConfigurationManager.AppSettings["wpdFileName"]; } }
        public static List<string> PremiumSections { get { return new List<string>(ConfigurationManager.AppSettings["PremiumSections"].Split(',')); ; } }
        public static int NumberOfDeclines { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfDeclines"]); } }
        public static int NumberOfRefers { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfRefers"]); } }
        public static int NumberOfProductDetails { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfProductDetails"]); } }
        public static int NumberOfExcesses { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfExcesses"]); } }
        public static int NumberOfSummarys { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfSummarys"]); } }
        public static int NumberOfEndorsements { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfEndorsements"]); } }
        public static int NumberOfBreakdowns { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfBreakdowns"]); } }
        public static int NumberOfPremiums { get { return int.Parse(ConfigurationManager.AppSettings["NumberOfPremiums"]); } }        
        public static DateTime RateStartDateTime { get { return DateTime.Parse(ConfigurationManager.AppSettings["RateStartDateTime"]); } }
        public static string InsurerID { get { return ConfigurationManager.AppSettings["InsurerID"]; } }
        public static string CommissionPercent { get { return ConfigurationManager.AppSettings["CommissionPercent"]; } }
        public static string RangePrefix { get { return ConfigurationManager.AppSettings["RangePrefix"]; } }
        public static string SchemeTableID { get { return ConfigurationManager.AppSettings["SchemeTableID"]; } }
        public static string SchemeLinkAgents { get { return ConfigurationManager.AppSettings["SchemeLinkAgents"]; } }
        public static string InternetAvailable { get { return ConfigurationManager.AppSettings["InternetAvailable"]; } }
        public static bool RealTimePricingApplies { get { return bool.Parse(ConfigurationManager.AppSettings["RealTimePricingApplies"]); } }
    }
}
