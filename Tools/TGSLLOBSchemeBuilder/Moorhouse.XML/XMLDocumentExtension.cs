using System.Xml;
using System;

namespace Moorhouse.XML
{
    public static class XMLDocumentExtension
    {
        public static string GetXmlElementString(this XmlNode xmlNodeCurrent, string Path)
        {
            XmlNode xmlNode = xmlNodeCurrent.SelectSingleNode(Path);
            return xmlNode == null ? "" : xmlNode.InnerText;
        }

        public static void SetXmlElementString(this XmlNode xmlNodeCurrent, string Path, string Value)
        {
            XmlNode xmlNode = xmlNodeCurrent.SelectSingleNode(Path);
            if (xmlNode != null)
            {
                xmlNode.InnerText = Value;
            }
        }
        public static void SetXmlNodeString(this XmlDocument xmlDocument, string Path, string ElementName, string Value)
        {
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.LoadXml(Value);
  
            XmlElement xmlNewElement = xmlDocument.CreateElement(ElementName);

            xmlNewElement.InnerXml = doc.InnerXml;
            XmlNode xmlNode = xmlDocument.SelectSingleNode(Path);
            xmlNode.ReplaceChild(xmlNewElement.FirstChild, xmlNode.SelectSingleNode(ElementName));

        }

        public static void AppendChildFromString(this XmlDocument xmlDocument, string Path, string ElementName, string Value)
        {
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            doc.LoadXml(Value);
            XmlElement xmlNewElement = xmlDocument.CreateElement(ElementName);
            xmlNewElement.InnerXml = doc.OuterXml;
            xmlDocument.SelectSingleNode(Path).AppendChild(xmlNewElement.FirstChild);
        }

        public static void AppendChildrenFromString(this XmlDocument xmlDocument, string Path, string Value)
        {
            XmlDocumentFragment xfrag = xmlDocument.CreateDocumentFragment();
            xfrag.InnerXml = Value;

            XmlNode xmlNode = xmlDocument.SelectSingleNode(@"./a:breakdowns");
            xmlNode.AppendChild(xfrag);
        }

        public static decimal getxmlElementSumDecimal(this XmlNode xmlNodeCurrent, string Path, XmlNamespaceManager nsmgr)
        {
            double sum = 0;
            XmlNodeList xmlNodeList = xmlNodeCurrent.SelectNodes(Path, nsmgr);
            if (xmlNodeList != null)
            {
                foreach (XmlNode xn in xmlNodeList)
                {
                    sum += Convert.ToDouble(xn.InnerText.Trim());
                }
            }
            return Convert.ToDecimal(sum);
        }

        public static string getxmlNodeOuterXMLString(this XmlNode xmlNodeCurrent, string Path)
        {
            XmlNode xmlNode = xmlNodeCurrent.SelectSingleNode(Path);
            return xmlNode == null ? "" : xmlNode.OuterXml;
        }


    }
}
