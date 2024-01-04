<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="WebApplication1.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server" submitdisabledcontrols="False">
        <div>
        </div>
        Welcome to Login page.<br />
        Enter your ID:<br />
        <asp:TextBox ID="EmployeeID" runat="server"></asp:TextBox>
        <br />
        Enter your first name:<br />
        <asp:TextBox ID="Emp_fname" runat="server"></asp:TextBox>
        <br />
        <asp:Button ID="Loginbutton" runat="server" Text="login" OnClick="Login" />
    </form>
</body>
</html>
