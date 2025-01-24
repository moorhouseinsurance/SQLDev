<%@ Page Language="VB" MasterPageFile="~/ScreenLOBAssumptions.master" AutoEventWireup="false" Inherits="clsCorePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="LOBPageName" Runat="Server">
 <h1 id="pageHeading" runat="server">Assumptions</h1>
 <div id="pageDescription" runat="server" visible="false"></div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="LOBDecline" Runat="Server">
 <asp:Literal ID="declineMessage" runat="server"></asp:Literal>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LOBData" Runat="Server">
 <asp:Literal ID="assumptionList" runat="server"></asp:Literal>
</asp:Content>
