Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports DevExpress.Web.ASPxGridView
Imports System.Web.UI.HtmlControls
Imports DevExpress.Data.Filtering
Imports DevExpress.Web.ASPxEditors

Partial Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Init(ByVal sender As Object, ByVal e As EventArgs)
        If Not IsPostBack Then
            ASPxGridView1.DataBind()
        End If
    End Sub
    Public Function CreateNextMonthFilter(ByVal field As String) As BetweenOperator
        If String.IsNullOrWhiteSpace(field) Then
            Return Nothing
        End If
        Dim startDate = New Date(Date.Now.Year, Date.Now.Month + 1, 1)
        Dim endDate = New Date(Date.Now.Year, Date.Now.Month + 2, 1)
        Dim filter = New BetweenOperator(field, startDate, endDate)
        Return filter
    End Function
    Public Function CreateLastMonthFilter(ByVal field As String) As BetweenOperator
        If String.IsNullOrWhiteSpace(field) Then
            Return Nothing
        End If
        Dim startDate = New Date(Date.Now.Year, Date.Now.Month - 1, 1)
        Dim endDate = New Date(Date.Now.Year, Date.Now.Month, 1)
        Dim filter = New BetweenOperator(field, startDate, endDate)
        Return filter
    End Function
    Protected Sub ASPxGridView1_DataBinding(ByVal sender As Object, ByVal e As EventArgs)
        ASPxGridView1.DataSource = Enumerable.Range(0,100).Select(Function(i) New With {Key .ID=i, Key .Name="Product" & i, Key .Description="Some description" & i, Key .Date = If(i Mod 2 = 0, Date.Now.AddDays(i), Date.Now.AddDays(-i))})
    End Sub
    Protected Sub ASPxGridView1_CustomCallback(ByVal sender As Object, ByVal e As ASPxGridViewCustomCallbackEventArgs)
        Dim GridView As ASPxGridView = TryCast(sender, ASPxGridView)
        If String.IsNullOrEmpty(e.Parameters) Then
            Return
        End If
        Dim parameters() As String = e.Parameters.Split(","c)
        Dim field As String = parameters(1)
        Dim command As String = parameters(0)
        Dim filterExpression As New BetweenOperator()
        Select Case command
            Case "NextMonth"
                filterExpression = CreateNextMonthFilter(field)
            Case "LastMonth"
                filterExpression = CreateLastMonthFilter(field)
            Case Else
        End Select
        Dim criterias = CriteriaColumnAffinityResolver.SplitByColumns(CriteriaOperator.Parse(GridView.FilterExpression))
        Dim op As New OperandProperty(field)
        If Not criterias.Keys.Contains(New OperandProperty(field)) Then
            criterias.Add(op, filterExpression)
        Else
            criterias(op) = filterExpression
        End If
        Dim expression = CriteriaOperator.ToString(GroupOperator.And(criterias.Values))
        GridView.FilterExpression = expression
    End Sub
    Protected Sub SortArrow_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim image As ASPxImage = TryCast(sender, ASPxImage)
        Dim headerContainer As GridViewHeaderTemplateContainer = TryCast(image.NamingContainer, GridViewHeaderTemplateContainer)
        Dim column = TryCast(headerContainer.Column, GridViewDataColumn)

        If column.SortOrder <> DevExpress.Data.ColumnSortOrder.None Then
            If column.SortOrder = DevExpress.Data.ColumnSortOrder.Ascending Then
                image.CssClass = "dxGridView_gvHeaderSortUp_DevEx dx-vam"
            ElseIf column.SortOrder = DevExpress.Data.ColumnSortOrder.Descending Then
                image.CssClass = "dxGridView_gvHeaderSortDown_DevEx dx-vam"
            End If
        Else
            image.Visible = False
        End If

    End Sub
    Protected Sub HeaderFilter_Init(ByVal sender As Object, ByVal e As EventArgs)
        Dim image As ASPxImage = TryCast(sender, ASPxImage)
        Dim headerContainer As GridViewHeaderTemplateContainer = TryCast(image.NamingContainer, GridViewHeaderTemplateContainer)
        Dim column = TryCast(headerContainer.Column, GridViewDataColumn)
        image.ClientSideEvents.Click = String.Format("function(s,e){{ OnColumnClick(s.GetMainElement(), '{0}'); }}", column.FieldName)
        image.ClientSideEvents.Init = "OnHeadeFilterImageInit"
    End Sub
End Class