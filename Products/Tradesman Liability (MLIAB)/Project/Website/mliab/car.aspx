<%@ Page Language="VB" MasterPageFile="~/ScreenLOBSingle.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<%@ Register Src="../PostcodeSearch.ascx" TagName="PostcodeSearch" TagPrefix="uc1" %>
<%@ Register Src="../vehiclesearch.ascx" TagName="VehicleSearch" TagPrefix="uc2" %>
<%@ Register TagPrefix="tes_webcontrols" Namespace="TES_WebControls" Assembly="TES_WebControls" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">CAR</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <div class="datacapture">
     <fieldset>
         <legend>CAR</legend>
         <ol class="formlayout">
             <li id="subUSER_MLIAB_CAR__CONTRACTSWORKS__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__CONTRACTSWORKS__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__CONTRACTSWORKS__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__CONTRACTSWORKS__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__CONTRACTSWORKS__0">Cover forContract Works required? </tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_CAR__CONTRACTSWORKS__0" runat="server" renderWithoutTable="true"><relatedControl ctl="USER_MLIAB_CAR__MAXCONTRACTVAL_ID__0_ctl" type="enable" YesValue="True" page="car.aspx" /><relatedControl ctl="pUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="subUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__CONTRACTSWORKS__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__CONTRACTSWORKS__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Cover forContract Works required? " Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__MAXCONTRACTVAL_ID__0">What is the maximum value of any one contract?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" runat="server" ListViewName="mh_carmaxcontractval_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__MAXCONTRACTVAL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the maximum value of any one contract?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__COVERPLANT__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__COVERPLANT__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__COVERPLANT__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__COVERPLANT__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__COVERPLANT__0">Cover for your own Plant and Machinery  required?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_CAR__COVERPLANT__0" runat="server" renderWithoutTable="true"><relatedControl ctl="USER_MLIAB_CAR__OWNPLANTMACVAL_ID__0_ctl" type="enable" YesValue="True" page="car.aspx" /><relatedControl ctl="pUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="subUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__COVERPLANT__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__COVERPLANT__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Cover for your own Plant and Machinery  required?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__OWNPLANTMACVAL_ID__0">What is the value of your own Plant and Machinery?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" runat="server" ListViewName="mh_carownplantmacval_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__OWNPLANTMACVAL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What is the value of your own Plant and Machinery?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__COVERHIREPLANT__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__COVERHIREPLANT__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__COVERHIREPLANT__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__COVERHIREPLANT__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__COVERHIREPLANT__0">Cover for Hired in Plant and Machinery required?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLYNRadioSelect ID="USER_MLIAB_CAR__COVERHIREPLANT__0" runat="server" renderWithoutTable="true"><relatedControl ctl="USER_MLIAB_CAR__HIRECHARGEVAL_ID__0_ctl" type="enable" YesValue="True" page="car.aspx" /><relatedControl ctl="pUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="subUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="USER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0_ctl" type="enable" YesValue="True" page="car.aspx" /><relatedControl ctl="pUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="subUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="USER_MLIAB_CAR__HIRPLANTMACVAL_ID__0_ctl" type="enable" YesValue="True" page="car.aspx" /><relatedControl ctl="pUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /><relatedControl ctl="subUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" type="visible" YesValue="True" page="car.aspx" /></tes_webcontrols:TGSLYNRadioSelect>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__COVERHIREPLANT__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__COVERHIREPLANT__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Cover for Hired in Plant and Machinery required?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__HIRECHARGEVAL_ID__0">What do you spend on hire charges over 12 months?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CAR__HIRECHARGEVAL_ID__0" runat="server" ListViewName="mh_carhirechargeval_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__HIRECHARGEVAL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__HIRECHARGEVAL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="What do you spend on hire charges over 12 months?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__HIRPLANTMACVAL_ID__0">Total value of your Hired in Plant and Machinery?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" runat="server" ListViewName="mh_carhirplantmacval_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__HIRPLANTMACVAL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Total value of your Hired in Plant and Machinery?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
             <li id="subUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" runat="server" style="display:none;"></li>
             <li id="pUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0">
                 <span class="required"><tes_webcontrols:tgslimage id="imgUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" runat="server" UseBranding="True" ImageFileName="required.gif" ImageUrl="~/images/required.gif"></tes_webcontrols:tgslimage></span>
                 <tes_webcontrols:TGSLLabel ID="lblUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" runat="server" AssociatedControlID="USER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0">Maximum Value of any one Item of Hired in Plant?</tes_webcontrols:TGSLLabel>
                 <span class="control"><tes_webcontrols:TGSLGetListDropDown id="USER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" runat="server" ListViewName="mh_carmaxhirplantval_view"></tes_webcontrols:TGSLGetListDropDown>&nbsp;<tes_webcontrols:TGSLRequiredValidator ID="reqUSER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" runat="server" Branded="False" ControlToValidate="USER_MLIAB_CAR__MAXHIRPLANTVAL_ID__0" Display="Dynamic" ShowMandatory="False" EnableClientScript="False" ErrorMessage="Maximum Value of any one Item of Hired in Plant?" Override="True" OverrideErrorMessage="*Required"></tes_webcontrols:TGSLRequiredValidator></span>
             </li>
         </ol>
     </fieldset>
 </div>
</asp:Content>
