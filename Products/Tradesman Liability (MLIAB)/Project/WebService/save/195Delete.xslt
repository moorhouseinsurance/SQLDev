<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tes="http://www.wisl.co.uk/schemas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

 <xsl:param name="pPolicyDetailsID" select="''" />
 <xsl:param name="pHistoryID" select="''" />

 <xsl:template name="screens" match="/">

    <ArrayOfStcStoredProcedure>

        <stcStoredProcedure/>

        <stcStoredProcedure>
	        <strName>USER_DELETE_MLIAB</strName>
	        <udtParameters>
		        <stcParameter />
		        <stcParameter>
			        <strName>@POLICY_DETAILS_ID</strName>
			        <objValue xsi:type="xsd:string"><xsl:value-of select="$pPolicyDetailsID"/></objValue>
		        </stcParameter>
		        <stcParameter>
			        <strName>@HISTORY_ID</strName>
			        <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
		        </stcParameter>
	        </udtParameters>
        </stcStoredProcedure>

    </ArrayOfStcStoredProcedure>
</xsl:template>
</xsl:stylesheet>
