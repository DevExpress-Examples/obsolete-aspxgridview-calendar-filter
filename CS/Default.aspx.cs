using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using System.Web.UI.HtmlControls;
using DevExpress.Data.Filtering;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if(!IsPostBack)
            ASPxGridView1.DataBind();
    }
    public BetweenOperator CreateNextMonthFilter(string field)
    {
        if (String.IsNullOrWhiteSpace(field))
            return null;
        var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month + 1, 1);
        var endDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month + 2, 1);
        var filter = new BetweenOperator(field, startDate, endDate);
        return filter;
    }
    public BetweenOperator CreateLastMonthFilter(string field)
    {
        if (String.IsNullOrWhiteSpace(field))
            return null;
        var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month - 1, 1);
        var endDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
        var filter = new BetweenOperator(field, startDate, endDate);
        return filter;
    }
    protected void ASPxGridView1_DataBinding(object sender, EventArgs e)
    {
        ASPxGridView1.DataSource = Enumerable.Range(0,100).Select(i=>new { ID=i, Name="Product" + i, Description="Some description" + i, Date =  i % 2 == 0 ? DateTime.Now.AddDays(i) : DateTime.Now.AddDays(-i) });
    }
    protected void ASPxGridView1_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
    {
        ASPxGridView GridView = sender as ASPxGridView;
        if (String.IsNullOrEmpty(e.Parameters))
            return;
        string[] parameters = e.Parameters.Split(',');
        string field = parameters[1];
        string command = parameters[0];
        BetweenOperator filterExpression = new BetweenOperator();
        switch (command)
        {
            case "NextMonth":
                filterExpression = CreateNextMonthFilter(field);
                break;
            case "LastMonth":
                filterExpression = CreateLastMonthFilter(field);
                break;
            default:               
                break;
        }       
        var criterias = CriteriaColumnAffinityResolver.SplitByColumnNames(CriteriaOperator.Parse(GridView.FilterExpression));
        if (!criterias.Item2.Keys.Contains(field))
            criterias.Item2.Add(field, filterExpression);
        else
            criterias.Item2[field] = filterExpression;
        var expression = CriteriaOperator.ToString(GroupOperator.And(criterias.Item2.Values));
        GridView.FilterExpression = expression;
    }
    protected void SortArrow_Init(object sender, EventArgs e)
    {
        ASPxImage image = sender as ASPxImage;
        GridViewHeaderTemplateContainer headerContainer = image.NamingContainer as GridViewHeaderTemplateContainer;
        var column = headerContainer.Column as GridViewDataColumn;

        if (column.SortOrder != DevExpress.Data.ColumnSortOrder.None)
        {
            if (column.SortOrder == DevExpress.Data.ColumnSortOrder.Ascending)
            {
                image.CssClass = "dxGridView_gvHeaderSortUp_DevEx dx-vam";
            }
            else if (column.SortOrder == DevExpress.Data.ColumnSortOrder.Descending)
            {
                image.CssClass = "dxGridView_gvHeaderSortDown_DevEx dx-vam";
            }            
        }
        else
            image.Visible = false;

    }
    protected void HeaderFilter_Init(object sender, EventArgs e)
    {
        ASPxImage image = sender as ASPxImage;
        GridViewHeaderTemplateContainer headerContainer = image.NamingContainer as GridViewHeaderTemplateContainer;
        var column = headerContainer.Column as GridViewDataColumn;
        image.ClientSideEvents.Click = String.Format("function(s,e){{ OnColumnClick(s.GetMainElement(), '{0}'); }}", column.FieldName);
        image.ClientSideEvents.Init = "OnHeadeFilterImageInit";
    }
}