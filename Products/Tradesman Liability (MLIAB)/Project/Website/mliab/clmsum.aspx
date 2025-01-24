<%@ Page Language="VB" MasterPageFile="~/ScreenLOBSingle.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Claim Summary</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Claim Summary</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_CLMSUM__INCIDENTS__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMSUM__INCIDENTS__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMSUM__INCIDENTS__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMSUM__INCIDENTS__0" runat="server" AssociatedControlID="USER_MLIAB_CLMSUM__INCIDENTS__0">Have you had any losses or incidents</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_CLMSUM__INCIDENTS__0" runat="server" renderWithoutTable="true"></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMSUM__INCIDENTS__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMSUM__INCIDENTS__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Have you had any losses or incidents" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
