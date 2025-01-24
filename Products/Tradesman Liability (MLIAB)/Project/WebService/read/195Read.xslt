<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.wisl.co.uk/schemas">

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

<xsl:template name="frmTrdDtail.tst" match="frmTrdDtail">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmTrdDtail[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmTrdDtail.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_trddtail_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtWorkshopPercent</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="workshoppercent" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWorkshop</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="workshop" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmpsUsing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="empsusing" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optFixedMachinery</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="fixedmachinery" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCavityWall</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="cavitywall" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optSolvent</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="solvent" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWaterproofing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="waterproofing" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRoofing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="roofing" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optVentilation</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ventilation" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCorgiReg</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="corgireg" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRoadSurfacing</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="roadsurfacing" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPaving</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="paving" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxDepth</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="maxdepth_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="maxdepth_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboSecondaryRisk</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="secondaryrisk_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="secondaryrisk_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPrimaryRisk</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="primaryrisk_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="primaryrisk_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPresentInsurer</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="presentinsurer_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="presentinsurer_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">dtpCoverStartDate</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="coverstartdate" /></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPhase</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="phase" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optEfficacyCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="efficacycover" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtHistoryID</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="historyid" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtPolicyDetailsID</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="policydetailsid" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optEngineering</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="engineering" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optManufacture</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="manufacture" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmCInfo.tst" match="frmCInfo">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmCInfo[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmCInfo.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_cinfo_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optWrittenRA</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="writtenra" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHealthSafety</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="healthsafety" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboWhichAssoci</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="whichassoci_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="whichassoci_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optAssociMem</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="associmem" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxHeight</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="maxheight_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="maxheight_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtHeatPercent</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="heatpercent" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHeat</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="heat" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optWorkSoley</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="worksoley" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdPsDrawings</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="psdrawings" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdSupervisorWR</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="supervisorwr" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdLabourWR</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="labourwr" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdBonaFideWR</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="bonafidewr" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdAnnualTurnover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="annualturnover" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtYrsExp</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="yrsexp" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtyrs</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="yrs" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtYrEstablished</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="yrestablished" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtNonManualEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="nonmanualemps" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManualEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="manualemps" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtNonManuDirec</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="nonmanudirec" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManualDirectors</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="manualdirectors" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTotalPandP</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="totalpandp" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optManualWork</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="manualwork" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboCompanyStatus</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="companystatus_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="companystatus_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPubLiabLimit</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="publiablimit_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="publiablimit_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdClericalPAYE</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="clericalpaye" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdManualPAYE</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="manualpaye" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboToolValue</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="toolvalue_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="toolvalue_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optToolCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="toolcover" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtManDays</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="mandays" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optTempInsurance</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="tempinsurance" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTotalEmployees</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="totalemployees" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtERNRef</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ernref" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optSubsidYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="subsidyn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optincludeYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="includeyn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">chkERNExempt</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ernexempt" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">Optemployeetool</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="employeetool" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmPandP.tst">
             <xsl:with-param name="pParentID" select="mliab_cinfo_id" />
         </xsl:call-template>

         <xsl:call-template name="frmSubsid.tst">
             <xsl:with-param name="pParentID" select="mliab_cinfo_id" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmPandP.tst" match="frmPandP">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmPandP[mliab_cinfo_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmPandP.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_pandp_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="mliab_cinfo_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboStatus</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="status_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="status_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSurname</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="surname" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtForename</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="forename" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboTitle</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="title_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="title_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmBusSupp.tst" match="frmBusSupp">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmBusSupp[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmBusSupp.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_bussupp_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtHandSDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="handsdetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optHandS</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="hands" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtTribunalDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="tribunaldetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optTribunal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="tribunal" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtDiscussDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="discussdetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optDiscussions</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="discussions" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtReguDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="regudetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRegulations</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="regulations" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtRedunDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="redundetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optRedundancies</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="redundancies" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmpDisDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="empdisdetails" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optEmpDispute</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="empdispute" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtEmps</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="emps" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optBusSuppCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="bussuppcover" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmClmSum.tst" match="frmClmSum">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmClmSum[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmClmSum.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_clmsum_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optIncidents</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="incidents" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmClmDtail.tst">
             <xsl:with-param name="pParentID" select="mliab_clmsum_id" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmClmDtail.tst" match="frmClmDtail">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmClmDtail[mliab_clmsum_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmClmDtail.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_clmdtail_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="mliab_clmsum_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">txtDetails</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="details" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdOutstanding</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="outstanding" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cfdPaid</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="paid" /></xsl:element>
                 <xsl:element name="dataType">c</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">mskDate</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="date" /></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboType</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="type_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="type_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmAssump.tst" match="frmAssump">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmAssump[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmAssump.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_assump_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboDemolition</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="demolition_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="demolition_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboConvicted</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="convicted_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="convicted_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboBankrupt</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="bankrupt_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="bankrupt_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboRefused</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="refused_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="refused_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboAsbestos</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="asbestos_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="asbestos_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPowerStations</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="powerstations_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="powerstations_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboAircraft</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="aircraft_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="aircraft_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboPPE</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ppe_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ppe_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboStaffTraining</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="stafftraining_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="stafftraining_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmSubsid.tst" match="frmSubsid">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmSubsid[mliab_cinfo_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmSubsid.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_subsid_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="mliab_cinfo_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboSubsidInsurer</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="subsidinsurer_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="subsidinsurer_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSubsidERN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="subsidern" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSubsidName</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="subsidname" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmCAR.tst" match="frmCAR">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmCAR[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmCAR.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_car_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optcoverhireplant</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="coverhireplant" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optcoverplant</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="coverplant" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optContractsworks</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="contractsworks" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxHirPlantVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="maxhirplantval_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="maxhirplantval_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboHirPlantMacVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="hirplantmacval_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="hirplantmacval_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboHireChargeVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="hirechargeval_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="hirechargeval_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboOwnPlantMacVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ownplantmacval_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="ownplantmacval_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboMaxContractVal</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="maxcontractval_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="maxcontractval_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmAccIncom.tst" match="frmAccIncom">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmAccIncom[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmAccIncom.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_accincom_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboAccidentCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="accidentcover_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="accidentcover_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optCoverYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="coveryn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboIncomeCover</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="incomecover_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="incomecover_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtPeopleNum</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="peoplenum" /></xsl:element>
                 <xsl:element name="dataType">n</xsl:element>
             </control>
         </controls>

         <xsl:call-template name="frmPAPeople.tst">
             <xsl:with-param name="pParentID" select="mliab_accincom_id" />
         </xsl:call-template>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmPAPeople.tst" match="frmPAPeople">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmPAPeople[mliab_accincom_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmPAPeople.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_papeople_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="mliab_accincom_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">optUKResidentYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="ukresidentyn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">mskDateOfBirth</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="dateofbirth" /></xsl:element>
                 <xsl:element name="dataType">d</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtSurname</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="surname" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">txtForenames</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="forenames" /></xsl:element>
                 <xsl:element name="dataType">t</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">cboTitle</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="title_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="title_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

<xsl:template name="frmProfIndm.tst" match="frmProfIndm">
<xsl:param name="pParentID" select="''"></xsl:param>
 <xsl:for-each select="//frmProfIndm[policy_details_id=$pParentID]">
     <screen>
         <xsl:attribute name="name">frmProfIndm.tst</xsl:attribute>
         <xsl:attribute name="index"><xsl:value-of select="position()" /></xsl:attribute>
         <xsl:attribute name="iD"><xsl:value-of select="mliab_profindm_id" /></xsl:attribute>
         <xsl:attribute name="parentID"><xsl:value-of select="policy_details_id" /></xsl:attribute>
         <xsl:attribute name="linkID">0</xsl:attribute>
         <controls>
             <control>
                 <xsl:attribute name="name">cboPILevel</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="pilevel_id" /></xsl:element>
                 <xsl:element name="comboDesc"><xsl:value-of select="pilevel_debug" /></xsl:element>
                 <xsl:element name="dataType">l</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optPIYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="piyn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
             <control>
                 <xsl:attribute name="name">optDesignYN</xsl:attribute>
                 <xsl:element name="value"><xsl:value-of select="designyn" /></xsl:element>
                 <xsl:element name="dataType">b</xsl:element>
             </control>
         </controls>
     </screen>
 </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
