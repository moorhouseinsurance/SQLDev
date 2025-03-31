using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using TGSLLOBSchemeBuilder.Templates;
using static TGSLLOBSchemeBuilder.Configuration;

namespace TGSLLOBSchemeBuilder
{
    public class WPDWriter
    {
        public QuestionSet QuestionSet { get; set; }
        public List<TGSLLOBSchemeBuilder.Form> processedForms = new List<Form>();

        public void Write()
        {
            if(QuestionSet == null)
            {
                QuestionSet = new QuestionSet();
                QuestionSet.Read();
            }

            StringBuilder stringBuilder = new StringBuilder();

            stringBuilder.Append(WpdTemplate.Header)
            .Append(BuildRiskFormXML("", QuestionSet))
            .Append(PremiumSections, LOBName, Insurer, LineOfBusiness)
            .Append(NumberOfDeclines, WpdTemplate.DeclineHeader, WpdTemplate.DeclineBody, WpdTemplate.DeclineFooter)
            .Append(NumberOfRefers, WpdTemplate.ReferHeader, WpdTemplate.ReferBody, WpdTemplate.ReferFooter)
            .Append(NumberOfProductDetails, "ProductDetail")
            .Append(NumberOfExcesses, "Excess")
            .Append(NumberOfSummarys, "Summary")
            .Append(NumberOfEndorsements, "Endorsements")
            .Append(NumberOfBreakdowns, "Breakdown")
            .AppendPremiumSections(PremiumSections)
            .Append(WpdTemplate.ReferralSection)
            .Append(WpdTemplate.Footer);

            if (ProjectLevels.Wpd == ProjectLevel.LOB)
            {
                stringBuilder.Replace("_{Insurer}_{LineOfBusiness}", "");
            }
            else
            {
                stringBuilder.Replace("{Insurer}", Insurer).Replace("{LineOfBusiness}", LineOfBusiness);
            }
            stringBuilder.Replace("{Insurer1}", Insurer1)
                .Replace("{LOBName}", LOBName)
                .Replace("{wpdFileName}", wpdFileName)
                .Replace("{Date}", DateTime.Now.ToLongDateString())
                .Replace("{Scheme Name}", SchemeName)
                .Replace("{SchemeName1}", SchemeName1)
                .Replace("{SchemeTableID}", SchemeTableID);

            try
            {
                System.IO.TextWriter writeFile = new StreamWriter((Test?Paths.Test :Paths.Scheme) + wpdFileName);
                writeFile.Write(stringBuilder);
                writeFile.Flush();
                writeFile.Close();
                writeFile = null;
            }
            catch (IOException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public StringBuilder BuildRiskFormXML(string tableName1 ,List<TGSLLOBSchemeBuilder.Form> forms)
        {
            StringBuilder stringBuilder = new StringBuilder();

            string fileName;
            string tableName;
            foreach (Form form in forms)
            {
                if (!processedForms.Contains(form))
                {
                    fileName = form.Filename.Replace("frm", "").Replace(".tst", "");
                    stringBuilder.AppendFormat("{{For Each}}UO_{0}_{1}{2}", LOBName ,fileName ,Environment.NewLine);
                    stringBuilder.Append(WpdTemplate.RiskXMLAdd.Replace("{ChildXML}", "{TypeString}<" + form.FormName + ">"));

                    tableName = tableName1 + string.Format(".UO_{0}_{1}", LOBName, fileName);
                    if (form.ChildScreens.Count != 0)
                    {
                        List<TGSLLOBSchemeBuilder.Form> ChildForms = QuestionSet.Where(frm => form.ChildScreens.Contains(LOBName + @"\" + frm.Filename)).ToList();
                        stringBuilder.Append(BuildRiskFormXML(tableName, ChildForms));
                    }

                    stringBuilder.Append(WpdTemplate.RiskXMLQuestionHeader);
                    foreach (Control control in form.ControlList)
                    {
                        string q = control.AnswerName;
                        string qh = string.Format(".UQ_{0}_{1}_", LOBName, fileName);
                        string s = WpdTemplate.RiskXMLQuestion.Replace("{TableName}", tableName).Replace("{Question}",q).Replace("{QualifiedQuestion}" , qh + q);
                        stringBuilder.Append(s);
                    }
                    stringBuilder.Append(WpdTemplate.RiskXMLQuestionFooter);

                    stringBuilder.Append(WpdTemplate.RiskXMLAdd.Replace("{ChildXML}", "{TypeString}</" + form.FormName + ">"));
                    stringBuilder.AppendFormat("{{End For}}{0}" ,Environment.NewLine);

                    processedForms.Add(form);
                }
            }
            return stringBuilder;
        }
    }
}
