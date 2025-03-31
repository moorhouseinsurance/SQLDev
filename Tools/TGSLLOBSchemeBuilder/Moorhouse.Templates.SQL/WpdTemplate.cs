using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TGSLLOBSchemeBuilder.Templates
{
    public static class WpdTemplate
    {
        public static string Header = @"{Header}Header
{SchemeName}{SchemeName1}
{Underwriter}{Insurer1}
{End Header}End Header

{Remark}*********************************************************************************************************************
{Remark}** =============================================
{Remark}** Author:      System Generated
{Remark}** Filename:    {wpdFileName}
{Remark}** Create date: {Date}
{Remark}** Version:     1.0
{Remark}** Description: {SchemeName1}
{Remark}** =============================================
{Remark}*********************************************************************************************************************

{Equation}Equation
{TypeWorkfield}SchemeTableID%
{Operator=}=
{TypeConstant}{SchemeTableID}
{End Equation}End Equation

{Equation}Equation
{TypeWorkfield}RiskXML$
{Operator=}=
{TypeString}
{End Equation}End Equation

{For Each}Client
		{For Each}Policy_Details
{Remark}*********************************************************************************************************************
{Remark}**** Calculator ***************************************************************************************************
{Remark}*********************************************************************************************************************

";
        public static string DeclineHeader = @"{Remark}***********************************************************************************************************
{Remark}**Declines*************************************************************************************************
{Remark}***********************************************************************************************************

	{If}If
	{Truth}Truth
	{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Decline?
	{Operator=}=
	{TypeBoolean}true
	{End Truth}End Truth
";

        public static string DeclineBody = @"
		{If}If
		{Truth}Truth
		{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Decline{Index}$
		{Operator<>}<>
		{TypeString}
		{End Truth}End Truth
			{Decline}Decline
			{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Decline{Index}$
			{End Decline}End Decline
		{End If}End If
";
        public static string DeclineFooter = @"
		{End Product}End Product
	{End If}End If

";

        public static string ReferHeader = @"{Remark}***********************************************************************************************************
{Remark}**Referrals ***********************************************************************************************
{Remark}***********************************************************************************************************

	{If}If
	{Truth}Truth
	{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Referral?
	{Operator=}=
	{TypeBoolean}true
	{End Truth}End Truth

";

        public static string ReferBody = @"		{If}If
		{Truth}Truth
		{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Refer{Index}$
		{Operator<>}<>
		{TypeString}
		{End Truth}End Truth
			{Refer}Refer
			{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.Refer{Index}$
			{End Refer}End Refer
		{End If}End If

";

        public static string ReferFooter = @"    {End If}End If

";


        public static string NarrationHeader = @"{Remark}***********************************************************************************************************
{Remark}**{NarrationType}******************************************************************************************
{Remark}***********************************************************************************************************

";

        public static string NarrationBody = @"	{If}If
	{Truth}Truth
	{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.{NarrationType}{Index}$
	{Operator<>}<>
	{TypeString}
	{End Truth}End Truth
		{Narrative}{AlternativeNarrationType}
		{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.{NarrationType}{Index}$
		{End Narrative}End Narrative
	{End If}End If

";

        public static string NarrationFooter = @"

";

        public static string PremiumSectionsHeader = @"{Remark}***********************************************************************************************************
{Remark}** PremiumSections Start ******************************************************************************************
{Remark}***********************************************************************************************************

";

        public static string PremiumSectionsBodySection = @"   	{Equation}Equation
	{TypeOutput}SECTION_{PolicySectionID}_NETPREMIUM%
	{Operator=}=
	{TypeVariable}Calculators.dbo.{LOBName}_{Insurer}_{LineOfBusiness}_uspCalculator.{PolicySectionID}%
	{End Equation}End Equation

";

        public static string PremiumCommPercentSection = "\t" + @"{If}If
	{Truth}Truth
	{TypeVariable}Calculators.dbo.{LOBName}_uspCalculator.{PolicySectionID}_{COMMPERCENT}COMMPERCENT%
	{Operator<>}<>
	{TypeConstant}0
	{End Truth}End Truth
		{Equation}Equation
		{TypeOutput}SECTION_{PolicySectionID}_{COMMPERCENT}COMMPERCENT%
		{Operator=}=		
		{TypeVariable}Calculators.dbo.{LOBName}_uspCalculator.{PolicySectionID}_{COMMPERCENT}COMMPERCENT%
		{End Equation}End Equation
	{End If}End If	

";

        public static string PremiumSectionsBodySumHeader = @"
    {Equation}Equation
    {TypeOutput}NetPremium%
    {Operator=}=
    {TypeOutput}SECTION_{PolicySectionID}_NETPREMIUM%
";
        public static string PremiumSectionsBodySumBody = @"    {Operator+}+
    {TypeOutput}SECTION_{PolicySectionID}_NETPREMIUM%
";
        public static string PremiumSectionsBodySumFooter = "\t"+@"{End Equation}End Equation

";
	
        public static string RiskXMLAdd= "\t" + @"{Equation}Equation
	{TypeWorkfield}RiskXML$
	{Operator=}=
	{TypeWorkfield}RiskXML$
	{Operator&}&
	{ChildXML}
	{End Equation}End Equation
";

        public static string RiskXMLQuestion = @"				{Operator&}&
				{TypeString}<{Question}>
				{Operator&}&
				{TypeQuestion}Client.Policy_Details{TableName}{QualifiedQuestion}
				{Operator&}&
				{TypeString}</{Question}>
";

        public static string RiskXMLQuestionHeader = @"	{Equation}Equation
	{TypeWorkfield}RiskXML$
	{Operator=}=
	{TypeWorkfield}RiskXML$
";

        public static string RiskXMLQuestionFooter = @"	{End Equation}End Equation
";


        public static string RiskTableCalculator = @"
	{ApplyTable}Table
	{TableNoInputs}7
	{TableName}Calculators.dbo.{LOBName}_uspCalculator
	{TableInput}RiskXML
	{Operator=}=
	{TypeWorkfield}RiskXML$
	{TableInput}PolicyStartDateTime
	{Operator=}=
	{TypeQuestion}Client.Policy_Details.Policy_Start_Date
	{TableInput}PolicyQuoteStage
	{Operator=}=
	{TypeQuestion}Client.Policy_Details.Pol_QuoteStage
	{TableInput}PostCode
	{Operator=}=
	{TypeQuestion}Client.Cli_fullpostcode
	{TableInput}SchemeTableID
	{Operator=}=
	{TypeWorkfield}SchemeTableID%
	{TableInput}AgentName
	{Operator=}=
	{TypeQuestion}Client.CLIAgentName
	{TableInput}SubAgentID
	{Operator=}=
	{TypeQuestion}Client.Policy_Details.SubAgentID
	{TableNoOutputs}{NumberOfPremiumSections}
	{TableOutput}Endorsements1$						
	{TableOutput}Referral?
	{TableOutput}Decline?
{RiskTableCalculatorPremiumSections}
    {End Table}End Table
	{Equation}Equation
	{TypeWorkfield}Referral?
	{Operator=}=
	{TypeVariable}Calculators.dbo.{LOBName}_uspCalculator.Referral?
	{End Equation}End Equation   
					
	{End For}End For
{End For}End For

";

        public static string RiskTableCalculatorOutput = "\t"+ @"{TableOutput}{OutputName}{Index}
";

        public static string ReferralSection = "\t" + @"{If}If
	{Truth}Truth
	{TypeWorkfield}Referral?
	{Operator=}=
	{TypeBoolean}true
	{End Truth}End Truth
		{Refer}Refer
		{TypeString}Please telephone insurer to obtain a Quote
		{End Refer}End Refer
	{End If}End If
";

        public static string Footer = @"
{Remark}***************************** - Moorhouse Product Scheme Template - ***********************
{End Product}End Product
";
    }
}
