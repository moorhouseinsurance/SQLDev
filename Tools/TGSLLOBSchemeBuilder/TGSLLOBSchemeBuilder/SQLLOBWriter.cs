using System;
using System.Linq;
using System.Text;
using System.IO;
using static TGSLLOBSchemeBuilder.Configuration;
using TGSLLOBSchemeBuilder.Templates.SQL;
using Moorhouse.Templates.SQL;
using System.Collections.Generic;

namespace TGSLLOBSchemeBuilder
{
   public  enum ProjectLevel
    {
            Projects = 1,
            LOB = 2,
            Scheme = 3,
            None= 4
    }
    class SQLLOBWriter
    {
        public QuestionSet QuestionSet { get; set; }

        private StringBuilder stringBuilder = new StringBuilder();

        public void Write()
        {
            if (QuestionSet == null)
            {
                QuestionSet = new QuestionSet();
                QuestionSet.Read();
            }

            ScriptAddScheme();

            ScriptExcesses();

            ScriptListEndorsement();

            ScriptLimits();

            ScriptAssumptions();

            ScriptLoadDiscounts();

            ScriptRates();

            ScriptTrades();

            ScriptTVFClaims();

            ScriptSynonymsListTables();

            ScriptRiskTableTypes();

            ScriptUSPCalculator();

            ScripttvfDispatcher();

            ScripttvfSchemeCalculator();

            ScriptBordereaux();

            ScriptDocumentFormulae();

        }

        private void ScriptDocumentFormulae()
        {
            if (ProjectLevels.DocumentFormulae != ProjectLevel.None)
            {
                StringBuilder DocumentFormulae = new StringBuilder();
                foreach (string PremiumSection in PremiumSections)
                {
                    DocumentFormulae.Append(DocumentFormulaeInsert.CoverText.Replace("{PremiumSection}", PremiumSection));
                    DocumentFormulae.Append(DocumentFormulaeInsert.CoverValue.Replace("{PremiumSection}", PremiumSection));
                    DocumentFormulae.Append(DocumentFormulaeInsert.Premium.Replace("{PremiumSection}", PremiumSection));
                }
                WriteFile(DocumentFormulae, "DocumentFormuale.Script.sql", ProjectLevel.LOB);
            }
        }

        private void ScripttvfSchemeCalculator()
        {
            if (ProjectLevels.Calculator != ProjectLevel.None)
            {
                StringBuilder sbtvfSchemeCalculator = new StringBuilder();

                sbtvfSchemeCalculator.Append(tvfSchemeCalculator.functionBody)
                    .Replace("{PremiumList}", ScriptPremiumList())
                    .Replace("{RiskTableParameters}", ScriptRiskTablesParameters())
                    .Replace("{Insurer}", Insurer)
                    .Replace("{LineOfBusiness}", LineOfBusiness)
                    .Replace("{SchemeTableID}", SchemeTableID);

                WriteFile(sbtvfSchemeCalculator, "tvfCalculator.UserDefinedFunction.sql", ProjectLevel.Scheme);
            }
        }

        private string ScriptPremiumList()
        {
            stringBuilder.Clear();

            foreach (string PremiumSection in PremiumSections)
            {
                stringBuilder.Append(tvfSchemeCalculator.PremiumListValue.Replace("{PremiumSection}", PremiumSection));
            }
            return stringBuilder.ToString(); //.RemoveFirst(",");
        }

        
        private string ScriptPremiumSectionDefaultValueList()
        {
            stringBuilder.Clear();

            foreach (string PremiumSection in PremiumSections)
            {
                stringBuilder.Append(tvfSchemeDispatcher.PremiumSectionDefaultValue.Replace("{PremiumSection}", PremiumSection));
            }
            return stringBuilder.ToString().Remove(stringBuilder.Length - 1); //Removes trailing comma
        }

        private void ScripttvfDispatcher()
        {
            if (ProjectLevels.SchemeDispatcher != ProjectLevel.None)
            {
                StringBuilder sbtvfSchemeDispatcher = new StringBuilder();

                sbtvfSchemeDispatcher.Append(tvfSchemeDispatcher.functionBody)
                    .Replace("{RiskTableParameters}", ScriptRiskTablesParameters())
                    .Replace("{RiskTablesListEOL}", RiskTablesListEOL())
                    .Replace("{RiskTablesList}", RiskTablesList())
                    .Replace("{Insurer}", Insurer)
                    .Replace("{LineOfBusiness}", LineOfBusiness)
                    .Replace("{SchemeTableID}", SchemeTableID)
                    .Replace("{PremiumSectionDefaultValue}", ScriptPremiumSectionDefaultValueList())
                    ;
                WriteFile(sbtvfSchemeDispatcher, "tvfSchemeDispatcher.UserDefinedFunction.sql", ProjectLevel.LOB);
            }
        }

        private string RiskTablesListEOL()
        {
            StringBuilder sb = new StringBuilder();

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                sb.Append("\t\t,@" + form.FormName + Environment.NewLine);
            }
            return sb.ToString().TrimEnd(Environment.NewLine.ToCharArray());
        }

        private string ScriptRiskTablesParameters()
        {
            StringBuilder sb = new StringBuilder();

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                sb.Append(tvfSchemeDispatcher.RiskTableParameter)
                    .Replace("{FormName}", form.FormName);
            }
            return sb.ToString().TrimEnd(Environment.NewLine.ToCharArray());
        }

        private void ScriptRiskTableTypes()
        {
            if (ProjectLevels.RiskTableTypes != ProjectLevel.None)
            {
                StringBuilder riskTableTypeCreate = new StringBuilder();
                StringBuilder tableColumns = new StringBuilder();
                foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
                {

                    riskTableTypeCreate.Append(LOBCalculator.RiskTableTypeCreate.Replace("{FormName}", form.FormName));
                    tableColumns.Clear();
                    foreach (Control control in form.ControlList)
                    {
                        tableColumns.Append(LOBCalculator.RiskTableColumn
                                .Replace("{AnswerName}", control.AnswerName)
                                .Replace("{ColumnType}", control.AnswerTypeID == 1 ? "varchar(250)" : control.DatabaseColumnType));

                        if (control.AnswerTypeID == 1 && control.ListTableName != "YearsSince1970")
                        {
                            tableColumns.Append(LOBCalculator.RiskTableColumn
                                .Replace("{AnswerName}", control.AnswerName + "_ID")
                                .Replace("{ColumnType}", "varchar(8)"));
                        }
                    }
                    riskTableTypeCreate.Replace("{Tablecolumns}", tableColumns.RemoveFirst(","));
                }
                WriteFile(riskTableTypeCreate, "RiskTables.Type.sql", ProjectLevel.LOB);
            }
            return;
        }

        private void ScriptBordereaux()
        {
            if (ProjectLevels.RiskBordereaux != ProjectLevel.None)
            {
                StringBuilder LOBRiskView = new StringBuilder(ScriptRiskTableView());
                WriteFile(LOBRiskView, "LOBRiskView.View.sql", ProjectLevel.LOB);
            }
        }

        private string ScriptRiskTables()
        {
            throw new NotImplementedException();
        }

        private string ScriptRiskTableView()
        {
            //Does not yet support 
            StringBuilder selectColumns = new StringBuilder();
            StringBuilder selectJoinListClause = new StringBuilder();
            string drivingTableName = "";

            foreach (Form form in QuestionSet.Where(f => (new string[] { "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false && f.Instance != "M"))
            {
                if (drivingTableName == "")
                {
                    drivingTableName = form.AnswerTable;
                    selectColumns.Append(string.Format("\t\t[{0}].[Policy_Details_ID]", drivingTableName)).Append(Environment.NewLine);
                    selectColumns.Append(string.Format("\t\t,[{0}].[History_ID]", drivingTableName)).Append(Environment.NewLine);
                    selectJoinListClause.Append("\t\t").Append("["+drivingTableName+"]").Append(Environment.NewLine);
                }
                else
                {
                    selectJoinListClause.Append(LOB.LOBRiskViewSelectJoinClause.Replace("{TableName}", form.AnswerTable).Replace("{DrivingTable}", drivingTableName));
                }
                foreach (Control control in form.ControlList)
                {
                    string selectColumn = LOB.LOBRiskViewSelectColumn.Replace("{TableName}", form.AnswerTable).Replace("{FormName}", form.FormName).Replace("{AnswerName}", control.AnswerName);
                    if (control.AnswerTypeID == 1 && control.ListTableName != "YearsSince1970")
                    {
                        selectJoinListClause.Append(LOB.LOBRiskViewSelectJoinListClause.Replace("{ListTableName}", control.ListTableName).Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListColumnName}", control.ListColumnName).Replace("{AnswerColumnName}", control.AnswerColumnName).Replace("{TableName}", form.AnswerTable)).Append(Environment.NewLine);
                        selectColumn = LOB.LOBRiskViewSelectListColumn.Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListColumnName}", control.ListColumnName).Replace("_ID", "").Replace("{AnswerName}", control.AnswerName);
                    }
                    selectColumns.Append(selectColumn);
                }
            }
            selectColumns.RemoveFirst(",");
            return LOB.LOBRiskView.Replace("{LOBRiskViewSelectList}", selectColumns.ToString()).Replace("{LOBRiskViewJoinList}", selectJoinListClause.ToString()).ToString();
        }

        private void ScriptExcesses()
        {
            if (ProjectLevels.Excesses != ProjectLevel.None)
            {
                ScriptTableExcesses();
                //ScriptTableDataExcesses();
                //ScriptSVFExcessSelect();
            }
        }

        private void ScriptTableExcesses()
        {
            stringBuilder.Clear();
            if (ProjectLevels.Excesses == ProjectLevel.LOB)
            {
                stringBuilder.Append(LOB.TableExcess_LOB);
            }
            if (ProjectLevels.Excesses == ProjectLevel.Scheme)
            {
                stringBuilder.Append(LOB.TableExcess_Scheme);
            }
            WriteFile(stringBuilder, "Excess.Table.sql", ProjectLevels.Excesses);
        }

        private void ScriptTrades()
        {
            if (ProjectLevels.Trades != ProjectLevel.None)
            {
                ScriptTableTrades();
                //ScriptTableDataTrades();
                ScriptTvfTrade();
            }
        }

        private void ScriptTvfTrade()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.tvfTrade);
            WriteFile(stringBuilder, "tvfTrades.UserDefinedFunction.sql", ProjectLevels.Trades);
        }

        private void ScriptTableTrades()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableTrade);
            WriteFile(stringBuilder, "Trades.Table.sql", ProjectLevels.Trades);
        }

        private void ScriptListEndorsement()
        {
            if(ProjectLevels.Endorsements != ProjectLevel.None)
            {
                stringBuilder.Clear();
                stringBuilder.Append(LOB.TableDataListEndorsement)
                    .Replace("{InsurerID}", InsurerID)
                    .Replace("{ProductTypeID}", QuestionSet.ProductTypeID.ToString());

                WriteFile(stringBuilder, "List_Endorsement.TableData.sql", ProjectLevels.Endorsements);
            }
        }

        private void ScriptRates()
        {
            if (ProjectLevels.Rates != ProjectLevel.None)
            {
                ScriptTableRate();
                ScriptTableDataRate();
                ScriptSVFRateSelect();
            }
        }

        private void ScriptLoadDiscounts()
        {
            if (ProjectLevels.LoadDiscounts != ProjectLevel.None)
            {
                ScriptTableLoadDiscount();
                ScriptTableDataLoadDiscount();
                ScriptSVFLoadDiscountSelect();
            }
        }

        private void ScriptAssumptions()
        {
            if (ProjectLevels.Assumptions != ProjectLevel.None)
            {
                ScriptTableAssumption();
                ScriptTableDataAssumption();
                ScriptTVFAssumptions();
            }
        }

        private void ScriptLimits()
        {
            if (ProjectLevels.Limits != ProjectLevel.None)
            {
                ScriptTableLimit();
                ScriptTableDataLimit();
                ScriptSVFLimitSelect();
            }
        }

        private void ScriptAddScheme()
        {
            if (ProjectLevels.AddScheme != ProjectLevel.None)
            {
                stringBuilder.Clear();
                stringBuilder.Append(LOB.AddSchemeScript.Replace("{SchemeName}", SchemeName)
                    .Replace("{wpdFileName}", wpdFileName)
                    .Replace("{InsurerID}", InsurerID)
                    .Replace("{InternetAvailable}", InternetAvailable)
                    .Replace("{CommissionPercent}", CommissionPercent)
                    .Replace("{RangePrefix}",RangePrefix)
                    .Replace("{RateStartDateTime}", RateStartDateTime.ToLongDateString())
                    .Replace("{ProductTypeID}", QuestionSet.ProductTypeID.ToString()))
                    .Replace("{SchemeLinkAgents}", SchemeLinkAgents);

                WriteFile(stringBuilder, "AddScheme.Script.sql", ProjectLevels.AddScheme);
            }
        }

        private void ScriptUSPCalculator()
        {
            if (ProjectLevels.Calculator == ProjectLevel.Scheme)
            {
                StringBuilder uspCalculator = new StringBuilder();

                uspCalculator.Append(LOB.uspCalculator)
                    .Replace("{RiskTables}", ScriptRiskXML())//ScriptRiskXMLAsTables())
                    .Replace("{Limits}", ScriptLimitsToVariables())
                    .Replace("{AssumptionRefers}", ScriptAssumptionRefers())
                    .Replace("{Excesses}", ScriptCalculatorExcesses())
                    .Replace("{LoadDiscount}", ScriptLoadDiscountToVariables())
                    .Replace("{Rates}", ScriptRatesToVariables())
                    .Replace("{PremiumSections}", ScriptReturnPremiumSections())
                    .Replace("{DeclarePremiumSections}", ScriptDeclarePremiumSections())
                    .Replace("{SelectRiskTables}", ScriptSelectRiskTables());

                WriteFile(uspCalculator, "uspCalculator.StoredProcedure.sql", ProjectLevels.Calculator);
            }

            if (ProjectLevels.Calculator == ProjectLevel.LOB)
            { 
                StringBuilder uspCalculator = new StringBuilder();

                uspCalculator.Append(LOBCalculator.ProcedureBody)
                    .Replace("{RiskTables}", ScriptRiskXML())
                    .Replace("{SelectRiskTables}", ScriptSelectRiskTables())
                    .Replace("{RiskTablesList}", RiskTablesList());

                if (RealTimePricingApplies == true)
                {
                    uspCalculator.Append(LOBCalculator.ProcedureBodyRTPResults);
                }
                else
                {   uspCalculator.Append(LOBCalculator.ProcedureBodyResults); 
                }

                WriteFile(uspCalculator, "uspCalculator.StoredProcedure.sql", ProjectLevels.Calculator);
            }
        }

        private string RiskTablesList()
        {
            StringBuilder sb = new StringBuilder();

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                sb.Append(" ,@" + form.FormName);
            }
            return sb.ToString();
        }

        private string ScriptSelectRiskTables()
        {
            StringBuilder sb = new StringBuilder();

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                sb.Append(LOBCalculator.SelectRiskTable).Replace("{FormName}", form.FormName).Append(Environment.NewLine);
            }
            return sb.ToString();
        }

        private string ScriptCalculatorExcesses()
        {
            if (ProjectLevels.Excesses == ProjectLevel.None) return "";
            if (ProjectLevels.Excesses == ProjectLevel.LOB) return LOB.uspCalculatorExcesses.Replace("{LOBName}", LOBName).Replace("_{Insurer}", "").Replace("_{LineOfBusiness}", "").ToString();
            return LOB.uspCalculatorExcesses;
        }

        private string ScriptAssumptionRefers()
        {
            if (ProjectLevels.Assumptions == ProjectLevel.None) return "";
            if (ProjectLevels.Assumptions == ProjectLevel.LOB) return LOB.uspCalculatorAssumptionRefers.Replace("{LOBName}", LOBName).Replace("_{Insurer}", "").Replace("_{LineOfBusiness}", "").ToString();
            return LOB.uspCalculatorAssumptionRefers;
        }

        private string ScriptDeclarePremiumSections()
        {
            stringBuilder.Clear();

            foreach (string PremiumSection in PremiumSections)
            {
                stringBuilder.Append(LOB.uspCalculatorDeclarePremiumSections.Replace("{PremiumSection}", PremiumSection));
            }
            return stringBuilder.ToString();
        }

        private string ScriptRatesToVariables()
        {
            return LOB.CalculatorRate;
        }

        private  String ScriptLimitsToVariables()
        {
            if (ProjectLevels.Limits == ProjectLevel.None) return "";
                StringBuilder limits = new StringBuilder();
                foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "Clmsum", "ClmDtail" }.Contains(f.FormName)) == false))
                {
                    foreach (Control control in form.ControlList)
                    {
                        if (new long[] { 1, 3, 5 }.Contains(control.AnswerTypeID))
                        {
                            limits.Append(LOB.uspCalculatorLimits
                                .Replace("{LimitType}", form.FormName + "_" + control.AnswerName)
                                .Replace("{DataType}", control.DatabaseColumnType));
                        }
                    }
                }
            if (ProjectLevels.Limits == ProjectLevel.LOB) return limits.Replace("{LOBName}", LOBName).Replace("_{Insurer}", "").Replace("_{LineOfBusiness}", "").ToString();
            return limits.ToString();
        }

        private String ScriptLoadDiscountToVariables()
        {
            StringBuilder loadDiscount = new StringBuilder();
            loadDiscount.Append(LOB.CalculatorLoadDiscount);
            return loadDiscount.ToString();
        }

        private string ScriptRiskXML()
        {
            return ScriptRiskXMLAsTablesOnly();
           // return ScriptRiskXMLAsVariables() + ScriptRiskXMLAsTables();
        }

        private string ScriptRiskXMLAsVariables()
        {
            StringBuilder riskXMLAsTables = new StringBuilder();
            StringBuilder tableColumns = new StringBuilder();
            StringBuilder selectColumns = new StringBuilder();
            StringBuilder selectJoinListClause = new StringBuilder();
            StringBuilder selectVariables = new StringBuilder();
            String LOBselectColumnXPath = "";
            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false && f.Instance !="M"))
            {
                riskXMLAsTables.Append(LOB.CalculatorXMLTableAsVariables.Replace("{FormName}", form.FormName));
                tableColumns.Clear().Append("DECLARE ");
                selectColumns.Clear();
                selectJoinListClause.Clear();
                selectVariables.Clear(); 

                foreach (Control control in form.ControlList)
                {
                    selectVariables.Append(LOB.SelectVariables
                            .Replace("{FormName}", form.FormName)
                            .Replace("{AnswerName}", control.AnswerName));
                    tableColumns.Append(LOB.CalculatorXMLDeclareVariable
                            .Replace("{FormName}", form.FormName)
                            .Replace("{AnswerName}", control.AnswerName)
                            .Replace("{ColumnType}", control.AnswerTypeID == 1 ? "varchar(250)" : control.DatabaseColumnType));
                    LOBselectColumnXPath = LOB.SelectColumnXPath;
                    if (control.DatabaseColumnType == "money" || control.DatabaseColumnType == "bit") LOBselectColumnXPath = LOB.SelectColumnXPathIsNULL;

                    string selectColumnXPath =  LOBselectColumnXPath.Replace("{Datatype}", control.DatabaseColumnType).Replace("{AnswerName}", control.AnswerName);
                    string selectColumn = LOB.SelectColumnAsVariable.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{AnswerName}", control.AnswerName).Replace("{FormName}", form.FormName);
                    if (control.AnswerTypeID == 1 && control.ListTableName != "YearsSince1970")
                    {
                        selectVariables.Append(LOB.SelectVariables
                            .Replace("{FormName}", form.FormName)
                            .Replace("{AnswerName}", control.AnswerName + "_ID"));
                        tableColumns.Append(LOB.CalculatorXMLDeclareVariable
                            .Replace("{FormName}", form.FormName)
                            .Replace("{AnswerName}", control.AnswerName + "_ID")
                            .Replace("{ColumnType}", control.AnswerTypeID == 1 ? "varchar(8)" : control.DatabaseColumnType));
                        selectJoinListClause.Append(LOB.SelectJoinListClause.Replace("{ListTableName}", control.ListTableName).Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListColumnName}", control.ListColumnName).Replace("{SelectColumn}", selectColumnXPath)).Append(Environment.NewLine);
                        selectColumn = LOB.SelectListColumnAsVariable.Replace("{ListTableAlias}", control.ListTableAlias).Replace("{FormName}", form.FormName).Replace("{ListTableName}", control.ListTableName).Replace("{ListColumnName}", control.ListColumnName).Replace("_ID", "").Replace("{AnswerName}", control.AnswerName)
                            + LOB.SelectColumnAsVariable.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{FormName}", form.FormName).Replace("{AnswerName}", control.AnswerName + "_ID");
                    }
                    if (control.DatabaseColumnType == "datetime")
                    {
                        selectColumn = selectColumn.Replace(selectColumnXPath,"CONVERT(datetime ," + selectColumnXPath ).Replace("'datetime')", "'varchar(30)'),103)");
                    }
                    selectColumns.Append(selectColumn);
                }
                riskXMLAsTables.Replace("{Tablecolumns}", tableColumns.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectColumns}", selectColumns.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectJoinListClause}", selectJoinListClause.ToString());
                riskXMLAsTables.Replace("{SelectVariables}", selectVariables.ToString().RemoveFirst(","));
            }

            return riskXMLAsTables.ToString();
        }
        private string ScriptRiskXMLAsTables()
        {
            StringBuilder riskXMLAsTables = new StringBuilder();
            StringBuilder tableColumns = new StringBuilder();
            StringBuilder answerNames = new StringBuilder();
            StringBuilder selectColumns = new StringBuilder();
            StringBuilder selectJoinListClause = new StringBuilder();
            StringBuilder selectTables = new StringBuilder();

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false && f.Instance == "M"))
            {

                riskXMLAsTables.Append(LOBCalculator.RiskTableDeclare.Replace("{FormName}", form.FormName));
                tableColumns.Clear();
                answerNames.Clear();
                selectColumns.Clear();
                selectJoinListClause.Clear();

                foreach (Control control in form.ControlList)
                {


                    answerNames.Append(" ,[").Append(control.AnswerName).Append("]");

                    string selectColumnXPath = LOBCalculator.SelectColumnXPath.Replace("{Datatype}", control.DatabaseColumnType).Replace("{AnswerName}", control.AnswerName);
                    string selectColumn = LOBCalculator.SelectColumn.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{AnswerName}", control.AnswerName);
                    if (control.AnswerTypeID == 1 && control.ListTableName != "YearsSince1970")
                    {
                        tableColumns.Append(LOBCalculator.RiskTableColumn
                            .Replace("{AnswerName}", control.AnswerName+"_ID")
                            .Replace("{ColumnType}", control.AnswerTypeID == 1 ? "varchar(8)" : control.DatabaseColumnType));
                        answerNames.Append(" ,[").Append(control.AnswerName).Append("_ID]");
                        selectJoinListClause.Append(LOBCalculator.SelectJoinListClause.Replace("{ListTableName}", control.ListTableName).Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListColumnName}", control.ListColumnName).Replace("{SelectColumn}", selectColumnXPath)).Append(Environment.NewLine);
                        selectColumn = LOBCalculator.SelectListColumn.Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListTableName}", control.ListTableName).Replace("{ListColumnName}", control.ListColumnName).Replace("_ID", "").Replace("{AnswerName}", control.AnswerName)
                            + LOBCalculator.SelectColumn.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{AnswerName}", control.AnswerName + "_ID");
                    }
                    if (control.DatabaseColumnType == "datetime")
                    {
                        selectColumn = ",CONVERT(datetime ," + selectColumn.RemoveFirst(",").Replace("'datetime')", "'varchar(30)'),103)");
                    }
                    selectColumns.Append(selectColumn);
                }
                riskXMLAsTables.Replace("{Tablecolumns}", tableColumns.RemoveFirst(","));
                riskXMLAsTables.Replace("{AnswerNames}", answerNames.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectColumns}", selectColumns.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectJoinListClause}", selectJoinListClause.ToString());
                selectTables.Append("SELECT * FROM @").Append(form.FormName).Append(Environment.NewLine);

            }
            riskXMLAsTables.Append(selectTables);
            return riskXMLAsTables.ToString();
        }

        private string ScriptRiskXMLAsTablesOnly()
        {
            StringBuilder riskXMLAsTables = new StringBuilder();
            StringBuilder tableColumns = new StringBuilder();
            StringBuilder answerNames = new StringBuilder();
            StringBuilder selectColumns = new StringBuilder();
            StringBuilder selectJoinListClause = new StringBuilder();
            StringBuilder selectTables = new StringBuilder();
            String LOBselectColumnXPath = "";

            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                riskXMLAsTables.Append(LOBCalculator.RiskTableDeclare.Replace("{FormName}", form.FormName));
                riskXMLAsTables.Append(LOBCalculator.RiskTableInsert.Replace("{FormName}", form.FormName));
                answerNames.Clear();
                selectColumns.Clear();
                selectJoinListClause.Clear();

                foreach (Control control in form.ControlList)
                {
                     answerNames.Append(" ,[").Append(control.AnswerName).Append("]");

                    LOBselectColumnXPath = LOBCalculator.SelectColumnXPath;
                    if (control.DatabaseColumnType == "money" || control.DatabaseColumnType == "bit") LOBselectColumnXPath = LOBCalculator.SelectColumnXPathIsNULL;

                    string selectColumnXPath = LOBselectColumnXPath.Replace("{Datatype}", control.DatabaseColumnType).Replace("{AnswerName}", control.AnswerName);
                    string selectColumn = LOBCalculator.SelectColumn.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{AnswerName}", control.AnswerName);
                    if (control.AnswerTypeID == 1 && control.ListTableName != "YearsSince1970")
                    {
                        answerNames.Append(" ,[").Append(control.AnswerName).Append("_ID]");
                        selectJoinListClause.Append(LOBCalculator.SelectJoinListClause.Replace("{ListTableName}", control.ListTableName).Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListColumnName}", control.ListColumnName).Replace("{SelectColumn}", selectColumnXPath)).Append(Environment.NewLine);
                        selectColumn = LOBCalculator.SelectListColumn.Replace("{ListTableAlias}", control.ListTableAlias).Replace("{ListTableName}", control.ListTableName).Replace("{ListColumnName}", control.ListColumnName).Replace("_ID", "").Replace("{AnswerName}", control.AnswerName)
                            + LOBCalculator.SelectColumn.Replace("{SelectColumnXPath}", selectColumnXPath).Replace("{AnswerName}", control.AnswerName + "_ID");
                    }
                    if (control.DatabaseColumnType == "datetime")
                    {
                        selectColumn = ",CONVERT(datetime ," + selectColumn.RemoveFirst(",").Replace("'datetime')", "'varchar(30)'),103)");
                    }
                    selectColumns.Append(selectColumn);
                }
                riskXMLAsTables.Replace("{AnswerNames}", answerNames.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectColumns}", selectColumns.RemoveFirst(","));
                riskXMLAsTables.Replace("{SelectJoinListClause}", selectJoinListClause.ToString());

            }
            riskXMLAsTables.Append(selectTables);
            return riskXMLAsTables.ToString();
        }

        private string ScriptReturnPremiumSections()
        {
            stringBuilder.Clear();
            
            foreach (string PremiumSection in PremiumSections)
            {
                stringBuilder.Append(LOB.uspCalculatorReturnPremiumSections.Replace("{PremiumSection}", PremiumSection));
            }
            return stringBuilder.ToString();
        }
 
        private void ScriptSynonymsListTables()
        {
            if (ProjectLevels.Synonyms != ProjectLevel.None)
            {
                stringBuilder.Clear();
                foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "ClmSum", "ClmDtail" }.Contains(f.FormName)) == false))
                {
                    foreach (Control control in form.ControlList.Where(c => c.ListTableName != ""))
                    {
                        stringBuilder.Append(LOB.SynonymCreate.Replace("{ListTableName}", control.ListTableName)).Append(Environment.NewLine);
                    }
                }
                WriteFile(stringBuilder, "ListTable.Synonyms.sql", ProjectLevels.Synonyms);
            }
        }
        private void ScriptTableLoadDiscount()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableLoadDiscount);
            WriteFile(stringBuilder, "LoadDiscount.Table.sql", ProjectLevels.LoadDiscounts);
        }
        private void ScriptTableDataLoadDiscount()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableDataLoadDiscount.Replace("{RateStartDateTime}", RateStartDateTime.ToLongDateString()));
            WriteFile(stringBuilder,"LoadDiscounts.TableData.sql", ProjectLevels.LoadDiscounts);
        }
        private void ScriptSVFLoadDiscountSelect()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.svfLoadDiscountSelect);
            WriteFile(stringBuilder, "svfLoadDiscountsSelect.UserDefinedFunction.sql",ProjectLevels.LoadDiscounts);
        }


        private void ScriptTableRate()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableRate);
            WriteFile(stringBuilder, "Rate.Table.sql", ProjectLevels.Rates);
        }
        private void ScriptTableDataRate()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableDataRate.Replace("{RateStartDateTime}", RateStartDateTime.ToLongDateString()));
            WriteFile(stringBuilder, "Rates.TableData.sql", ProjectLevels.Rates);
        }
        private void ScriptSVFRateSelect()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.svfRateSelect);
            WriteFile(stringBuilder, "svfRatesSelect.UserDefinedFunction.sql", ProjectLevels.Rates);
        }


        private void ScriptTableDataLimit()
        {
            stringBuilder.Clear();
            foreach (Form form in QuestionSet.Where(f => (new string[] { "Assump", "Clmsum", "ClmDtail" }.Contains(f.FormName)) == false))
            {
                foreach (Control control in form.ControlList)
                {
                    if (new long[] { 1, 3, 5 }.Contains(control.AnswerTypeID))
                    {
                        stringBuilder.Append(LOB.TableLOBLimitInsert
                            .Replace("{LimitType}", form.FormName + "_" + control.AnswerName)
                            .Replace("{RateStartDateTime}", RateStartDateTime.ToLongDateString()));
                    }
                }
            }
            WriteFile(stringBuilder, "Limit.TableData.sql", ProjectLevels.Limits);
        }

        private void ScriptTableDataAssumption()
        {
            stringBuilder.Clear();
            foreach (Form form in QuestionSet.Where(f => ("Assump" == f.FormName)))
            {
                foreach (Control control in form.ControlList)
                {
                    stringBuilder.Append(LOB.TableLOBAssumptionInsert
                        .Replace("{RateStartDateTime}", RateStartDateTime.ToLongDateString())
                        .Replace("{AnswerColumnName}", control.AnswerName)
                        .Replace("{QuestionText}", control.Description));
                }
            }
            WriteFile(stringBuilder, "Assumption.TableData.sql", ProjectLevels.Assumptions);
        }

        private void ScriptTVFClaims()
        {
            if (ProjectLevels.Claims != ProjectLevel.None)
            {
                stringBuilder.Clear();
                stringBuilder.Append(LOB.tvfLOBClaims);
                WriteFile(stringBuilder, "tvfClaims.UserDefinedFunction.sql", ProjectLevels.Claims);
            }
        }

        private void ScriptTVFAssumptions()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.tvfLOBReferredAssumptions);
            WriteFile(stringBuilder, "tvfReferredAssumptions.UserDefinedFunction.sql", ProjectLevels.Assumptions);
        }

        private void ScriptTableAssumption()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableLOBAssumptions);
            WriteFile(stringBuilder, "Assumptions.Table.sql", ProjectLevels.Assumptions);
        }

        private void ScriptSVFLimitSelect()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.svfLOBLimitSelect);
            WriteFile(stringBuilder, "svfLimitSelect.UserDefinedFunction.sql", ProjectLevels.Limits);
        }

        private void ScriptTableLimit()
        {
            stringBuilder.Clear();
            stringBuilder.Append(LOB.TableLimit);
            WriteFile(stringBuilder, "Limit.Table.sql", ProjectLevels.Limits);
        }

        private void WriteFile(StringBuilder stringBuilder, string path, ProjectLevel projectLevel)
        {
            switch (projectLevel)
            {
                case ProjectLevel.LOB:
                    stringBuilder.Replace("{LOBName}", LOBName).Replace("_{Insurer}", "").Replace("_{LineOfBusiness}", "").Replace("{Insurer}", Insurer.Replace(" ", "")).Replace("{LineOfBusiness}", LineOfBusiness.Replace(" ", ""));
                    path = string.Format("{0}dbo.{1}_{2}", Test? Paths.Test :Paths.LOBSQL, LOBName, path);
                    break;
                case ProjectLevel.Scheme:
                    stringBuilder.Replace("{LOBName}", LOBName).Replace("{Insurer}", Insurer).Replace("{LineOfBusiness}", LineOfBusiness);
                    path = string.Format("{0}dbo.{1}_{2}_{3}_{4}", Test ? Paths.Test : Paths.SchemeSQL, LOBName, Insurer, LineOfBusiness, path);
                    break;
                default:
                    break;
            }
            stringBuilder.Replace("{Datetime}", DateTime.Now.ToString("dd MMM yyyy"));
            WriteFile(stringBuilder,  path);
        }

        private void WriteFile(StringBuilder stringBuilder ,string path)
        {
            try
            {
                System.IO.TextWriter writeFile = new StreamWriter(path);
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

    }
}
