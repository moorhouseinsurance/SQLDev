using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace TGSLLOBSchemeBuilder.Templates.XBrokerTemplate
{
    public static class Content
    {

        public static string PageDescription ="Please answer ALL the questions accurately, as incorrect information may invalidate your insurance should you take out a policy.";
        public static string PageDescriptionClaim = "Enter details for each claim or loss and click 'Add'. When all claims or losses have been added click 'Continue' to proceed.";

        public static class PI
        { 
        public static string AssumptionList = @"<assumptionList type = ""html"" >In order to keep the questions we need to ask to a minimum, we have made the following assumptions.Please take the time to read through these assumptions as they will form part of your insurance contract.
          <ol class=""assumptionsOL"">
         <li>
           No proposer, director or partner of the business or practice has ever been declared bankrupt/insolvent, or the subject of
           bankruptcy proceedings, or been the subject of a County Court Judgement(or the Scottish equivalent)
         </li>
         <li>
           No proprietor, proposer, director or partner of the business or practice has had a proposal refused or declined, had an
           insurance cancelled, or has had special terms imposed on an insurance
         </li>
         <li>
           No proprietor, proposer, director or partner of the business or practice has ever been convicted for any criminal offence
           involving dishonesty, arson, theft or wilful damage or for a breach of any statute relating to health and safety at work or has any
           prosecution pending or outstanding
         </li>
         <li>
           You do not work with silica, asbestos or substances containing asbestos nor do you work with acids, gases, explosives,
           radioactive or similar dangerous liquids or chemicals
         </li>
         <li>
           You do not work on power stations, nuclear installation or establishments, refineries, bulk storage or premises in oil, gas or
           chemical industries or offshore structures
         </li>
         <li>You do not work on aircraft, hovercraft, aerospace systems, watercraft, railways, underground or underwater</li>
         <li>You have no US or Canadian clients and at least 75% of the company’s income is from UK clients.</li>
       </ol>
       If you agree with all the assumptions above, please click ""Yes"" to continue. If you do not agree with any of the assumptions then click ""No"".
     </assumptionList>
";

            public static string PageStatementOfFact = @"<page id=""statementoffact"" name=""statementoffact.aspx"">
    <pageHeading type=""html""></pageHeading>
    <pageDescription type=""html""></pageDescription>
    <insuredName type=""label"" name=""lstrInsuredName"">
      <description></description>
    </insuredName>
    <business type=""label"" name=""lstrBusiness"">
      <description></description>
    </business>
    <clientName type=""label"" name=""lstrClientName"">
      <description></description>
    </clientName>
    <postalAddress type=""label"" name=""lstrPostalAddress"">
      <description></description>
    </postalAddress>
    <insurer type=""label"" name=""lstrInsurer"">
      <description></description>
    </insurer>
    <quoteReference type=""label"" name=""lstrQuoteReference"">
      <description></description>
    </quoteReference>
    <sofMainText type=""html"" name=""sofMainText""></sofMainText>
    <lobHeadingColumn1 type=""label"" name=""lstrLOBHeadingColumn1"">
      <description></description>
    </lobHeadingColumn1>
    <lobHeadingColumn2 type=""label"" name=""lstrLOBHeadingColumn2"">
      <description></description>
    </lobHeadingColumn2>
    <declarationText type=""html"" name=""declarationText"">
      <table>
        <tr>
          <td>
          <b>Assumptions</b>                        
          </td>
        </tr>
      </table>
      <br></br>
      <ol class=""assumptionsOL"">
        <li>
          No proposer, director or partner of the business or practice has ever been declared bankrupt/insolvent, or the subject of
          bankruptcy proceedings, or been the subject of a County Court Judgement (or the Scottish equivalent)
        </li>
        <li>
          No proprietor, proposer, director or partner of the business or practice has had a proposal refused or declined, had an
          insurance cancelled, or has had special terms imposed on an insurance
        </li>
        <li>
          No proprietor, proposer, director or partner of the business or practice has ever been convicted for any criminal offence
          involving dishonesty, arson, theft or wilful damage or for a breach of any statute relating to health and safety at work or has any
          prosecution pending or outstanding
        </li>
        <li>
          You do not work with silica, asbestos or substances containing asbestos nor do you work with acids, gases, explosives,
          radioactive or similar dangerous liquids or chemicals
        </li>
        <li>
          You do not work on power stations, nuclear installation or establishments, refineries, bulk storage or premises in oil, gas or
          chemical industries or offshore structures
        </li>
        <li>You do not work on aircraft, hovercraft, aerospace systems, watercraft, railways, underground or underwater </li>
        <li>You have no US or Canadian clients and at least 75% of the company’s income is from UK clients.</li>
      </ol>
    </declarationText>
    <dataProtectionText type=""html"" name=""dataProtectionText""></dataProtectionText>
  </page>
";

}
    }
}
