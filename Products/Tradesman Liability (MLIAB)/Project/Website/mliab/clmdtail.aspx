<%@ Page Language="VB" MasterPageFile="~/ScreenLOBMultiple.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Claim Detail</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>Claim Detail</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_CLMDTAIL__TYPE_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMDTAIL__TYPE_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMDTAIL__TYPE_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMDTAIL__TYPE_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CLMDTAIL__TYPE_ID__0">What is the type of claim?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CLMDTAIL__TYPE_ID__0" runat="server" ListViewName="mh_claimtype_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMDTAIL__TYPE_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMDTAIL__TYPE_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the type of claim?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CLMDTAIL__DATE__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMDTAIL__DATE__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMDTAIL__DATE__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMDTAIL__DATE__0" runat="server" AssociatedControlID="USER_MLIAB_CLMDTAIL__DATE__0">What is the claim accident / loss date?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLDateSelect id="USER_MLIAB_CLMDTAIL__DATE__0" runat="server" EndYear="-5" ></tes_webcontrols:TGSLDateSelect>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMDTAIL__DATE__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMDTAIL__DATE__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the claim accident / loss date?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CLMDTAIL__PAID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMDTAIL__PAID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMDTAIL__PAID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMDTAIL__PAID__0" runat="server" AssociatedControlID="USER_MLIAB_CLMDTAIL__PAID__0">What is the accident / loss amount paid?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_CLMDTAIL__PAID__0" runat="server" isDecimalValue="True" Numeric="True" Currency="True" decimalPlaces="0"></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMDTAIL__PAID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMDTAIL__PAID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the accident / loss amount paid?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CLMDTAIL__OUTSTANDING__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMDTAIL__OUTSTANDING__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMDTAIL__OUTSTANDING__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMDTAIL__OUTSTANDING__0" runat="server" AssociatedControlID="USER_MLIAB_CLMDTAIL__OUTSTANDING__0">What is the accident / loss amount outstanding?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_CLMDTAIL__OUTSTANDING__0" runat="server" isDecimalValue="True" Numeric="True" Currency="True" decimalPlaces="0"></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMDTAIL__OUTSTANDING__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMDTAIL__OUTSTANDING__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the accident / loss amount outstanding?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CLMDTAIL__DETAILS__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CLMDTAIL__DETAILS__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CLMDTAIL__DETAILS__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CLMDTAIL__DETAILS__0" runat="server" AssociatedControlID="USER_MLIAB_CLMDTAIL__DETAILS__0">Please provide details:</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLTextBox id="USER_MLIAB_CLMDTAIL__DETAILS__0" runat="server" TextMode="MultiLine" Rows="4"  MaxLength="500" ></tes_webcontrols:TGSLTextBox>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CLMDTAIL__DETAILS__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CLMDTAIL__DETAILS__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Please provide details:" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
