<%@ Page Language="VB" MasterPageFile="~/ScreenLOBMultiple.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Subsidiaries</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Subsidiaries</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_SUBSID__SUBSIDNAME__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_SUBSID__SUBSIDNAME__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_SUBSID__SUBSIDNAME__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_SUBSID__SUBSIDNAME__0" runat="server" AssociatedControlID="USER_MLIAB_SUBSID__SUBSIDNAME__0">What is the name of the Subsidiary company?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_SUBSID__SUBSIDNAME__0" runat="server" MaxLength="200" ></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_SUBSID__SUBSIDNAME__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_SUBSID__SUBSIDNAME__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the name of the Subsidiary company?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_SUBSID__SUBSIDERN__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_SUBSID__SUBSIDERN__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_SUBSID__SUBSIDERN__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_SUBSID__SUBSIDERN__0" runat="server" AssociatedControlID="USER_MLIAB_SUBSID__SUBSIDERN__0">What is the Employers Ref</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_SUBSID__SUBSIDERN__0" runat="server" MaxLength="20" ></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_SUBSID__SUBSIDERN__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_SUBSID__SUBSIDERN__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the Employers Ref" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_SUBSID__SUBSIDINSURER_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" runat="server" AssociatedControlID="USER_MLIAB_SUBSID__SUBSIDINSURER_ID__0">Who is the current insurer for subs</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" runat="server" ListViewName="insurer_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_SUBSID__SUBSIDINSURER_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Who is the current insurer for subs" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
