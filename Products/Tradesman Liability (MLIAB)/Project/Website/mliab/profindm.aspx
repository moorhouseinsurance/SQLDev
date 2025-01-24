<%@ Page Language="VB" MasterPageFile="~/ScreenLOBSingle.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Professional Indemnity</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Professional Indemnity</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PROFINDM__DESIGNYN__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" AssociatedControlID="USER_MLIAB_PROFINDM__DESIGNYN__0">DesignYN</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" renderWithoutTable="true"><relatedControl ctl="USER_MLIAB_PROFINDM__PIYN__0" type="enable" YesValue="True" page="profindm.aspx" /><relatedControl ctl="pUSER_MLIAB_PROFINDM__PIYN__0" type="visible" YesValue="True" page="profindm.aspx" /><relatedControl ctl="subUSER_MLIAB_PROFINDM__PIYN__0" type="visible" YesValue="True" page="profindm.aspx" /></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<span class="GlossaryTerm" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__DESIGNYN__0');"><tes_webcontrols:tgslimage id="imgHLP_USER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" CssClass="helpimg" UseBranding="True" ImageFileName="help.gif" ImageUrl="~/images/help.gif" alt="Click here for help" /></span><div class="HelpDiv" id="hlpUSER_MLIAB_PROFINDM__DESIGNYN__0" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__DESIGNYN__0');"><span class="helptitle" id="HelpTitle1" runat="server">DesignYN</span><span class="helpclose">Close</span><span class="helptext">Do you offer advice, design or certification activities?</span></div>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PROFINDM__DESIGNYN__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PROFINDM__DESIGNYN__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="DesignYN" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_PROFINDM__PIYN__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PROFINDM__PIYN__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PROFINDM__PIYN__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PROFINDM__PIYN__0" runat="server" AssociatedControlID="USER_MLIAB_PROFINDM__PIYN__0">PIYN</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_PROFINDM__PIYN__0" runat="server" renderWithoutTable="true"><relatedControl ctl="USER_MLIAB_PROFINDM__PILEVEL_ID__0_ctl" type="enable" YesValue="True" page="profindm.aspx" /><relatedControl ctl="pUSER_MLIAB_PROFINDM__PILEVEL_ID__0" type="visible" YesValue="True" page="profindm.aspx" /><relatedControl ctl="subUSER_MLIAB_PROFINDM__PILEVEL_ID__0" type="visible" YesValue="True" page="profindm.aspx" /></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<span class="GlossaryTerm" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__PIYN__0');"><tes_webcontrols:tgslimage id="imgHLP_USER_MLIAB_PROFINDM__PIYN__0" runat="server" CssClass="helpimg" UseBranding="True" ImageFileName="help.gif" ImageUrl="~/images/help.gif" alt="Click here for help" /></span><div class="HelpDiv" id="hlpUSER_MLIAB_PROFINDM__PIYN__0" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__PIYN__0');"><span class="helptitle" id="HelpTitle2" runat="server">PIYN</span><span class="helpclose">Close</span><span class="helptext">Include Professional Indemnity Cover</span></div>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PROFINDM__PIYN__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PROFINDM__PIYN__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="PIYN" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PROFINDM__PILEVEL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_PROFINDM__PILEVEL_ID__0">PILevel</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" ListViewName="mh_professionalindemnitylevel_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<span class="GlossaryTerm" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__PILEVEL_ID__0');"><tes_webcontrols:tgslimage id="imgHLP_USER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" CssClass="helpimg" UseBranding="True" ImageFileName="help.gif" ImageUrl="~/images/help.gif" alt="Click here for help" /></span><div class="HelpDiv" id="hlpUSER_MLIAB_PROFINDM__PILEVEL_ID__0" onclick="ToggleDivDisplay(event, 'hlpUSER_MLIAB_PROFINDM__PILEVEL_ID__0');"><span class="helptitle" id="HelpTitle3" runat="server">PILevel</span><span class="helpclose">Close</span><span class="helptext">Professional Indemnity Cover Level</span></div>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PROFINDM__PILEVEL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PROFINDM__PILEVEL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="PILevel" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
