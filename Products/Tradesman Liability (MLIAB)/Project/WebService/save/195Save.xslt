<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tes="http://www.wisl.co.uk/schemas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:func="http://www.wisl.co.uk/functions">

<xsl:import href="../../../../core/functions.xslt" />

 <xsl:param name="pPolicyDetailsID" select="''" />
 <xsl:param name="pHistoryID" select="''" />

 <xsl:template name="screens" match="/">

    <ArrayOfStcStoredProcedure>

        <stcStoredProcedure/>

         <stcStoredProcedure>
             <strName>SP_BO_SAVE_POLICY_LINK</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@cipPolicyLinkID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="func:getguid()"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@cipInsuredPartyID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:client/@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@cipInsuredPartyHistoryID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="tes:client/@hID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@cpdPolicyDetailsID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pPolicyDetailsID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@cpdHistoryID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

        <xsl:call-template name="frmTrdDtail.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmCInfo.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmBusSupp.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmClmSum.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmAssump.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmCAR.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmAccIncom.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

        <xsl:call-template name="frmProfIndm.tst">
	        <xsl:with-param name="pParentID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
	        <xsl:with-param name="pHistoryID" select="$pHistoryID" />
        </xsl:call-template>

    </ArrayOfStcStoredProcedure>
</xsl:template>

 <xsl:template name="frmTrdDtail.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmTrdDtail.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_TRDDTAIL</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_TRDDTAIL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WORKSHOPPERCENT</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtWorkshopPercent']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WORKSHOP</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optWorkshop']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EMPSUSING</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtEmpsUsing']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@FIXEDMACHINERY</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optFixedMachinery']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@CAVITYWALL</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optCavityWall']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SOLVENT</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optSolvent']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WATERPROOFING</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optWaterproofing']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ROOFING</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optRoofing']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@VENTILATION</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optVentilation']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@CORGIREG</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optCorgiReg']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ROADSURFACING</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optRoadSurfacing']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PAVING</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optPaving']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MAXDEPTH_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboMaxDepth']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SECONDARYRISK_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboSecondaryRisk']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PRIMARYRISK_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPrimaryRisk']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PRESENTINSURER_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPresentInsurer']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@COVERSTARTDATE</strName>
                     <xsl:if test="tes:controls/tes:control[@name='dtpCoverStartDate']/tes:value!=''">
                         <objValue xsi:type="xsd:dateTime"><xsl:value-of select="tes:controls/tes:control[@name='dtpCoverStartDate']/tes:value"/></objValue>
                     </xsl:if>
                     <xsl:if test="tes:controls/tes:control[@name='dtpCoverStartDate']/tes:value=''">
                         <objValue></objValue>
                     </xsl:if>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PHASE</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optPhase']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EFFICACYCOVER</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optEfficacyCover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORYID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtHistoryID']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICYDETAILSID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtPolicyDetailsID']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ENGINEERING</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optEngineering']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANUFACTURE</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optManufacture']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmCInfo.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmCInfo.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_CINFO</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_CINFO_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WRITTENRA</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optWrittenRA']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HEALTHSAFETY</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optHealthSafety']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WHICHASSOCI_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboWhichAssoci']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ASSOCIMEM</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optAssociMem']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MAXHEIGHT_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboMaxHeight']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HEATPERCENT</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtHeatPercent']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HEAT</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optHeat']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@WORKSOLEY</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optWorkSoley']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PSDRAWINGS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdPsDrawings']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SUPERVISORWR</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdSupervisorWR']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@LABOURWR</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdLabourWR']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@BONAFIDEWR</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdBonaFideWR']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ANNUALTURNOVER</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdAnnualTurnover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@YRSEXP</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtYrsExp']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@YRS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtyrs']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@YRESTABLISHED</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtYrEstablished']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@NONMANUALEMPS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtNonManualEmps']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANUALEMPS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtManualEmps']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@NONMANUDIREC</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtNonManuDirec']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANUALDIRECTORS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtManualDirectors']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TOTALPANDP</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtTotalPandP']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANUALWORK</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optManualWork']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@COMPANYSTATUS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboCompanyStatus']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PUBLIABLIMIT_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPubLiabLimit']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@CLERICALPAYE</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdClericalPAYE']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANUALPAYE</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdManualPAYE']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TOOLVALUE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboToolValue']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TOOLCOVER</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optToolCover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MANDAYS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtManDays']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TEMPINSURANCE</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optTempInsurance']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TOTALEMPLOYEES</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtTotalEmployees']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ERNREF</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtERNRef']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SUBSIDYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optSubsidYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@INCLUDEYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optincludeYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ERNEXEMPT</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='chkERNExempt']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EMPLOYEETOOL</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='Optemployeetool']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

         <xsl:call-template name="frmPandP.tst">
             <xsl:with-param name="pParentID" select="@iD" />
             <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
             <xsl:with-param name="pHistoryID" select="$pHistoryID" />
         </xsl:call-template>

         <xsl:call-template name="frmSubsid.tst">
             <xsl:with-param name="pParentID" select="@iD" />
             <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
             <xsl:with-param name="pHistoryID" select="$pHistoryID" />
         </xsl:call-template>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmPandP.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmPandP.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_PANDP</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_PANDP_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MLIAB_CINFO_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@STATUS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboStatus']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SURNAME</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtSurname']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@FORENAME</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtForename']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TITLE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboTitle']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmBusSupp.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmBusSupp.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_BUSSUPP</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_BUSSUPP_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HANDSDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtHandSDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HANDS</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optHandS']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TRIBUNALDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtTribunalDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TRIBUNAL</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optTribunal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DISCUSSDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtDiscussDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DISCUSSIONS</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optDiscussions']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@REGUDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtReguDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@REGULATIONS</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optRegulations']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@REDUNDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtRedunDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@REDUNDANCIES</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optRedundancies']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EMPDISDETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtEmpDisDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EMPDISPUTE</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optEmpDispute']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@EMPS</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtEmps']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@BUSSUPPCOVER</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optBusSuppCover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmClmSum.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmClmSum.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_CLMSUM</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_CLMSUM_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@INCIDENTS</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optIncidents']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

         <xsl:call-template name="frmClmDtail.tst">
             <xsl:with-param name="pParentID" select="@iD" />
             <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
             <xsl:with-param name="pHistoryID" select="$pHistoryID" />
         </xsl:call-template>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmClmDtail.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmClmDtail.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_CLMDTAIL</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_CLMDTAIL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MLIAB_CLMSUM_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DETAILS</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtDetails']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@OUTSTANDING</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdOutstanding']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PAID</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='cfdPaid']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DATE</strName>
                     <xsl:if test="tes:controls/tes:control[@name='mskDate']/tes:value!=''">
                         <objValue xsi:type="xsd:dateTime"><xsl:value-of select="tes:controls/tes:control[@name='mskDate']/tes:value"/></objValue>
                     </xsl:if>
                     <xsl:if test="tes:controls/tes:control[@name='mskDate']/tes:value=''">
                         <objValue></objValue>
                     </xsl:if>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TYPE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboType']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmAssump.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmAssump.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_ASSUMP</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_ASSUMP_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DEMOLITION_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboDemolition']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@CONVICTED_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboConvicted']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@BANKRUPT_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboBankrupt']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@REFUSED_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboRefused']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ASBESTOS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboAsbestos']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POWERSTATIONS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPowerStations']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@AIRCRAFT_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboAircraft']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PPE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPPE']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@STAFFTRAINING_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboStaffTraining']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmSubsid.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmSubsid.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_SUBSID</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_SUBSID_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MLIAB_CINFO_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SUBSIDINSURER_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboSubsidInsurer']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SUBSIDERN</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtSubsidERN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SUBSIDNAME</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtSubsidName']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmCAR.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmCAR.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_CAR</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_CAR_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@COVERHIREPLANT</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optcoverhireplant']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@COVERPLANT</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optcoverplant']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@CONTRACTSWORKS</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optContractsworks']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MAXHIRPLANTVAL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboMaxHirPlantVal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HIRPLANTMACVAL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboHirPlantMacVal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HIRECHARGEVAL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboHireChargeVal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@OWNPLANTMACVAL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboOwnPlantMacVal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MAXCONTRACTVAL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboMaxContractVal']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmAccIncom.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmAccIncom.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_ACCINCOM</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_ACCINCOM_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@ACCIDENTCOVER_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboAccidentCover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@COVERYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optCoverYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@INCOMECOVER_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboIncomeCover']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PEOPLENUM</strName>
                     <objValue xsi:type="xsd:decimal"><xsl:value-of select="tes:controls/tes:control[@name='txtPeopleNum']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

         <xsl:call-template name="frmPAPeople.tst">
             <xsl:with-param name="pParentID" select="@iD" />
             <xsl:with-param name="pPolicyDetailsID" select="$pPolicyDetailsID" />
             <xsl:with-param name="pHistoryID" select="$pHistoryID" />
         </xsl:call-template>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmPAPeople.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmPAPeople.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_PAPEOPLE</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_PAPEOPLE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@MLIAB_ACCINCOM_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@UKRESIDENTYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optUKResidentYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DATEOFBIRTH</strName>
                     <xsl:if test="tes:controls/tes:control[@name='mskDateOfBirth']/tes:value!=''">
                         <objValue xsi:type="xsd:dateTime"><xsl:value-of select="tes:controls/tes:control[@name='mskDateOfBirth']/tes:value"/></objValue>
                     </xsl:if>
                     <xsl:if test="tes:controls/tes:control[@name='mskDateOfBirth']/tes:value=''">
                         <objValue></objValue>
                     </xsl:if>
                 </stcParameter>
                 <stcParameter>
                     <strName>@SURNAME</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtSurname']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@FORENAMES</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='txtForenames']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@TITLE_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboTitle']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

 <xsl:template name="frmProfIndm.tst">
     <xsl:param name="pParentID" select="''" />
     <xsl:param name="pPolicyDetailsID" select="''" />
     <xsl:param name="pHistoryID" select="''" />
     <xsl:for-each select="//tes:screen[@name='frmProfIndm.tst' and @parentID=$pParentID]">
         <stcStoredProcedure>
             <strName>USER_SAVE_MLIAB_PROFINDM</strName>
             <udtParameters>
                 <stcParameter />
                 <stcParameter>
                     <strName>@MLIAB_PROFINDM_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="@iD"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@HISTORY_ID</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="$pHistoryID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@POLICY_DETAILS_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="$pParentID"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PILEVEL_ID</strName>
                     <objValue xsi:type="xsd:string"><xsl:value-of select="tes:controls/tes:control[@name='cboPILevel']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@PIYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optPIYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@DESIGNYN</strName>
                     <objValue xsi:type="xsd:boolean"><xsl:value-of select="tes:controls/tes:control[@name='optDesignYN']/tes:value"/></objValue>
                 </stcParameter>
                 <stcParameter>
                     <strName>@USERINSTANCE</strName>
                     <objValue xsi:type="xsd:int"><xsl:value-of select="@index"/></objValue>
                 </stcParameter>
             </udtParameters>
         </stcStoredProcedure>

     </xsl:for-each>
 </xsl:template>

</xsl:stylesheet>
