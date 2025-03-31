using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

using static TGSLLOBSchemeBuilder.Configuration;

namespace TGSLLOBSchemeBuilder
{
    public class QuestionSet : List<Form>
    {
        public XmlDocument ProjectTPJXML { get; set; }
        public XmlDocument ProjectFormXML { get; set; }
        public string ProjectName { get; set; }
        public int ProductTypeID { get; set; }
        public string FilePathFormat { get; set; }
        private XmlNode xmlNode;
        public List<Form> FormList { get; set; }
        public string QuestionSetName { get; set; }

        private List<EnableControl> DisableControlList { get; set; }

        public QuestionSet()
        {
            FilePathFormat = Paths.LOB + @"{0}{1}";
            this.ProjectName = LOBName;
        }
        private string getxmlElementString(XmlNode xmlNodeCurrent, string Path)
        {
            xmlNode = xmlNodeCurrent.SelectSingleNode(Path);
            return xmlNode == null ? "" : xmlNode.InnerText; ;
        }

        public void Read()
        {
            this.ProjectTPJXML = new XmlDocument();
            this.ProjectFormXML = new XmlDocument();
            string filePath = string.Format(FilePathFormat, ProjectName, ".tpj");
            this.ProjectTPJXML.Load(filePath);
            QuestionSetName = getxmlElementString(this.ProjectTPJXML, "project/description");
            ProductTypeID = int.Parse(getxmlElementString(this.ProjectTPJXML, "project/@iD"));

            XmlNodeList xmlNodeList = this.ProjectTPJXML.SelectNodes("project/forms/form");
            List<TableAlias> ListTableAliass = new List<TableAlias>();

            foreach (XmlNode formNode in xmlNodeList)
            {
                Form form = new Form();
                form.Filename = getxmlElementString(formNode, "filename");
                form.ShowOnWebsite = bool.Parse(getxmlElementString(formNode, "showOnWebsite"));
                form.Description = getxmlElementString(formNode, "description");
                form.ScreenOrder = getxmlElementString(formNode, "screenOrder");
                form.Instance = getxmlElementString(formNode, "@instance");
                form.AnswerTable = getxmlElementString(formNode, "readSP").Replace("_READ", "");
                form.FormName = form.Filename.Replace("frm", "").Replace(".tst", "");
                this.Add(form);
            }

            DisableControlList = new List<EnableControl>();

            foreach (Form form in this)
            {
                filePath = string.Format(FilePathFormat, form.Filename, "");
                this.ProjectFormXML.Load(filePath);

                XmlNodeList xmlControlListViewNodeList = this.ProjectFormXML.SelectNodes("//control[@type = 'WisListView']/boundScreen");
                form.ChildScreens = new List<String>();
                foreach (XmlNode Node in xmlControlListViewNodeList)
                {
                    form.ChildScreens.Add(Node.InnerText);
                }
                XmlNodeList xmlControlNodeList = this.ProjectFormXML.SelectNodes("//control[@type = 'tgsYesNo' or @type = 'WisCheckBox' or @type = 'WisTextBox' or @type = 'tgsCurrencyField' or @type = 'WisComboBox' or @type = 'wisDatePicker' or @type = 'WisMaskedBox'] ");

                form.ControlList = new List<Control>();
                foreach (XmlNode controlNode in xmlControlNodeList)
                {
                    Control control = new Control();
                    control.Name = getxmlElementString(controlNode, "@name");
                    control.AnswerName = control.Name.Remove(0, 3);
                    control.Type = getxmlElementString(controlNode, "@type");
                    control.TabIndex = getxmlElementString(controlNode, "tabIndex");
                    control.Required = getxmlElementString(controlNode, "required");
                    control.Enabled = getxmlElementString(controlNode, "enabled");
                    control.DefaultValue = getxmlElementString(controlNode, "defaultValue");
                    control.ListTableName = getxmlElementString(controlNode, "listTable");
                    control.ListColumnName = getxmlElementString(controlNode, "columnName");
                    control.Description = getxmlElementString(controlNode, "description");
                    control.Text = GetText(controlNode, control);
                    control.HelpText = getxmlElementString(controlNode, "helpText");
                    control.Numeric = getxmlElementString(controlNode, "numeric");
                    control.DecimalPlaces = getxmlElementString(controlNode, "decimalPlaces");
                    control.UseDecimalPlaces = getxmlElementString(controlNode, "useDecimalPlaces");
                    control.MaximumTotal = getxmlElementString(controlNode, "maximumTotal");
                    control.MinimumTotal = getxmlElementString(controlNode, "minimumTotal");
                    control.MaxLength = getxmlElementString(controlNode, "maxLength");
                    control.MultiLine = getxmlElementString(controlNode, "multiLine");
                    control.StartYear = getxmlElementString(controlNode, "startYear");
                    control.EndYear = getxmlElementString(controlNode, "endYear");
                    control.Visible = bool.Parse(getxmlElementString(controlNode, "alwaysVisible"));
                    control.DisplayOnWebpage = bool.Parse(getxmlElementString(controlNode, "displayOnWebpage"));

                    control.AnswerColumnName = control.Type == "WisComboBox" ? control.AnswerName + "_ID" : control.AnswerName;
                    control.GetAnswerTypeID();
                    control.GetDatabaseColumnType();
                    control.DisplayPage = GetDisplayPage(controlNode, form);
                    control.DecodeListTableName();
                    control.EnableControlList = new List<EnableControl>();

                    XmlNodeList xmlEnableControlNodeList = controlNode.SelectNodes(".//enableControl");
                    foreach (XmlNode enableControlNode in xmlEnableControlNodeList)
                    {
                        EnableControl enableControl = new EnableControl();
                        enableControl.BoundScreen = getxmlElementString(enableControlNode, "boundScreen").Replace(this.ProjectName + @"\", "");
                        enableControl.BoundScreenControl = getxmlElementString(enableControlNode, "control");
                        enableControl.Enable = getxmlElementString(enableControlNode, "enable");
                        //Criteria
                        enableControl.Symbol = getxmlElementString(enableControlNode, "symbol");
                        enableControl.Threshold = getxmlElementString(enableControlNode, "threshold");
                        enableControl.GetOperator(control.AnswerTypeID);
                        enableControl.ListValueList = new List<string>();
                        XmlNodeList xmlEnableControlListValueNodeList = enableControlNode.SelectNodes(".//listValue");
                        foreach (XmlNode listValueNode in xmlEnableControlListValueNodeList)
                        {
                            string listValue = getxmlElementString(listValueNode, ".");
                            enableControl.ListValueList.Add(listValue);
                        }
                        control.EnableControlList.Add(enableControl);
                        DisableControlList.Add(enableControl);
                    }
                    if (control.ListTableName != null)
                    {
                        ListTableAliass.Add(new TableAlias { TableName = control.ListTableName });
                        //    TableAlias tA = ListTableAliass.FindLast(x => x.TableName == control.ListTableName);
                        int index = ListTableAliass.Count(x => x.TableName == control.ListTableName);
                        control.ListTableAlias = string.Format("{0}{1}", control.ListTableName, index);
                    }
                    form.ControlList.Add(control);
                }
            }

            Control disableControl;
            foreach (EnableControl enableControl in DisableControlList)
            {
                disableControl = this.Where(frm => frm.Filename == enableControl.BoundScreen).SelectMany(frm => frm.ControlList).SingleOrDefault(cont => cont.Name == enableControl.BoundScreenControl);
                if (disableControl != null)
                {
                    disableControl.Enabled = "False";
                    //  disableControl.Visible = true;
                }
            }

            IEnumerator<Form> formListEnumerator = this.Where(frm => frm.ShowOnWebsite == true).GetEnumerator();
            while (formListEnumerator.MoveNext())
            {
                Form form = formListEnumerator.Current;
                form.ParentControl = this.SelectMany(frm => frm.ControlList).OrderByDescending(cont => cont.TabIndex).FirstOrDefault(cont => cont.DisplayPage == form.Filename);
            }
            
        }

        private string GetText(XmlNode controlNode, Control control)
        {
            if (control.Type == "WisCheckBox")
            {
                return getxmlElementString(controlNode, "text");
            }
            string controlText = control.Name;
            if (!Configuration.QuestionSetBuilder.LabelDescPrefixed)
            {
                controlText = controlText.Remove(0, 3);
            }
            return getxmlElementString(ProjectFormXML, string.Format(@"//control[@type = 'WisLabel' and description='{0}']/text", controlText));
        }

        private string GetDisplayPage(XmlNode controlNode, Form form)
        {
            string boundScreen = getxmlElementString(controlNode, "enableControls/enableControl/boundScreen[1]");
            if (boundScreen.Contains("\\") && !boundScreen.Contains(form.Filename))
            {
                return boundScreen.Split('\\')[1];
            }
            return getxmlElementString(controlNode, "displayPages/displayPage/pageName");
        }

        private class TableAlias
        {
            public string TableName;
            public int AliasID;
        }
    }


    public class Form
    {
        public string Filename { get; set; }
        public string Description { get; set; }
        public string ScreenOrder { get; set; }
        public string Instance { get; set; }
        public string AnswerTable { get; set; }
        public List<Control> ControlList { get; set; }
        public List<string> ChildScreens { get; set; }
        public string FormName { get; set; }
        public bool ShowOnWebsite { get; set; }
        public Control ParentControl { get; set; }
    }

    public class Control
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public bool DisplayOnWebpage { get; set; }
        public string AnswerColumnName { get; set; }
        public string AnswerName { get; set; }
        public string Type { get; set; }
        public string TabIndex { get; set; }
        public string Text { get; set; }
        public string Required { get; set; }
        public string Enabled { get; set; }
        public string ListTableName { get; set; }
        public string ListTableAlias { get; set; }
        public string ListColumnName { get; set; }
        public string HelpText { get; set; }
        public string DefaultValue { get; set; }
        public bool Visible { get; set; }

        public string Numeric { get; set; }
        public string DecimalPlaces { get; set; }
        public string UseDecimalPlaces { get; set; }

        public string MaximumTotal { get; set; }
        public string MinimumTotal { get; set; }
        public string MaxLength { get; set; }
        public string MultiLine { get; set; }
        public string StartYear { get; set; }
        public string EndYear { get; set; }
        public string DisplayPage { get; set; }
        public List<EnableControl> EnableControlList { get; set; }

        public long? QuestionID { get; set; }
        public long AnswerTypeID { get; set; }
        public string DatabaseColumnType { get; set; }
        public long? EnablementCriteriaSetID { get; set; }
        public long? ParentQuestionID { get; set; }

        public void GetAnswerTypeID() //Only coded base types to start with
        {
            this.AnswerTypeID = 0;
            switch (this.Type)
            {
                case "tgsYesNo":
                case "WisCheckBox":
                    this.AnswerTypeID = 4;
                    break;
                case "WisTextBox":
                    this.AnswerTypeID = this.Numeric.ToLower() == "true" ? 5 : 3;
                    break;
                case "tgsCurrencyField":
                    this.AnswerTypeID = 5;
                    break;
                case "WisComboBox":
                    this.AnswerTypeID = 1;
                    break;
                case "wisDatePicker":
                case "WisMaskedBox":
                    this.AnswerTypeID = 2;
                    break;
                default:
                    break;
            }

            if (this.Name == "txtPostcode") this.AnswerTypeID = 15;
            if (this.Text == "Date Of Birth" && this.AnswerTypeID == 2) this.AnswerTypeID = 24;
            if (this.Description.Contains("established") && this.AnswerTypeID == 2) this.AnswerTypeID = 29;
            if (this.Description.Contains("Cover Start Date") && this.AnswerTypeID == 2) { this.AnswerTypeID = 30; /*this.Visible = false; */}
            if (this.AnswerName == "YearEstab") { this.AnswerTypeID = 1; this.ListTableName = "YearsSince1970"; }
        }

        public void GetDatabaseColumnType()
        {
            if (this.AnswerTypeID == 1) { this.DatabaseColumnType = "varchar(8)"; return; }
            if (this.AnswerTypeID == 5) { this.DatabaseColumnType = "money"; return; }
            if (this.Numeric == "True" && this.DecimalPlaces != "0") { this.DatabaseColumnType = "money"; return; }
            if (this.Numeric == "True" && this.DecimalPlaces == "0") { this.DatabaseColumnType = "int"; return; }
            if (this.AnswerTypeID == 4) { this.DatabaseColumnType = "bit"; return; }
            if (new long[] { 2, 24, 29 ,30}.Contains(this.AnswerTypeID)) { this.DatabaseColumnType = "datetime"; return; }
            if (this.AnswerTypeID == 15) { this.DatabaseColumnType = "varchar(12)"; return; }
            if (this.Numeric == "False") { this.DatabaseColumnType = "varchar(" + this.MaxLength + ")"; return; }
            return;
        }

        public void DecodeListTableName()
        {
            switch (this.ListTableName)
            {
                case "LIST_INSURER":
                    this.ListTableName = "System_Insurer";
                    break;
                default:
                    break;
            }
        }
    }

    public class EnableControl
    {
        public string BoundScreen { get; set; }
        public string BoundScreenControl { get; set; }
        public string Enable { get; set; }
        public string Symbol { get; set; }
        public string Threshold { get; set; }
        public List<string> ListValueList { get; set; }

        public string Operator { get; set; }

        public void GetOperator(long AnswerTypeID) //Only coded base types to start with
        {
            this.Operator = "==";
            if (AnswerTypeID == 4)
            {
                this.Threshold = this.Enable;
            }

            switch (this.Symbol)
            {
                case "Greater":
                    this.Operator = "<";
                    break;
                case "Less":
                    this.Operator = ">";
                    break;
                default:
                    break;
            }
        }
    }
}
