<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:outcome="http://www.wisl.co.uk/schemas" xmlns:func="http://www.wisl.co.uk/core/functions">

	<xsl:import href="outcomeClient.xslt" />
	<xsl:import href="outcomePolicy.xslt" />
	<xsl:import href="outcomeAddon.xslt" />
	<xsl:import href="outcomeclaims.xslt" />
	<xsl:import href="../core/format.xslt" />

	<xsl:template name="outcome195" match="/outcome:client">

		<xsl:param name="QuoteStage"/>
		<xsl:param name="AgentName"/>
		<xsl:variable name="vPolicyDetailsID" select="outcome:policies/outcome:policy/@iD" />

		<System xmlns="http://www.wisl.co.uk/schemas" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.wisl.co.uk/schemas http://www.wisl-test.co.uk/schemas/core/outcome.xsd">
			<Client>
				<xsl:call-template name="outcomeClient">
					<xsl:with-param name="AgentName" select="$AgentName" />
				</xsl:call-template>
				<Policy_Details>
					<xsl:call-template name="outcomePolicy">
						<xsl:with-param name="QuoteStage" select="$QuoteStage" />
					</xsl:call-template>
				    <xsl:call-template name="outcomeAddon" />
				    <xsl:call-template name="outcomeClaims" />
                     <xsl:call-template name="frmTrdDtail.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmCInfo.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmBusSupp.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmClmSum.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmAssump.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmCAR.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmAccIncom.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
                     <xsl:call-template name="frmProfIndm.tst">
                         <xsl:with-param name="pParentID" select="$vPolicyDetailsID" />
                     </xsl:call-template>
				</Policy_Details>
			</Client>
		</System>

	</xsl:template>

     <xsl:template name="frmTrdDtail.tst" match="frmTrdDtail.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmTrdDtail.tst' and @parentID=$pParentID]">
             <UO_MLIAB_TrdDtail xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_TrdDtail_WorkshopPercent><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtWorkshopPercent']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtWorkshopPercent']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_TrdDtail_WorkshopPercent>
                 <UQ_MLIAB_TrdDtail_Workshop><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optWorkshop']/outcome:value='1' or outcome:controls/outcome:control[@name='optWorkshop']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Workshop>
                 <UQ_MLIAB_TrdDtail_EmpsUsing><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtEmpsUsing']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtEmpsUsing']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_TrdDtail_EmpsUsing>
                 <UQ_MLIAB_TrdDtail_FixedMachinery><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optFixedMachinery']/outcome:value='1' or outcome:controls/outcome:control[@name='optFixedMachinery']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_FixedMachinery>
                 <UQ_MLIAB_TrdDtail_CavityWall><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optCavityWall']/outcome:value='1' or outcome:controls/outcome:control[@name='optCavityWall']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_CavityWall>
                 <UQ_MLIAB_TrdDtail_Solvent><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optSolvent']/outcome:value='1' or outcome:controls/outcome:control[@name='optSolvent']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Solvent>
                 <UQ_MLIAB_TrdDtail_Waterproofing><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optWaterproofing']/outcome:value='1' or outcome:controls/outcome:control[@name='optWaterproofing']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Waterproofing>
                 <UQ_MLIAB_TrdDtail_Roofing><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optRoofing']/outcome:value='1' or outcome:controls/outcome:control[@name='optRoofing']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Roofing>
                 <UQ_MLIAB_TrdDtail_Ventilation><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optVentilation']/outcome:value='1' or outcome:controls/outcome:control[@name='optVentilation']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Ventilation>
                 <UQ_MLIAB_TrdDtail_CorgiReg><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optCorgiReg']/outcome:value='1' or outcome:controls/outcome:control[@name='optCorgiReg']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_CorgiReg>
                 <UQ_MLIAB_TrdDtail_RoadSurfacing><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optRoadSurfacing']/outcome:value='1' or outcome:controls/outcome:control[@name='optRoadSurfacing']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_RoadSurfacing>
                 <UQ_MLIAB_TrdDtail_Paving><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optPaving']/outcome:value='1' or outcome:controls/outcome:control[@name='optPaving']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Paving>
<UQ_MLIAB_TrdDtail_MaxDepth><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboMaxDepth']/outcome:value)" /></UQ_MLIAB_TrdDtail_MaxDepth>
<UQ_MLIAB_TrdDtail_SecondaryRisk><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboSecondaryRisk']/outcome:value)" /></UQ_MLIAB_TrdDtail_SecondaryRisk>
<UQ_MLIAB_TrdDtail_PrimaryRisk><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPrimaryRisk']/outcome:value)" /></UQ_MLIAB_TrdDtail_PrimaryRisk>
<UQ_MLIAB_TrdDtail_PresentInsurer><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPresentInsurer']/outcome:value)" /></UQ_MLIAB_TrdDtail_PresentInsurer>
                 <UQ_MLIAB_TrdDtail_CoverStartDate><xsl:value-of select="func:MyDateFormat(outcome:controls/outcome:control[@name='dtpCoverStartDate']/outcome:value,2)" /></UQ_MLIAB_TrdDtail_CoverStartDate>
                 <UQ_MLIAB_TrdDtail_Phase><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optPhase']/outcome:value='1' or outcome:controls/outcome:control[@name='optPhase']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Phase>
                 <UQ_MLIAB_TrdDtail_EfficacyCover><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optEfficacyCover']/outcome:value='1' or outcome:controls/outcome:control[@name='optEfficacyCover']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_EfficacyCover>
                 <UQ_MLIAB_TrdDtail_HistoryID><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtHistoryID']/outcome:value)" /></UQ_MLIAB_TrdDtail_HistoryID>
                 <UQ_MLIAB_TrdDtail_PolicyDetailsID><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtPolicyDetailsID']/outcome:value)" /></UQ_MLIAB_TrdDtail_PolicyDetailsID>
                 <UQ_MLIAB_TrdDtail_Engineering><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optEngineering']/outcome:value='1' or outcome:controls/outcome:control[@name='optEngineering']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Engineering>
                 <UQ_MLIAB_TrdDtail_Manufacture><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optManufacture']/outcome:value='1' or outcome:controls/outcome:control[@name='optManufacture']/outcome:value='true')" /></UQ_MLIAB_TrdDtail_Manufacture>
             </UO_MLIAB_TrdDtail>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmCInfo.tst" match="frmCInfo.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmCInfo.tst' and @parentID=$pParentID]">
             <UO_MLIAB_CInfo xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_CInfo_WrittenRA><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optWrittenRA']/outcome:value='1' or outcome:controls/outcome:control[@name='optWrittenRA']/outcome:value='true')" /></UQ_MLIAB_CInfo_WrittenRA>
                 <UQ_MLIAB_CInfo_HealthSafety><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optHealthSafety']/outcome:value='1' or outcome:controls/outcome:control[@name='optHealthSafety']/outcome:value='true')" /></UQ_MLIAB_CInfo_HealthSafety>
<UQ_MLIAB_CInfo_WhichAssoci><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboWhichAssoci']/outcome:value)" /></UQ_MLIAB_CInfo_WhichAssoci>
                 <UQ_MLIAB_CInfo_AssociMem><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optAssociMem']/outcome:value='1' or outcome:controls/outcome:control[@name='optAssociMem']/outcome:value='true')" /></UQ_MLIAB_CInfo_AssociMem>
<UQ_MLIAB_CInfo_MaxHeight><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboMaxHeight']/outcome:value)" /></UQ_MLIAB_CInfo_MaxHeight>
                 <UQ_MLIAB_CInfo_HeatPercent><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtHeatPercent']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtHeatPercent']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_HeatPercent>
                 <UQ_MLIAB_CInfo_Heat><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optHeat']/outcome:value='1' or outcome:controls/outcome:control[@name='optHeat']/outcome:value='true')" /></UQ_MLIAB_CInfo_Heat>
                 <UQ_MLIAB_CInfo_WorkSoley><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optWorkSoley']/outcome:value='1' or outcome:controls/outcome:control[@name='optWorkSoley']/outcome:value='true')" /></UQ_MLIAB_CInfo_WorkSoley>
                 <UQ_MLIAB_CInfo_PsDrawings><xsl:value-of select="outcome:controls/outcome:control[@name='cfdPsDrawings']/outcome:value" /></UQ_MLIAB_CInfo_PsDrawings>
                 <UQ_MLIAB_CInfo_SupervisorWR><xsl:value-of select="outcome:controls/outcome:control[@name='cfdSupervisorWR']/outcome:value" /></UQ_MLIAB_CInfo_SupervisorWR>
                 <UQ_MLIAB_CInfo_LabourWR><xsl:value-of select="outcome:controls/outcome:control[@name='cfdLabourWR']/outcome:value" /></UQ_MLIAB_CInfo_LabourWR>
                 <UQ_MLIAB_CInfo_BonaFideWR><xsl:value-of select="outcome:controls/outcome:control[@name='cfdBonaFideWR']/outcome:value" /></UQ_MLIAB_CInfo_BonaFideWR>
                 <UQ_MLIAB_CInfo_AnnualTurnover><xsl:value-of select="outcome:controls/outcome:control[@name='cfdAnnualTurnover']/outcome:value" /></UQ_MLIAB_CInfo_AnnualTurnover>
                 <UQ_MLIAB_CInfo_YrsExp><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtYrsExp']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtYrsExp']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_YrsExp>
                 <UQ_MLIAB_CInfo_yrs><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtyrs']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtyrs']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_yrs>
                 <UQ_MLIAB_CInfo_YrEstablished><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtYrEstablished']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtYrEstablished']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_YrEstablished>
                 <UQ_MLIAB_CInfo_NonManualEmps><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtNonManualEmps']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtNonManualEmps']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_NonManualEmps>
                 <UQ_MLIAB_CInfo_ManualEmps><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtManualEmps']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtManualEmps']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_ManualEmps>
                 <UQ_MLIAB_CInfo_NonManuDirec><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtNonManuDirec']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtNonManuDirec']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_NonManuDirec>
                 <UQ_MLIAB_CInfo_ManualDirectors><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtManualDirectors']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtManualDirectors']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_ManualDirectors>
                 <UQ_MLIAB_CInfo_TotalPandP><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtTotalPandP']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtTotalPandP']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_TotalPandP>
                 <UQ_MLIAB_CInfo_ManualWork><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optManualWork']/outcome:value='1' or outcome:controls/outcome:control[@name='optManualWork']/outcome:value='true')" /></UQ_MLIAB_CInfo_ManualWork>
<UQ_MLIAB_CInfo_CompanyStatus><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboCompanyStatus']/outcome:value)" /></UQ_MLIAB_CInfo_CompanyStatus>
<UQ_MLIAB_CInfo_PubLiabLimit><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPubLiabLimit']/outcome:value)" /></UQ_MLIAB_CInfo_PubLiabLimit>
                 <UQ_MLIAB_CInfo_ClericalPAYE><xsl:value-of select="outcome:controls/outcome:control[@name='cfdClericalPAYE']/outcome:value" /></UQ_MLIAB_CInfo_ClericalPAYE>
                 <UQ_MLIAB_CInfo_ManualPAYE><xsl:value-of select="outcome:controls/outcome:control[@name='cfdManualPAYE']/outcome:value" /></UQ_MLIAB_CInfo_ManualPAYE>
<UQ_MLIAB_CInfo_ToolValue><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboToolValue']/outcome:value)" /></UQ_MLIAB_CInfo_ToolValue>
                 <UQ_MLIAB_CInfo_ToolCover><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optToolCover']/outcome:value='1' or outcome:controls/outcome:control[@name='optToolCover']/outcome:value='true')" /></UQ_MLIAB_CInfo_ToolCover>
                 <UQ_MLIAB_CInfo_ManDays><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtManDays']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtManDays']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_ManDays>
                 <UQ_MLIAB_CInfo_TempInsurance><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optTempInsurance']/outcome:value='1' or outcome:controls/outcome:control[@name='optTempInsurance']/outcome:value='true')" /></UQ_MLIAB_CInfo_TempInsurance>
                 <UQ_MLIAB_CInfo_TotalEmployees><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtTotalEmployees']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtTotalEmployees']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_CInfo_TotalEmployees>
                 <UQ_MLIAB_CInfo_ERNRef><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtERNRef']/outcome:value)" /></UQ_MLIAB_CInfo_ERNRef>
                 <UQ_MLIAB_CInfo_SubsidYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optSubsidYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optSubsidYN']/outcome:value='true')" /></UQ_MLIAB_CInfo_SubsidYN>
                 <UQ_MLIAB_CInfo_includeYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optincludeYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optincludeYN']/outcome:value='true')" /></UQ_MLIAB_CInfo_includeYN>
                 <UQ_MLIAB_CInfo_ERNExempt><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='chkERNExempt']/outcome:value='1' or outcome:controls/outcome:control[@name='chkERNExempt']/outcome:value='true')" /></UQ_MLIAB_CInfo_ERNExempt>
                 <UQ_MLIAB_CInfo_employeetool><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='Optemployeetool']/outcome:value='1' or outcome:controls/outcome:control[@name='Optemployeetool']/outcome:value='true')" /></UQ_MLIAB_CInfo_employeetool>

                 <xsl:call-template name="frmPandP.tst">
                     <xsl:with-param name="pParentID" select="@iD" />
                 </xsl:call-template>

                 <xsl:call-template name="frmSubsid.tst">
                     <xsl:with-param name="pParentID" select="@iD" />
                 </xsl:call-template>
             </UO_MLIAB_CInfo>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmPandP.tst" match="frmPandP.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmPandP.tst' and @parentID=$pParentID]">
             <UO_MLIAB_PandP xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
<UQ_MLIAB_PandP_Status><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboStatus']/outcome:value)" /></UQ_MLIAB_PandP_Status>
                 <UQ_MLIAB_PandP_Surname><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtSurname']/outcome:value)" /></UQ_MLIAB_PandP_Surname>
                 <UQ_MLIAB_PandP_Forename><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtForename']/outcome:value)" /></UQ_MLIAB_PandP_Forename>
<UQ_MLIAB_PandP_Title><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboTitle']/outcome:value)" /></UQ_MLIAB_PandP_Title>
             </UO_MLIAB_PandP>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmBusSupp.tst" match="frmBusSupp.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmBusSupp.tst' and @parentID=$pParentID]">
             <UO_MLIAB_BusSupp xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_BusSupp_HandSDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtHandSDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_HandSDetails>
                 <UQ_MLIAB_BusSupp_HandS><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optHandS']/outcome:value='1' or outcome:controls/outcome:control[@name='optHandS']/outcome:value='true')" /></UQ_MLIAB_BusSupp_HandS>
                 <UQ_MLIAB_BusSupp_TribunalDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtTribunalDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_TribunalDetails>
                 <UQ_MLIAB_BusSupp_Tribunal><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optTribunal']/outcome:value='1' or outcome:controls/outcome:control[@name='optTribunal']/outcome:value='true')" /></UQ_MLIAB_BusSupp_Tribunal>
                 <UQ_MLIAB_BusSupp_DiscussDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtDiscussDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_DiscussDetails>
                 <UQ_MLIAB_BusSupp_Discussions><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optDiscussions']/outcome:value='1' or outcome:controls/outcome:control[@name='optDiscussions']/outcome:value='true')" /></UQ_MLIAB_BusSupp_Discussions>
                 <UQ_MLIAB_BusSupp_ReguDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtReguDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_ReguDetails>
                 <UQ_MLIAB_BusSupp_Regulations><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optRegulations']/outcome:value='1' or outcome:controls/outcome:control[@name='optRegulations']/outcome:value='true')" /></UQ_MLIAB_BusSupp_Regulations>
                 <UQ_MLIAB_BusSupp_RedunDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtRedunDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_RedunDetails>
                 <UQ_MLIAB_BusSupp_Redundancies><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optRedundancies']/outcome:value='1' or outcome:controls/outcome:control[@name='optRedundancies']/outcome:value='true')" /></UQ_MLIAB_BusSupp_Redundancies>
                 <UQ_MLIAB_BusSupp_EmpDisDetails><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtEmpDisDetails']/outcome:value)" /></UQ_MLIAB_BusSupp_EmpDisDetails>
                 <UQ_MLIAB_BusSupp_EmpDispute><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optEmpDispute']/outcome:value='1' or outcome:controls/outcome:control[@name='optEmpDispute']/outcome:value='true')" /></UQ_MLIAB_BusSupp_EmpDispute>
                 <UQ_MLIAB_BusSupp_Emps><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtEmps']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtEmps']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_BusSupp_Emps>
                 <UQ_MLIAB_BusSupp_BusSuppCover><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optBusSuppCover']/outcome:value='1' or outcome:controls/outcome:control[@name='optBusSuppCover']/outcome:value='true')" /></UQ_MLIAB_BusSupp_BusSuppCover>
             </UO_MLIAB_BusSupp>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmClmSum.tst" match="frmClmSum.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmClmSum.tst' and @parentID=$pParentID]">
             <UO_MLIAB_ClmSum xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_ClmSum_Incidents><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optIncidents']/outcome:value='1' or outcome:controls/outcome:control[@name='optIncidents']/outcome:value='true')" /></UQ_MLIAB_ClmSum_Incidents>

                 <xsl:call-template name="frmClmDtail.tst">
                     <xsl:with-param name="pParentID" select="@iD" />
                 </xsl:call-template>
             </UO_MLIAB_ClmSum>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmClmDtail.tst" match="frmClmDtail.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmClmDtail.tst' and @parentID=$pParentID]">
             <UO_MLIAB_ClmDtail xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_ClmDtail_Details><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtDetails']/outcome:value)" /></UQ_MLIAB_ClmDtail_Details>
                 <UQ_MLIAB_ClmDtail_Outstanding><xsl:value-of select="outcome:controls/outcome:control[@name='cfdOutstanding']/outcome:value" /></UQ_MLIAB_ClmDtail_Outstanding>
                 <UQ_MLIAB_ClmDtail_Paid><xsl:value-of select="outcome:controls/outcome:control[@name='cfdPaid']/outcome:value" /></UQ_MLIAB_ClmDtail_Paid>
                 <UQ_MLIAB_ClmDtail_Date><xsl:value-of select="func:MyDateFormat(outcome:controls/outcome:control[@name='mskDate']/outcome:value,2)" /></UQ_MLIAB_ClmDtail_Date>
<UQ_MLIAB_ClmDtail_Type><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboType']/outcome:value)" /></UQ_MLIAB_ClmDtail_Type>
             </UO_MLIAB_ClmDtail>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmAssump.tst" match="frmAssump.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmAssump.tst' and @parentID=$pParentID]">
             <UO_MLIAB_Assump xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
<UQ_MLIAB_Assump_Demolition><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboDemolition']/outcome:value)" /></UQ_MLIAB_Assump_Demolition>
<UQ_MLIAB_Assump_Convicted><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboConvicted']/outcome:value)" /></UQ_MLIAB_Assump_Convicted>
<UQ_MLIAB_Assump_Bankrupt><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboBankrupt']/outcome:value)" /></UQ_MLIAB_Assump_Bankrupt>
<UQ_MLIAB_Assump_Refused><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboRefused']/outcome:value)" /></UQ_MLIAB_Assump_Refused>
<UQ_MLIAB_Assump_Asbestos><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboAsbestos']/outcome:value)" /></UQ_MLIAB_Assump_Asbestos>
<UQ_MLIAB_Assump_PowerStations><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPowerStations']/outcome:value)" /></UQ_MLIAB_Assump_PowerStations>
<UQ_MLIAB_Assump_Aircraft><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboAircraft']/outcome:value)" /></UQ_MLIAB_Assump_Aircraft>
<UQ_MLIAB_Assump_PPE><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPPE']/outcome:value)" /></UQ_MLIAB_Assump_PPE>
<UQ_MLIAB_Assump_StaffTraining><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboStaffTraining']/outcome:value)" /></UQ_MLIAB_Assump_StaffTraining>
             </UO_MLIAB_Assump>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmSubsid.tst" match="frmSubsid.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmSubsid.tst' and @parentID=$pParentID]">
             <UO_MLIAB_Subsid xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
<UQ_MLIAB_Subsid_SubsidInsurer><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboSubsidInsurer']/outcome:value)" /></UQ_MLIAB_Subsid_SubsidInsurer>
                 <UQ_MLIAB_Subsid_SubsidERN><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtSubsidERN']/outcome:value)" /></UQ_MLIAB_Subsid_SubsidERN>
                 <UQ_MLIAB_Subsid_SubsidName><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtSubsidName']/outcome:value)" /></UQ_MLIAB_Subsid_SubsidName>
             </UO_MLIAB_Subsid>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmCAR.tst" match="frmCAR.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmCAR.tst' and @parentID=$pParentID]">
             <UO_MLIAB_CAR xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_CAR_coverhireplant><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optcoverhireplant']/outcome:value='1' or outcome:controls/outcome:control[@name='optcoverhireplant']/outcome:value='true')" /></UQ_MLIAB_CAR_coverhireplant>
                 <UQ_MLIAB_CAR_coverplant><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optcoverplant']/outcome:value='1' or outcome:controls/outcome:control[@name='optcoverplant']/outcome:value='true')" /></UQ_MLIAB_CAR_coverplant>
                 <UQ_MLIAB_CAR_Contractsworks><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optContractsworks']/outcome:value='1' or outcome:controls/outcome:control[@name='optContractsworks']/outcome:value='true')" /></UQ_MLIAB_CAR_Contractsworks>
<UQ_MLIAB_CAR_MaxHirPlantVal><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboMaxHirPlantVal']/outcome:value)" /></UQ_MLIAB_CAR_MaxHirPlantVal>
<UQ_MLIAB_CAR_HirPlantMacVal><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboHirPlantMacVal']/outcome:value)" /></UQ_MLIAB_CAR_HirPlantMacVal>
<UQ_MLIAB_CAR_HireChargeVal><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboHireChargeVal']/outcome:value)" /></UQ_MLIAB_CAR_HireChargeVal>
<UQ_MLIAB_CAR_OwnPlantMacVal><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboOwnPlantMacVal']/outcome:value)" /></UQ_MLIAB_CAR_OwnPlantMacVal>
<UQ_MLIAB_CAR_MaxContractVal><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboMaxContractVal']/outcome:value)" /></UQ_MLIAB_CAR_MaxContractVal>
             </UO_MLIAB_CAR>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmAccIncom.tst" match="frmAccIncom.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmAccIncom.tst' and @parentID=$pParentID]">
             <UO_MLIAB_AccIncom xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
<UQ_MLIAB_AccIncom_AccidentCover><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboAccidentCover']/outcome:value)" /></UQ_MLIAB_AccIncom_AccidentCover>
                 <UQ_MLIAB_AccIncom_CoverYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optCoverYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optCoverYN']/outcome:value='true')" /></UQ_MLIAB_AccIncom_CoverYN>
<UQ_MLIAB_AccIncom_IncomeCover><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboIncomeCover']/outcome:value)" /></UQ_MLIAB_AccIncom_IncomeCover>
                 <UQ_MLIAB_AccIncom_PeopleNum><xsl:choose><xsl:when test="outcome:controls/outcome:control[@name='txtPeopleNum']/outcome:value=''">0</xsl:when><xsl:otherwise><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtPeopleNum']/outcome:value)" /></xsl:otherwise></xsl:choose></UQ_MLIAB_AccIncom_PeopleNum>

                 <xsl:call-template name="frmPAPeople.tst">
                     <xsl:with-param name="pParentID" select="@iD" />
                 </xsl:call-template>
             </UO_MLIAB_AccIncom>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmPAPeople.tst" match="frmPAPeople.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmPAPeople.tst' and @parentID=$pParentID]">
             <UO_MLIAB_PAPeople xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
                 <UQ_MLIAB_PAPeople_UKResidentYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optUKResidentYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optUKResidentYN']/outcome:value='true')" /></UQ_MLIAB_PAPeople_UKResidentYN>
                 <UQ_MLIAB_PAPeople_DateOfBirth><xsl:value-of select="func:MyDateFormat(outcome:controls/outcome:control[@name='mskDateOfBirth']/outcome:value,2)" /></UQ_MLIAB_PAPeople_DateOfBirth>
                 <UQ_MLIAB_PAPeople_Surname><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtSurname']/outcome:value)" /></UQ_MLIAB_PAPeople_Surname>
                 <UQ_MLIAB_PAPeople_Forenames><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='txtForenames']/outcome:value)" /></UQ_MLIAB_PAPeople_Forenames>
<UQ_MLIAB_PAPeople_Title><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboTitle']/outcome:value)" /></UQ_MLIAB_PAPeople_Title>
             </UO_MLIAB_PAPeople>
         </xsl:for-each>
     </xsl:template>

     <xsl:template name="frmProfIndm.tst" match="frmProfIndm.tst">
     <xsl:param name="pParentID" select="''"></xsl:param>
         <xsl:for-each select="//outcome:screen[@name='frmProfIndm.tst' and @parentID=$pParentID]">
             <UO_MLIAB_ProfIndm xmlns="http://www.wisl.co.uk/schemas" >
                 <xsl:attribute name="instance"><xsl:value-of select="position()" /></xsl:attribute>
<UQ_MLIAB_ProfIndm_PILevel><xsl:value-of select="normalize-space(outcome:controls/outcome:control[@name='cboPILevel']/outcome:value)" /></UQ_MLIAB_ProfIndm_PILevel>
                 <UQ_MLIAB_ProfIndm_PIYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optPIYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optPIYN']/outcome:value='true')" /></UQ_MLIAB_ProfIndm_PIYN>
                 <UQ_MLIAB_ProfIndm_DesignYN><xsl:value-of select="boolean(outcome:controls/outcome:control[@name='optDesignYN']/outcome:value='1' or outcome:controls/outcome:control[@name='optDesignYN']/outcome:value='true')" /></UQ_MLIAB_ProfIndm_DesignYN>
             </UO_MLIAB_ProfIndm>
         </xsl:for-each>
     </xsl:template>

</xsl:stylesheet>
