<%@ Page Language="VB" MasterPageFile="~/ScreenLOBSingle.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Assumptions</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Assumptions</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_ASSUMP__DEMOLITION_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__DEMOLITION_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__DEMOLITION_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__DEMOLITION_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__DEMOLITION_ID__0">1. Demolition work</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__DEMOLITION_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__DEMOLITION_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__DEMOLITION_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="1. Demolition work" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__AIRCRAFT_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__AIRCRAFT_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__AIRCRAFT_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__AIRCRAFT_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__AIRCRAFT_ID__0">2. Aircraft</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__AIRCRAFT_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__AIRCRAFT_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__AIRCRAFT_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="2. Aircraft" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__POWERSTATIONS_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__POWERSTATIONS_ID__0">3. Power stations</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__POWERSTATIONS_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="3. Power stations" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__ASBESTOS_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__ASBESTOS_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__ASBESTOS_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__ASBESTOS_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__ASBESTOS_ID__0">4. Asbestos</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__ASBESTOS_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__ASBESTOS_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__ASBESTOS_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="4. Asbestos" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__REFUSED_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__REFUSED_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__REFUSED_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__REFUSED_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__REFUSED_ID__0">5. Insurance refused</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__REFUSED_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__REFUSED_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__REFUSED_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="5. Insurance refused" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__BANKRUPT_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__BANKRUPT_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__BANKRUPT_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__BANKRUPT_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__BANKRUPT_ID__0">6. Declared bankrupt</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__BANKRUPT_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__BANKRUPT_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__BANKRUPT_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="6. Declared bankrupt" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__CONVICTED_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__CONVICTED_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__CONVICTED_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__CONVICTED_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__CONVICTED_ID__0">7. Been convicted</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__CONVICTED_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__CONVICTED_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__CONVICTED_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="7. Been convicted" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__STAFFTRAINING_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__STAFFTRAINING_ID__0">8. Ongoing staff training</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__STAFFTRAINING_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="8. Ongoing staff training" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_ASSUMP__PPE_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_ASSUMP__PPE_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_ASSUMP__PPE_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_ASSUMP__PPE_ID__0" runat="server" AssociatedControlID="USER_MLIAB_ASSUMP__PPE_ID__0">9. Please confirm that PPE</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_ASSUMP__PPE_ID__0" runat="server" ListViewName="mh_assumpt_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_ASSUMP__PPE_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_ASSUMP__PPE_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="9. Please confirm that PPE" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
