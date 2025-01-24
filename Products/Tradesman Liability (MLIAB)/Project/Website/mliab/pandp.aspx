<%@ Page Language="VB" MasterPageFile="~/ScreenLOBMultiple.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Partners and Principals</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Partners and Principals</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_PANDP__TITLE_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PANDP__TITLE_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PANDP__TITLE_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PANDP__TITLE_ID__0" runat="server" AssociatedControlID="USER_MLIAB_PANDP__TITLE_ID__0">What is the Title of the Partner?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_PANDP__TITLE_ID__0" runat="server" ListViewName="title_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PANDP__TITLE_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PANDP__TITLE_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the Title of the Partner?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_PANDP__FORENAME__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PANDP__FORENAME__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PANDP__FORENAME__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PANDP__FORENAME__0" runat="server" AssociatedControlID="USER_MLIAB_PANDP__FORENAME__0">What is the Forename of the Partner?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_PANDP__FORENAME__0" runat="server" MaxLength="50" ></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PANDP__FORENAME__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PANDP__FORENAME__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the Forename of the Partner?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_PANDP__SURNAME__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PANDP__SURNAME__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PANDP__SURNAME__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PANDP__SURNAME__0" runat="server" AssociatedControlID="USER_MLIAB_PANDP__SURNAME__0">What is the Surname of the Partner?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_PANDP__SURNAME__0" runat="server" MaxLength="50" ></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PANDP__SURNAME__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PANDP__SURNAME__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the Surname of the Partner?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_PANDP__STATUS_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_PANDP__STATUS_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_PANDP__STATUS_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_PANDP__STATUS_ID__0" runat="server" AssociatedControlID="USER_MLIAB_PANDP__STATUS_ID__0">What is the Status of the Partner?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_PANDP__STATUS_ID__0" runat="server" ListViewName="mh_p_status_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_PANDP__STATUS_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_PANDP__STATUS_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the Status of the Partner?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
