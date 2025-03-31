
using static TGSLLOBSchemeBuilder.Configuration;
namespace TGSLLOBSchemeBuilder
{
    class Program
    {
        static void Main(string[] args)
        {
            QuestionSet questionSet = new QuestionSet();
            questionSet.Read();

            if (Execute.CAQ)
            {
                CAQLOBWriter cAQLOBWriter = new CAQLOBWriter { QuestionSet = questionSet };
                cAQLOBWriter.Write();
            }
            if (Execute.WPD)
            {
                WPDWriter wPDWriter = new WPDWriter { QuestionSet = questionSet };
                wPDWriter.Write();
            }
            if (Execute.Calculator)
            {
                SQLLOBWriter sQLLOBWriter = new SQLLOBWriter { QuestionSet = questionSet };
                sQLLOBWriter.Write();
                
            }
            if (Execute.XBroker)
            {
                XBrokerWriter xBrokerWriter = new XBrokerWriter { QuestionSet = questionSet };
                xBrokerWriter.Write();
            }
        }
    }
}
