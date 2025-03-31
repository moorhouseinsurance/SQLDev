using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TGSLLOBSchemeBuilder.Templates;
using static TGSLLOBSchemeBuilder.Configuration;


namespace TGSLLOBSchemeBuilder
{
    public static class StringExtension
    {
        public static string RemoveFrom(this StringBuilder sb, string from)
        {
            string s = sb.ToString();
            return s.RemoveFrom(from);
        }
        public static string RemoveFrom(this String s, string from)
        {
            int index = s.LastIndexOf(from);
            return s.Remove(index, s.Length - index);
        }

        public static string RemoveFirst(this StringBuilder sb, string remove)
        {
            string s = sb.ToString();
            return s.RemoveFirst(remove);
        }

        public static string RemoveFirst(this String s, string remove)
        {
            int index = s.IndexOf(remove);
            return s.Remove(index, remove.Length);
        }

        public static StringBuilder Append(this StringBuilder stringBuilder, List<string> PremiumSections, string LOBName, string Insurer, string LineOfBusiness)
        {

            int totalPremiumSections = NumberOfDeclines
            + NumberOfRefers
            + NumberOfProductDetails
            + NumberOfExcesses
            + NumberOfSummarys
            + NumberOfBreakdowns
            + (NumberOfPremiums) * 4
            + 3;

            StringBuilder sb = new StringBuilder();
            sb.CalculatorOutputAppend(NumberOfDeclines, "Decline", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfRefers, "Refer", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfProductDetails, "ProductDetail", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfBreakdowns, "Breakdown", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfExcesses, "Excess", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfSummarys, "Summary", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfPremiums, "PREM", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfPremiums, "PREM_PARTNERCOMMPERCENT", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfPremiums, "PREM_AGENTCOMMPERCENT", WpdTemplate.RiskTableCalculatorOutput)
            .CalculatorOutputAppend(NumberOfPremiums, "PREM_SUBAGENTCOMMPERCENT", WpdTemplate.RiskTableCalculatorOutput);

            return stringBuilder.Append(WpdTemplate.RiskTableCalculator
                .Replace("{NumberOfPremiumSections}", totalPremiumSections.ToString())
                .Replace("{RiskTableCalculatorPremiumSections}", sb.ToString()));
        }

        public static StringBuilder CalculatorOutputAppend(this StringBuilder stringBuilder, int NumberOfUnits, string OutputName, string outputFormat)
        {
            for (int index = 1; index <= NumberOfUnits; index++)
            {
                if (OutputName.StartsWith("PREM"))
                {
                    if (index <= Configuration.PremiumSections.Count())
                    { 
                        stringBuilder.Append(outputFormat.Replace("{OutputName}",OutputName).Replace("PREM", Configuration.PremiumSections[index - 1]).Replace("{Index}", "%"));
                    }
                    else
                    {
                        stringBuilder.Append(outputFormat.Replace("{OutputName}", OutputName).Replace("{Index}","%").Replace("PREM" ,"PREM"+index.ToString()));
                    }
                }
                else
                {
                    stringBuilder.Append(outputFormat.Replace("{OutputName}", OutputName).Replace("{Index}", index.ToString()+"$"));
                }
            }
            return stringBuilder;
        }

        public static StringBuilder Append(this StringBuilder stringBuilder, int NumberOfUnits, string header, string body, string footer)
        {
            stringBuilder.Append(header);

            for (int index = 1; index <= NumberOfUnits; index++)
            {
                stringBuilder.Append(body.Replace("{Index}", index.ToString()));
            }
            return stringBuilder.Append(footer);
        }

        public static StringBuilder Append(this StringBuilder stringBuilder, int NumberOfUnits, string NarrationType)
        {
            stringBuilder.Append(WpdTemplate.NarrationHeader);
            string AlternativeNarrationType = NarrationType;
            if (NarrationType == "Excess" || NarrationType == "ProductDetail") AlternativeNarrationType = "Product Details";
            for (int index = 1; index <= NumberOfUnits; index++)
            {
                stringBuilder.Append(WpdTemplate.NarrationBody.Replace("{Index}", index.ToString()));
            }
            return stringBuilder.Append(WpdTemplate.NarrationFooter).Replace("{NarrationType}", NarrationType).Replace("{AlternativeNarrationType}", AlternativeNarrationType);
        }

        public static StringBuilder AppendPremiumSections(this StringBuilder stringBuilder, List<string> PremiumSections)
        {
            StringBuilder sbPremiums = new StringBuilder();
            StringBuilder sbPremiumsTotal = new StringBuilder();
            StringBuilder sbCommissionsPartner = new StringBuilder();
            StringBuilder sbCommissionsAgent = new StringBuilder();
            StringBuilder sbCommissionsSubAgent = new StringBuilder();

            stringBuilder.Append(WpdTemplate.PremiumSectionsHeader);

            int i = 0;
            foreach (string PolicySectionID in PremiumSections)
            {
                i++;
                if (i == 1)
                {
                    sbPremiumsTotal.Append(WpdTemplate.PremiumSectionsBodySumHeader.Replace("{PolicySectionID}", PolicySectionID));
                }
                else
                { sbPremiumsTotal.Append(WpdTemplate.PremiumSectionsBodySumBody.Replace("{PolicySectionID}", PolicySectionID)); }

                sbPremiums.Append(WpdTemplate.PremiumSectionsBodySection.Replace("{PolicySectionID}", PolicySectionID));
                sbCommissionsPartner.Append(WpdTemplate.PremiumCommPercentSection.Replace("{PolicySectionID}", PolicySectionID).Replace("{COMMPERCENT}","PARTNER"));
                sbCommissionsAgent.Append(WpdTemplate.PremiumCommPercentSection.Replace("{PolicySectionID}", PolicySectionID).Replace("{COMMPERCENT}", "AGENT"));
                sbCommissionsSubAgent.Append(WpdTemplate.PremiumCommPercentSection.Replace("{PolicySectionID}", PolicySectionID).Replace("{COMMPERCENT}", "SUBAGENT"));
            }
            
            stringBuilder.Append(sbPremiums)
                .Append(sbCommissionsPartner)
                .Append(sbCommissionsAgent)
                .Append(sbCommissionsSubAgent)
                .Append(sbPremiumsTotal)
                .Append(WpdTemplate.PremiumSectionsBodySumFooter);

            return stringBuilder;
        }

        public static T ToEnum<T>(this string value)
        {
            return (T)Enum.Parse(typeof(T), value, true);
        }
    }
}
