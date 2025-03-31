@ECHO OFF
SET ProjectName=MMISC
SET ProductTypeId=344
SET Server=MHGTGSL02

SET TCASDir=\\moorhouse.hosted\Moorhouse\TCAS\
SET TCASProject=%TCASDir%Projects\%ProjectName%\
SET TCASStylesheetsDir=%TCASDir%\Stylesheets\%ProjectName%\
SET TCASTemplatesDir=%TCASDir%\Templates\%ProjectName%\

SET wwwrootDir=\\%Server%\c$\inetpub\wwwroot\
SET InetpubRootTempDir=%wwwrootDir%Templates\
SET InetpubForOutcomeFileDir=%wwwrootDir%Stylesheets\Outcome\
SET InetpubForStyleSFilesDir=%wwwrootDir%Stylesheets\Client\
SET InetpubForXsd-XmlFilesDir=%wwwrootDir%XML\user\

ECHO Begin Copy...
xcopy %TCASProject%* %TCASStylesheetsDir%  /R /E /Y
xcopy %TCASProject%* %TCASTemplatesDir%  /R /E /Y

xcopy %TCASProject%* %InetpubRootTempDir%%ProjectName%\ /R /E /Y
xcopy %TCASProject%webservice\outcome\outcome%ProductTypeId%*.xslt %InetpubForOutcomeFileDir% /Y
xcopy %TCASProject%webservice\read\%ProductTypeId%read.xslt %InetpubForStyleSFilesDir%read\policy\user /Y
xcopy %TCASProject%webservice\read\ds%ProductTypeId%read.xslt %InetpubForStyleSFilesDir%read\policy\user /Y
xcopy %TCASProject%webservice\save\%ProductTypeId%delete.xslt %InetpubForStyleSFilesDir%save\policy\user /Y
xcopy %TCASProject%webservice\save\%ProductTypeId%save.xslt %InetpubForStyleSFilesDir%save\policy\user /Y
xcopy %TCASProject%webservice\xml\%ProductTypeId%read.xml %InetpubForXsd-XmlFilesDir% /Y
xcopy %TCASProject%webservice\xml\%ProductTypeId%schema1.xsd %InetpubForXsd-XmlFilesDir% /Y
ECHO All Done, Run SQL Script.
