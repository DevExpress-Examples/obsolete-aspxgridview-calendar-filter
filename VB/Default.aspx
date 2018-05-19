<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v18.1, Version=18.1.2.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>GridView - How to implement a custom HeaderFilter with a calendar for a date
        column</title>
    <link href="~/Content/MyStyles.css" rel="stylesheet" />
    <script>
        var currentField = "";
        function OnColumnClick(el, field) {
            currentField = field;
            PopupControl.ShowAtElement(el);
        }
        function CancelEvent(evt) {
            return ASPxClientUtils.PreventEventAndBubble(evt);
        }
        function OnDateChanged(s, e) {
            if (!FilterByDateCheckBox.GetChecked())
                return;
            var date = s.GetSelectedDate();
            var dateString = CreateGridViewFilterDate(date);
            GridView.AutoFilterByColumn(currentField, dateString);
            PopupControl.Hide();
        }
        function CreateGridViewFilterDate(date) {
            return "#" + date.getFullYear() + "/" + (date.getMonth() + 1).toString() + "/" + date.getDate() + "#";
        }
        function OnFilterOptionChanged(s, e) {
            var text = s.name;
            UnCheckOtherCheckBoxes(text);
            switch (s.GetText()) {
                case "Show All":
                    GridView.AutoFilterByColumn(currentField, "");
                    break;
                case "Last Month":
                    GridView.PerformCallback("LastMonth," + currentField);
                    break;
                case "Next Month":
                    GridView.PerformCallback("NextMonth," + currentField);
                    break;
                default:
                    return;
            }
            PopupControl.Hide();
        }
        function UnCheckOtherCheckBoxes(currentCheckBox) {
            for (var i = 0; i < filterItems.length; i++) {
                if (filterItems[i] == currentCheckBox)
                    continue;
                var checkBox = ASPxClientControl.GetControlCollection().GetByName(filterItems[i]);
                checkBox.SetChecked(false);
            }
        }
        function OnHeadeFilterImageInit(s, e) {
            ASPxClientUtils.AttachEventToElement(s.GetMainElement(), "mousedown", CancelEvent);
        }
        var filterItems = new Array();
        function OnInit(s, e) {
            filterItems.push(s.name);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            Click on the "Model Date" column to check how this works
        <dx:ASPxGridView OnCustomCallback="ASPxGridView1_CustomCallback" OnDataBinding="ASPxGridView1_DataBinding" ClientInstanceName="GridView" ID="ASPxGridView1" KeyFieldName="ID"
            runat="server">
            <Settings ShowFilterBar="Visible" />
            <Columns>
                <dx:GridViewDataColumn FieldName="ID">
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Name">
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Description">
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Date">
                    <Settings AllowHeaderFilter="false" />
                    <HeaderTemplate>
                        <table cellspacing="0" cellpadding="0" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr>
                                    <td><%#CType(Container.Column, GridViewDataColumn).FieldName%></td>
                                    <td style="width: 1px; text-align: right;"><span class="dx-vam"></span>
                                        <dx:ASPxImage ID="SortArrow" CssClass="SortArrow"  ImageUrl="Content/img_trans.gif" OnInit="SortArrow_Init" runat="server"></dx:ASPxImage>
                                        <dx:ASPxImage ID="HeaderFilter" AlternateText="[Filter]" runat="server" ImageUrl="Content/img_trans.gif" CssClass="MyHeaderFilter" OnInit="HeaderFilter_Init"></dx:ASPxImage>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </HeaderTemplate>
                </dx:GridViewDataColumn>
            </Columns>
            <Settings ShowGroupPanel="true" ShowHeaderFilterButton="true" />
        </dx:ASPxGridView>
            <dx:ASPxPopupControl ID="PopupControl" ClientInstanceName="PopupControl" ShowHeader="false"
                AllowDragging="false" AllowResize="false" runat="server">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <dx:ASPxFormLayout ID="ASPxFormLayout1" ColCount="2" runat="server">
                            <SettingsItems ShowCaption="False" />
                            <Items>
                                <dx:LayoutItem Name="ShowAll" ColSpan="2" RowSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxCheckBox ID="ShowAllCheckBox" Text="Show All" ClientInstanceName="ShowAllCheckBox"
                                                runat="server" CheckState="Checked">
                                                <ClientSideEvents Init="OnInit" CheckedChanged="OnFilterOptionChanged" />
                                            </dx:ASPxCheckBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Name="FilterByDate" ColSpan="2" RowSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxCheckBox ID="FilterByDateCheckBox" Text="Filter by specific date" ClientInstanceName="FilterByDateCheckBox"
                                                runat="server" CheckState="Unchecked">
                                                <ClientSideEvents Init="OnInit" CheckedChanged="OnFilterOptionChanged" />
                                            </dx:ASPxCheckBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:EmptyLayoutItem ColSpan="1">
                                </dx:EmptyLayoutItem>
                                <dx:LayoutItem Name="CalendarItem">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxCalendar ID="Calendar" ShowClearButton="false" ShowTodayButton="false" ClientInstanceName="Calendar"
                                                runat="server">
                                                <ClientSideEvents SelectionChanged="OnDateChanged" />
                                            </dx:ASPxCalendar>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Name="LastMonth" ColSpan="2" RowSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                            <dx:ASPxCheckBox ID="LastMonthCheckBox" ClientInstanceName="LastMonthCheckBox" runat="server"
                                                Text="Last Month" CheckState="Unchecked">
                                                <ClientSideEvents Init="OnInit" CheckedChanged="OnFilterOptionChanged" />
                                            </dx:ASPxCheckBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                <dx:LayoutItem Name="NextMonth" ColSpan="2" RowSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                            <dx:ASPxCheckBox ID="NextMonthCheckBox" ClientInstanceName="NextMonthCheckBox" runat="server"
                                                Text="Next Month" CheckState="Unchecked">
                                                <ClientSideEvents Init="OnInit" CheckedChanged="OnFilterOptionChanged" />
                                            </dx:ASPxCheckBox>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                        </dx:ASPxFormLayout>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </div>
    </form>
</body>
</html>