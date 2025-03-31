using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using static TGSLLOBSchemeBuilder.Configuration;

namespace TGSLLOBSchemeBuilder
{
    public class CAQLOBWriter:IDisposable
    {
        public QuestionSet QuestionSet { get; set; }
        public SqlConnection SqlConnection{ get; set; }
        public SqlCommand QuestionSetInsertUpdateSqlCommand;
        public SqlCommand GroupInsertSqlCommand;
        public SqlCommand SectionInsertSqlCommand;
        public SqlCommand QuestionInsertSqlCommand;
        public SqlCommand AgentQuestionInsertSqlCommand;
        public SqlCommand ListTableInsertSqlCommand;
        public SqlCommand EnablementInsertSqlCommand;
        public SqlCommand ProductPolicyAnswerTablesInsertSqlCommand;
        public SqlCommand QuestionSetDeleteSqlCommand;

        public SqlTransaction Tran { get; set; }

        public CAQLOBWriter()
        {
            SqlConnection = new SqlConnection(ProductDatabase);
            SqlConnection.Open();

            QuestionSetDeleteSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspQuestionSetDeleteOrList]"
            };
            QuestionSetDeleteSqlCommand.Parameters.Add("QuestionSetName", SqlDbType.VarChar);
            QuestionSetDeleteSqlCommand.Parameters.Add("Delete", SqlDbType.Bit);
            QuestionSetDeleteSqlCommand.Parameters.Add("Type", SqlDbType.Char);
            QuestionSetDeleteSqlCommand.Parameters.Add("SectionNames", SqlDbType.VarChar);
            QuestionSetDeleteSqlCommand.Parameters.Add("QuestionNames", SqlDbType.VarChar);

            ProductPolicyAnswerTablesInsertSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspProductPolicyAnswerTablesInsert]"
            };
            ProductPolicyAnswerTablesInsertSqlCommand.Parameters.Add("QuestionSetID", SqlDbType.Int);

            QuestionSetInsertUpdateSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspQuestionSetInsert]"
            };
            QuestionSetInsertUpdateSqlCommand.Parameters.Add("QuestionSetName", SqlDbType.VarChar);
            QuestionSetInsertUpdateSqlCommand.Parameters.Add("DevelopersNotes", SqlDbType.VarChar);
            QuestionSetInsertUpdateSqlCommand.Parameters.Add("InsertUserID", SqlDbType.Int);

            GroupInsertSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspGroupInsert]"
            };
            GroupInsertSqlCommand.Parameters.Add("GroupName", SqlDbType.VarChar);
            GroupInsertSqlCommand.Parameters.Add("Text", SqlDbType.VarChar);
            GroupInsertSqlCommand.Parameters.Add("SortOrder", SqlDbType.Int);
            GroupInsertSqlCommand.Parameters.Add("InsertUserID", SqlDbType.Int);

            SectionInsertSqlCommand = new SqlCommand()
            {
                CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspSectionInsert]"
            };
            SectionInsertSqlCommand.Parameters.Add("GroupID", SqlDbType.Int);
            SectionInsertSqlCommand.Parameters.Add("SectionName", SqlDbType.VarChar);
            SectionInsertSqlCommand.Parameters.Add("Text", SqlDbType.VarChar);
            SectionInsertSqlCommand.Parameters.Add("SortOrder", SqlDbType.Int);
            SectionInsertSqlCommand.Parameters.Add("InsertUserID", SqlDbType.Int);

            QuestionInsertSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspQuestionInsert]"
            };
            QuestionInsertSqlCommand.Parameters.Add("QuestionSetID", SqlDbType.Int);
            QuestionInsertSqlCommand.Parameters.Add("AnswerTableName", SqlDbType.VarChar);
            QuestionInsertSqlCommand.Parameters.Add("AnswerFieldName", SqlDbType.VarChar);

 
            AgentQuestionInsertSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspAgentQuestionDetailsInsert]"
            };
            AgentQuestionInsertSqlCommand.Parameters.Add("QuestionID", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("AnswerDefaultValueOrID", SqlDbType.VarChar);
            AgentQuestionInsertSqlCommand.Parameters.Add("AnswerDefaultSet", SqlDbType.Bit);
            AgentQuestionInsertSqlCommand.Parameters.Add("AnswerTypeID", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("Enabled", SqlDbType.Bit);
            AgentQuestionInsertSqlCommand.Parameters.Add("ListTableID", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("Mandatory", SqlDbType.Bit);
            AgentQuestionInsertSqlCommand.Parameters.Add("ParentQuestionID", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("SectionID", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("SortOrder", SqlDbType.Int);
            AgentQuestionInsertSqlCommand.Parameters.Add("Text", SqlDbType.VarChar);
            AgentQuestionInsertSqlCommand.Parameters.Add("HelpText", SqlDbType.VarChar);
            AgentQuestionInsertSqlCommand.Parameters.Add("Visible", SqlDbType.Bit);

            ListTableInsertSqlCommand = new SqlCommand()
            {
                CommandType = CommandType.StoredProcedure
                ,
                Connection = SqlConnection
                ,
                CommandText = "[QuestionSet].[uspListTableInsert]"
            };
            ListTableInsertSqlCommand.Parameters.Add("ListTableName", SqlDbType.VarChar);

            EnablementInsertSqlCommand = new SqlCommand()
            {
                 CommandType = CommandType.StoredProcedure
                ,Connection = SqlConnection
                ,CommandText = "[QuestionSet].[uspEnablementInsert]"
            };
            EnablementInsertSqlCommand.Parameters.Add("ComparatorQuestionID", SqlDbType.BigInt);
            EnablementInsertSqlCommand.Parameters.Add("EnablementListValueString", SqlDbType.VarChar);
            EnablementInsertSqlCommand.Parameters.Add("EnabledQuestionID", SqlDbType.BigInt);
            EnablementInsertSqlCommand.Parameters.Add("Operator", SqlDbType.VarChar);
            EnablementInsertSqlCommand.Parameters.Add("ComparatorValueOrID", SqlDbType.VarChar);
            EnablementInsertSqlCommand.Parameters.Add("EnablementCriteriaSetID", SqlDbType.BigInt);
        }

        internal void QuestionSetDelete(string QuestionSetName ,string SectionNames = null, string QuestionNames = null)
        {
            QuestionSetDeleteSqlCommand.Parameters["QuestionSetName"].Value = QuestionSetName;
            QuestionSetDeleteSqlCommand.Parameters["Delete"].Value = true;
            QuestionSetDeleteSqlCommand.Parameters["Type"].Value = "A";
            QuestionSetDeleteSqlCommand.Parameters["SectionNames"].Value = SectionNames;
            QuestionSetDeleteSqlCommand.Parameters["QuestionNames"].Value = QuestionNames;
            QuestionSetDeleteSqlCommand.ExecuteScalar();
        }

        internal void ProductPolicyAnswerTablesInsert(long QuestionSetID)
        {
            ProductPolicyAnswerTablesInsertSqlCommand.Parameters["QuestionSetID"].Value = QuestionSetID;
            ProductPolicyAnswerTablesInsertSqlCommand.ExecuteScalar();
        }

        internal long? EnablementInsert(long? ComparatorQuestionID, Control boundScreenControl, EnableControl enableControl)
        {
            EnablementInsertSqlCommand.Parameters["ComparatorQuestionID"].Value = ComparatorQuestionID; 
            EnablementInsertSqlCommand.Parameters["EnablementListValueString"].Value = enableControl.ListValueList.Count == 0 ? null : string.Join(",", enableControl.ListValueList.ToArray());
            EnablementInsertSqlCommand.Parameters["EnabledQuestionID"].Value = boundScreenControl.QuestionID;
            EnablementInsertSqlCommand.Parameters["Operator"].Value = enableControl.Operator;
            EnablementInsertSqlCommand.Parameters["ComparatorValueOrID"].Value = enableControl.Threshold;
            EnablementInsertSqlCommand.Parameters["EnablementCriteriaSetID"].Value = boundScreenControl.EnablementCriteriaSetID;
            boundScreenControl.EnablementCriteriaSetID = ConvertFromDBVal<long>(EnablementInsertSqlCommand.ExecuteScalar());
            return boundScreenControl.EnablementCriteriaSetID;
        }

        internal long? EnablementInsert(long? ComparatorQuestionID, Control boundScreenControl)
        {
            EnablementInsertSqlCommand.Parameters["ComparatorQuestionID"].Value = ComparatorQuestionID;
            EnablementInsertSqlCommand.Parameters["EnablementListValueString"].Value = null;
            EnablementInsertSqlCommand.Parameters["EnabledQuestionID"].Value = boundScreenControl.QuestionID;
            EnablementInsertSqlCommand.Parameters["Operator"].Value = "==";
            EnablementInsertSqlCommand.Parameters["ComparatorValueOrID"].Value = "1";
            EnablementInsertSqlCommand.Parameters["EnablementCriteriaSetID"].Value = boundScreenControl.EnablementCriteriaSetID;
            boundScreenControl.EnablementCriteriaSetID = ConvertFromDBVal<long>(EnablementInsertSqlCommand.ExecuteScalar());
            return boundScreenControl.EnablementCriteriaSetID;
        }

        internal long? ListTableInsert(string ListTableName)
        {
            ListTableInsertSqlCommand.Parameters["ListTableName"].Value = ListTableName;
            long ListTableID = ConvertFromDBVal<long>(ListTableInsertSqlCommand.ExecuteScalar());
            return ListTableID;
        }

        internal long AgentQuestionInsert(Control control , long? ListTableID , long? ParentQuestionID ,long SectionID)
        {
            AgentQuestionInsertSqlCommand.Parameters["QuestionID"].Value = control.QuestionID;
            AgentQuestionInsertSqlCommand.Parameters["AnswerDefaultValueOrID"].Value = control.DefaultValue;
            AgentQuestionInsertSqlCommand.Parameters["AnswerDefaultSet"].Value = control.DefaultValue == "" ? false : true;
            AgentQuestionInsertSqlCommand.Parameters["AnswerTypeID"].Value = control.AnswerTypeID;
            AgentQuestionInsertSqlCommand.Parameters["Enabled"].Value = control.Enabled == "True" ? true : false;
            AgentQuestionInsertSqlCommand.Parameters["ListTableID"].Value = ListTableID;
            AgentQuestionInsertSqlCommand.Parameters["Mandatory"].Value = control.Required == "True" ? true : false;
            AgentQuestionInsertSqlCommand.Parameters["ParentQuestionID"].Value = ParentQuestionID;
            AgentQuestionInsertSqlCommand.Parameters["SectionID"].Value = SectionID;
            AgentQuestionInsertSqlCommand.Parameters["SortOrder"].Value = control.TabIndex;
            AgentQuestionInsertSqlCommand.Parameters["Text"].Value = control.Text;
            AgentQuestionInsertSqlCommand.Parameters["HelpText"].Value = control.HelpText;
            AgentQuestionInsertSqlCommand.Parameters["Visible"].Value = control.Visible;

            long AgentQuestionID = ConvertFromDBVal<long>(AgentQuestionInsertSqlCommand.ExecuteScalar());
            return AgentQuestionID;
        }

        internal long QuestionInsert(long QuestionSetID, string AnswerTableName, string AnswerFieldName)
        {
            QuestionInsertSqlCommand.Parameters["QuestionSetID"].Value = QuestionSetID;
            QuestionInsertSqlCommand.Parameters["AnswerTableName"].Value = AnswerTableName;
            QuestionInsertSqlCommand.Parameters["AnswerFieldName"].Value = AnswerFieldName;
            long QuestionID = ConvertFromDBVal<long>(QuestionInsertSqlCommand.ExecuteScalar());
            return QuestionID; 
        }


        internal long QuestionSetInsert(string QuestionSetName)
        {
            QuestionSetInsertUpdateSqlCommand.Parameters["QuestionSetName"].Value = QuestionSetName;
            QuestionSetInsertUpdateSqlCommand.Parameters["DevelopersNotes"].Value = "Inserted From TGSL Screen designer .tst Files using TGSLLOBSchemeBuilder";
            QuestionSetInsertUpdateSqlCommand.Parameters["InsertUserID"].Value = 1;
            long QuestionSetID = ConvertFromDBVal<long>(QuestionSetInsertUpdateSqlCommand.ExecuteScalar());
            return QuestionSetID; // for now
        }

        internal long GroupInsert(string GroupName ,string Text ,int SortOrder)
        {
            GroupInsertSqlCommand.Parameters["GroupName"].Value = GroupName;
            GroupInsertSqlCommand.Parameters["Text"].Value = Text;
            GroupInsertSqlCommand.Parameters["SortOrder"].Value = SortOrder;
            GroupInsertSqlCommand.Parameters["InsertUserID"].Value = 1;
            long GroupID = ConvertFromDBVal<long>(GroupInsertSqlCommand.ExecuteScalar());
            return GroupID; // for now
        }

        internal long SectionInsert(long GroupID ,string SectionName ,string Text ,string SortOrder)
        {
            SectionInsertSqlCommand.Parameters["GroupID"].Value = GroupID;
            SectionInsertSqlCommand.Parameters["SectionName"].Value = SectionName;
            SectionInsertSqlCommand.Parameters["Text"].Value = Text;
            SectionInsertSqlCommand.Parameters["SortOrder"].Value = SortOrder;
            SectionInsertSqlCommand.Parameters["InsertUserID"].Value = 1;
            long SectionID = ConvertFromDBVal<long>(SectionInsertSqlCommand.ExecuteScalar());
            return SectionID; // for now
        }

        public void Write() //string QuestionSetName ,List<Form> FormList)
        {
            Tran = SqlConnection.BeginTransaction();
            QuestionSetDeleteSqlCommand.Transaction = Tran;
            QuestionSetInsertUpdateSqlCommand.Transaction = Tran;
            GroupInsertSqlCommand.Transaction = Tran;
            SectionInsertSqlCommand.Transaction = Tran;
            QuestionInsertSqlCommand.Transaction = Tran;
            ListTableInsertSqlCommand.Transaction = Tran;
            AgentQuestionInsertSqlCommand.Transaction = Tran;
            EnablementInsertSqlCommand.Transaction = Tran;
            ProductPolicyAnswerTablesInsertSqlCommand.Transaction = Tran;


            try
            {
                long questionSetID;
                long groupID;
                IEnumerator<Form> formListEnumerator;
                if (!CAQLOBSections.Any())
                {
                    QuestionSetDelete(QuestionSet.QuestionSetName);
                    questionSetID = QuestionSetInsert(QuestionSet.QuestionSetName);
                    groupID = GroupInsert(QuestionSet.QuestionSetName, QuestionSet.QuestionSetName, 1);
                    formListEnumerator = QuestionSet.Where(frm => frm.ShowOnWebsite == true).GetEnumerator();
                }
                else
                {
                    if (CAQLOBQuestionsString == "") //Future development
                    { 
                        QuestionSetDelete(QuestionSet.QuestionSetName, CAQLOBSectionsString, CAQLOBQuestionsString);
                    }
                    questionSetID = CAQLOBQuestionSetIDOverride;
                    groupID = CAQLOBGroupIDOverride;
                    formListEnumerator = QuestionSet.Where(frm => frm.ShowOnWebsite == true && CAQLOBSections.Contains(frm.Filename)).GetEnumerator();
                }

                while (formListEnumerator.MoveNext())
                {
                    Form form = formListEnumerator.Current;
                    var parentQuestionID = form.ParentControl?.QuestionID;
                    long sectionID = SectionInsert(groupID, form.Filename, form.Description, form.ScreenOrder);
                    foreach (Control control in form.ControlList.Where(c => c.DisplayOnWebpage == true && (!CAQLOBQuestions.Any() || CAQLOBQuestions.Contains(c.Name))))
                    {
                        control.ParentQuestionID = parentQuestionID;
                        control.QuestionID = QuestionInsert(questionSetID, form.AnswerTable, control.AnswerColumnName);
                        long? listTableID = control.ListTableName != "" ? ListTableInsert(control.ListTableName) : null;
                        long agentQuestionID = AgentQuestionInsert(control, listTableID, control.ParentQuestionID, sectionID);

                    }
                    //Update Children for non updated screens to new parentquestionID
                }


                //Enablement
                if (!CAQLOBSections.Any())
                {
                    formListEnumerator = QuestionSet.Where(frm => frm.ShowOnWebsite == true).GetEnumerator();
                }
                else
                {
                    formListEnumerator = QuestionSet.Where(frm => frm.ShowOnWebsite == true && CAQLOBSections.Contains(frm.Filename)).GetEnumerator();
                }
                while (formListEnumerator.MoveNext())
                {
                    Form form = formListEnumerator.Current;
                    foreach (Control control in form.ControlList.Where(c => c.DisplayOnWebpage == true && (!CAQLOBQuestions.Any() || CAQLOBQuestions.Contains(c.Name))))
                    {
                         var comparatorQuestionID = control.QuestionID;
                         foreach (EnableControl enableControl in control.EnableControlList)
                         {
                             if (enableControl.Enable == "True")
                             {
                                 var boundScreenControl = QuestionSet.Where(frm => frm.Filename == enableControl.BoundScreen).SelectMany(frm => frm.ControlList).SingleOrDefault(cont => cont.Name == enableControl.BoundScreenControl);
                                 if (boundScreenControl != null)
                                 {
                                     var EnablementCriteriaSetID = EnablementInsert(comparatorQuestionID, boundScreenControl, enableControl);
                                 }
                             }
                             //Enable == "False":
                             else
                             {
                                var boundScreenControl = QuestionSet.Where(frm => frm.Filename == enableControl.BoundScreen).SelectMany(frm => frm.ControlList).SingleOrDefault(cont => cont.Name == enableControl.BoundScreenControl);
                                if (boundScreenControl != null)
                                {
                                    //Switch the operators as TGSL is disabling based on value, so CAQ needs to enable if the opposite is true
                                    if (enableControl.Operator == "==")
                                    {
                                        enableControl.Operator = "!=";
                                    }
                                    if (enableControl.Operator == "<")
                                    {
                                        enableControl.Operator = ">=";
                                    }
                                    if (enableControl.Operator == ">")
                                    {
                                        enableControl.Operator = "<=";
                                    }
                                    var EnablementCriteriaSetID = EnablementInsert(comparatorQuestionID, boundScreenControl, enableControl);
                                }
                             }
                        }
                    }
                }
                
                
                //Parent Enablement
                foreach (Form form in QuestionSet.Where(frm => frm.ShowOnWebsite == true && CAQLOBSections.Contains(frm.Filename)))
                {
                    if (form.ParentControl?.AnswerTypeID == 4)
                    { 
                        foreach (Control control in form.ControlList.Where(c => c.DisplayOnWebpage == true && (!CAQLOBQuestions.Any() || CAQLOBQuestions.Contains(c.Name))))
                        {
                            if (control.ParentQuestionID != null)
                            {
                                EnablementInsert(control.ParentQuestionID, control);
                            }
                        }
                    }
                }


                ProductPolicyAnswerTablesInsert(questionSetID);
              //  throw Instantiate<System.Data.SqlClient.SqlException>();
                Tran.Commit();
            }
            catch (SqlException ex)
            {
                Console.WriteLine(ex.Message);
                Tran.Rollback();
            }
        }

        public void Dispose()
        {
            SqlConnection.Close();
            SqlConnection.Dispose();
            SqlConnection = null;
        }

        public static T ConvertFromDBVal<T>(object obj)
        {
            if (obj == null || obj == DBNull.Value)
            {
                return default(T); // returns the default value for the type
            }
            else
            {
                return (T)obj;
            }
        }

        //For debugging SQL
        public static T Instantiate<T>() where T : class
        {
            return System.Runtime.Serialization.FormatterServices.GetUninitializedObject(typeof(T)) as T;
        }

    }
}
