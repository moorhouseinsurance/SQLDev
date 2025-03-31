using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using Moorhouse.XML;
using static TGSLLOBSchemeBuilder.Configuration;
using TGSLLOBSchemeBuilder.Templates.XBrokerTemplate;

namespace TGSLLOBSchemeBuilder
{
    class XBrokerWriter
    {
        public XmlDocument ContentXML { get; set; }
        public QuestionSet QuestionSet { get; set; }

        private StringBuilder stringBuilder = new StringBuilder();

        public void Write()
        {
            if (QuestionSet == null)
            {
                QuestionSet = new QuestionSet();
                QuestionSet.Read();
            }
            WriteContent();

        }

        private void WriteContent()
        {
            ContentXML = new XmlDocument();
            ContentXML.PreserveWhitespace = true;
            ContentXML.Load(Paths.LOBWebsiteContent);
            string xpath;

            xpath = string.Format(@"//page[@id='assumptions']");
            ContentXML.SetXmlNodeString(xpath, "assumptionList" , Content.PI.AssumptionList);
            foreach (Form form in QuestionSet)
            {
                xpath = string.Format(@"//page[@id='{0}']/pageDescription", form.FormName.ToLower());
                ContentXML.SetXmlElementString(xpath, form.FormName == "clmdtail" ? Content.PageDescriptionClaim : Content.PageDescription);
                
                foreach (Control control in form.ControlList)
                {
                    xpath = string.Format(@"//page[@id='{0}']/{1}/description", form.FormName.ToLower(), control.AnswerName);
                    ContentXML.SetXmlElementString(xpath, control.Text);
                }
            }
            ContentXML.AppendChildFromString("screenContent" ,"page", Content.PI.PageStatementOfFact);
            ContentXML.Save(Paths.LOBWebsiteContent);
        }
    }
}
