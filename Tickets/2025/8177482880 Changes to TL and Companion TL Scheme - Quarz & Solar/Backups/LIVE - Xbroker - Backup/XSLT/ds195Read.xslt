<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.wisl.co.uk/schemas" xmlns:ds="http://tempuri.org/dsCustomer.xsd">

 <xsl:param name="pPolicy_Details_ID" select="''"></xsl:param>
 <xsl:template name="screens" match="/">
     <xsl:element name="screens">
         <xsl:call-template name="frmTrdDtail.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmCInfo.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmBusSupp.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmClmSum.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmAssump.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmCAR.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmAccIncom.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
         <xsl:call-template name="frmProfIndm.tst">
             <xsl:with-param name="pParentID" select="$pPolicy_Details_ID" />
         </xsl:call-template>
     </xsl:element>
 </xsl:template>

<xsl:template name="frmTrdDtail.tst" match="ds:USER_MLIAB_TRDDTAIL">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_TRDDTAIL[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmTrdDtail.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_TRDDTAIL_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtWorkshopPercent</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:WORKSHOPPERCENT)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:WORKSHOPPERCENT" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWorkshop</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:WORKSHOP='1' or ds:WORKSHOP='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmpsUsing</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:EMPSUSING)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:EMPSUSING" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optFixedMachinery</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:FIXEDMACHINERY='1' or ds:FIXEDMACHINERY='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCavityWall</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:CAVITYWALL='1' or ds:CAVITYWALL='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optSolvent</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:SOLVENT='1' or ds:SOLVENT='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWaterproofing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:WATERPROOFING='1' or ds:WATERPROOFING='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRoofing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:ROOFING='1' or ds:ROOFING='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optVentilation</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:VENTILATION='1' or ds:VENTILATION='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCorgiReg</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:CORGIREG='1' or ds:CORGIREG='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRoadSurfacing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:ROADSURFACING='1' or ds:ROADSURFACING='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPaving</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:PAVING='1' or ds:PAVING='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxDepth</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:MAXDEPTH_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:MAXDEPTH_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboSecondaryRisk</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SECONDARYRISK_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:SECONDARYRISK_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPrimaryRisk</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:PRIMARYRISK_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:PRIMARYRISK_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPresentInsurer</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:PRESENTINSURER_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:PRESENTINSURER_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">dtpCoverStartDate</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:COVERSTARTDATE)=''">1899-12-31T00:00:00</xsl:when><xsl:otherwise><xsl:value-of select="ds:COVERSTARTDATE" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPhase</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:PHASE='1' or ds:PHASE='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optEfficacyCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:EFFICACYCOVER='1' or ds:EFFICACYCOVER='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtHistoryID</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:HISTORYID" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtPolicyDetailsID</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:POLICYDETAILSID" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmCInfo.tst" match="ds:USER_MLIAB_CINFO">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_CINFO[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmCInfo.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_CINFO_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optWrittenRA</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:WRITTENRA='1' or ds:WRITTENRA='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHealthSafety</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:HEALTHSAFETY='1' or ds:HEALTHSAFETY='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboWhichAssoci</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:WHICHASSOCI_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:WHICHASSOCI_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optAssociMem</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:ASSOCIMEM='1' or ds:ASSOCIMEM='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxHeight</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:MAXHEIGHT_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:MAXHEIGHT_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtHeatPercent</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:HEATPERCENT)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:HEATPERCENT" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHeat</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:HEAT='1' or ds:HEAT='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWorkSoley</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:WORKSOLEY='1' or ds:WORKSOLEY='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdPsDrawings</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:PSDRAWINGS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:PSDRAWINGS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdSupervisorWR</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:SUPERVISORWR)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:SUPERVISORWR" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdLabourWR</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:LABOURWR)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:LABOURWR" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdBonaFideWR</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:BONAFIDEWR)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:BONAFIDEWR" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdAnnualTurnover</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:ANNUALTURNOVER)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:ANNUALTURNOVER" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtYrsExp</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:YRSEXP)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:YRSEXP" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtyrs</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:YRS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:YRS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtYrEstablished</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:YRESTABLISHED)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:YRESTABLISHED" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtNonManualEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:NONMANUALEMPS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:NONMANUALEMPS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManualEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:MANUALEMPS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:MANUALEMPS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtNonManuDirec</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:NONMANUDIREC)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:NONMANUDIREC" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManualDirectors</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:MANUALDIRECTORS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:MANUALDIRECTORS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTotalPandP</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:TOTALPANDP)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:TOTALPANDP" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optManualWork</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:MANUALWORK='1' or ds:MANUALWORK='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboCompanyStatus</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:COMPANYSTATUS_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:COMPANYSTATUS_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPubLiabLimit</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:PUBLIABLIMIT_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:PUBLIABLIMIT_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdClericalPAYE</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:CLERICALPAYE)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:CLERICALPAYE" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdManualPAYE</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:MANUALPAYE)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:MANUALPAYE" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboToolValue</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:TOOLVALUE_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:TOOLVALUE_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optToolCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:TOOLCOVER='1' or ds:TOOLCOVER='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManDays</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:MANDAYS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:MANDAYS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optTempInsurance</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:TEMPINSURANCE='1' or ds:TEMPINSURANCE='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTotalEmployees</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:TOTALEMPLOYEES)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:TOTALEMPLOYEES" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtERNRef</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:ERNREF" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optSubsidYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:SUBSIDYN='1' or ds:SUBSIDYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optincludeYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:INCLUDEYN='1' or ds:INCLUDEYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">chkERNExempt</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:ERNEXEMPT='1' or ds:ERNEXEMPT='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">Optemployeetool</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:EMPLOYEETOOL='1' or ds:EMPLOYEETOOL='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmPandP.tst">
             <xsl:with-param name="pParentID" select="ds:MLIAB_CINFO_ID" />
         </xsl:call-template>

         <xsl:call-template name="frmSubsid.tst">
             <xsl:with-param name="pParentID" select="ds:MLIAB_CINFO_ID" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmPandP.tst" match="ds:USER_MLIAB_PANDP">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_PANDP[ds:MLIAB_CINFO_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmPandP.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_PANDP_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:MLIAB_CINFO_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboStatus</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:STATUS_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:STATUS_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSurname</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SURNAME" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtForename</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:FORENAME" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboTitle</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:TITLE_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:TITLE_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmBusSupp.tst" match="ds:USER_MLIAB_BUSSUPP">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_BUSSUPP[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmBusSupp.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_BUSSUPP_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtHandSDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:HANDSDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHandS</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:HANDS='1' or ds:HANDS='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTribunalDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:TRIBUNALDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optTribunal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:TRIBUNAL='1' or ds:TRIBUNAL='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtDiscussDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:DISCUSSDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optDiscussions</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:DISCUSSIONS='1' or ds:DISCUSSIONS='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtReguDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:REGUDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRegulations</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:REGULATIONS='1' or ds:REGULATIONS='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtRedunDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:REDUNDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRedundancies</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:REDUNDANCIES='1' or ds:REDUNDANCIES='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmpDisDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:EMPDISDETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optEmpDispute</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:EMPDISPUTE='1' or ds:EMPDISPUTE='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:EMPS)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:EMPS" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optBusSuppCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:BUSSUPPCOVER='1' or ds:BUSSUPPCOVER='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmClmSum.tst" match="ds:USER_MLIAB_CLMSUM">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_CLMSUM[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmClmSum.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_CLMSUM_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optIncidents</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:INCIDENTS='1' or ds:INCIDENTS='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmClmDtail.tst">
             <xsl:with-param name="pParentID" select="ds:MLIAB_CLMSUM_ID" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmClmDtail.tst" match="ds:USER_MLIAB_CLMDTAIL">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_CLMDTAIL[ds:MLIAB_CLMSUM_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmClmDtail.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_CLMDTAIL_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:MLIAB_CLMSUM_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:DETAILS" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdOutstanding</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:OUTSTANDING)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:OUTSTANDING" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdPaid</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:PAID)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:PAID" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">mskDate</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:DATE)=''">1899-12-31T00:00:00</xsl:when><xsl:otherwise><xsl:value-of select="ds:DATE" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboType</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:TYPE_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:TYPE_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmAssump.tst" match="ds:USER_MLIAB_ASSUMP">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_ASSUMP[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmAssump.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_ASSUMP_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboDemolition</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:DEMOLITION_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:DEMOLITION_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboConvicted</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:CONVICTED_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:CONVICTED_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboBankrupt</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:BANKRUPT_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:BANKRUPT_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboRefused</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:REFUSED_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:REFUSED_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboAsbestos</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:ASBESTOS_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:ASBESTOS_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPowerStations</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:POWERSTATIONS_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:POWERSTATIONS_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboAircraft</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:AIRCRAFT_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:AIRCRAFT_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPPE</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:PPE_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:PPE_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboStaffTraining</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:STAFFTRAINING_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:STAFFTRAINING_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmSubsid.tst" match="ds:USER_MLIAB_SUBSID">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_SUBSID[ds:MLIAB_CINFO_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmSubsid.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_SUBSID_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:MLIAB_CINFO_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboSubsidInsurer</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SUBSIDINSURER_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:SUBSIDINSURER_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSubsidERN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SUBSIDERN" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSubsidName</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SUBSIDNAME" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmCAR.tst" match="ds:USER_MLIAB_CAR">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_CAR[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmCAR.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_CAR_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optcoverhireplant</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:COVERHIREPLANT='1' or ds:COVERHIREPLANT='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optcoverplant</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:COVERPLANT='1' or ds:COVERPLANT='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optContractsworks</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:CONTRACTSWORKS='1' or ds:CONTRACTSWORKS='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxHirPlantVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:MAXHIRPLANTVAL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:MAXHIRPLANTVAL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboHirPlantMacVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:HIRPLANTMACVAL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:HIRPLANTMACVAL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboHireChargeVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:HIRECHARGEVAL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:HIRECHARGEVAL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboOwnPlantMacVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:OWNPLANTMACVAL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:OWNPLANTMACVAL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxContractVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:MAXCONTRACTVAL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:MAXCONTRACTVAL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmAccIncom.tst" match="ds:USER_MLIAB_ACCINCOM">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_ACCINCOM[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmAccIncom.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_ACCINCOM_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboAccidentCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:ACCIDENTCOVER_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:ACCIDENTCOVER_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCoverYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:COVERYN='1' or ds:COVERYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboIncomeCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:INCOMECOVER_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:INCOMECOVER_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtPeopleNum</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:PEOPLENUM)=''">0</xsl:when><xsl:otherwise><xsl:value-of select="ds:PEOPLENUM" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmPAPeople.tst">
             <xsl:with-param name="pParentID" select="ds:MLIAB_ACCINCOM_ID" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmPAPeople.tst" match="ds:USER_MLIAB_PAPEOPLE">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_PAPEOPLE[ds:MLIAB_ACCINCOM_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmPAPeople.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_PAPEOPLE_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:MLIAB_ACCINCOM_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optUKResidentYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:UKRESIDENTYN='1' or ds:UKRESIDENTYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">mskDateOfBirth</xsl:attribute>
                 <xsl:element name="value"><xsl:choose><xsl:when test="normalize-space(ds:DATEOFBIRTH)=''">1899-12-31T00:00:00</xsl:when><xsl:otherwise><xsl:value-of select="ds:DATEOFBIRTH" /></xsl:otherwise></xsl:choose></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSurname</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:SURNAME" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtForenames</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:FORENAMES" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboTitle</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:TITLE_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:TITLE_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmProfIndm.tst" match="ds:USER_MLIAB_PROFINDM">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//ds:USER_MLIAB_PROFINDM[ds:POLICY_DETAILS_ID=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmProfIndm.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="ds:MLIAB_PROFINDM_ID" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="ds:POLICY_DETAILS_ID" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboPILevel</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ds:PILEVEL_ID" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ds:PILEVEL_DEBUG" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPIYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:PIYN='1' or ds:PIYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optDesignYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="number(boolean(ds:DESIGNYN='1' or ds:DESIGNYN='true'))" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
