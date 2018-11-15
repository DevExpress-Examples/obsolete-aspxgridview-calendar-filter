<!-- default file list -->
*Files to look at*:

* [MyStyles.css](./CS/Content/MyStyles.css)
* **[Default.aspx](./CS/Default.aspx) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))**
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))
<!-- default file list end -->
# OBSOLETE - ASPxGridView - How to implement a custom HeaderFilter with a calendar for a date column 


<p><strong>UPDATED:</strong><br><br>Starting with version v2015 vol 2 (v15.2), this functionality is available out of the box. Simply set the <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebGridViewDataColumnHeaderFilterSettings_Modetopic">GridViewDataColumn.SettingsHeaderFilter.Mode</a> property to <strong>DateRangePicker</strong> to activate it. Please refer to the <a href="https://community.devexpress.com/blogs/aspnet/archive/2015/11/10/asp-net-grid-view-data-range-filter-adaptivity-and-more-coming-soon-in-v15-2.aspx">ASP.NET Grid View - Data Range Filter, Adaptivity and More (Coming soon in v15.2)</a> blog post and the <a href="http://demos.devexpress.com/ASPxGridViewDemos/Filtering/DateRangeHeaderFilter.aspx">Date Range Header Filter</a> demo for more information.<br>If you have version v15.2+ available, consider using the built-in functionality instead of the approach detailed below.</p>
<p><br><strong>For Older Versions: </strong></p>
<p>This example illustrates how to create a custom HeaderFilter for a date column. The main steps are: <br>1) create a custom <strong>HeaderTemplate</strong>  to prevent default header filter button logic and implement custom one;<br>2) use ASPxPopupControl to display a Calendar and several additional filters. ASPxFormLayout is used to build a layout;<br>3) use the client <a href="https://documentation.devexpress.com/AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_AutoFilterByColumntopic.aspx">AutoFilterByColumn</a> method to perform filtering from the client side and  the <a href="https://documentation.devexpress.com/#AspNet/DevExpressWebASPxGridViewScriptsASPxClientGridView_PerformCallbacktopic">ASPxClientGridView.PerformCallback</a> method to pass a complex filter expression to the server to implement custom filtering;<br>4) process a custom callback in the <a href="https://documentation.devexpress.com/AspNet/DevExpressWebASPxGridViewASPxGridView_CustomCallbacktopic.aspx">ASPxGridView.CustomCallback</a> event handler to get information about the required filter expression on the server;<br>5) implement the approach described in the <a href="http://www.devexpress.com/Support/Center/Question/Details/KA18784">ASPxGridView - How to programmatically change the column's filter in the FilterExpression</a>  help article to apply a new filter.</p>
<p>Click on the "Model Date" column to check how this works.<br><br><strong>MVC:<br></strong><a href="https://www.devexpress.com/Support/Center/p/T152511">T152511: OBSOLETE - GridView - How to implement a custom HeaderFilter with a calendar for a date column</a> <strong><br></strong></p>

<br/>


