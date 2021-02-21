<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    
<head runat="server">
<meta charset="utf-8" />
    <title>Dynamic Table</title>      
      <script src="lib/jquery-1.7.min.js"></script>
      <link rel="stylesheet" href="slick/slick.grid.css" type="text/css"/>
      <link rel="stylesheet" href="css/smoothness/jquery-ui-1.8.16.custom.css" type="text/css"/>
      <link rel="stylesheet" href="controls/slick.pager.css" type="text/css"/>
      <link rel="stylesheet" href="examples.css" type="text/css"/>
      <style>
        .cell-title {
          font-weight: bold;
        }

        .cell-effort-driven {
          text-align: center;
        }

        .cell-selection {
          border-right-color: silver;
          border-right-style: solid;
          background: #f5f5f5;
          color: gray;
          text-align: right;
          font-size: 10px;
        }
  </style>
    <script src="table.js" language="JavaScript"></script>
    <script runat="server">
        public void Page_Load()
        {
            using (BL bl = new BL())
            {
                lstFieldType.DataSource = bl.GetDataTypes();
                lstFieldType.DataTextField = "display_name";
                lstFieldType.DataValueField = "type_name";
                lstFieldType.DataBind();
            }
            lstFieldType.Items.Insert(0, new ListItem("", "-1"));
        }
    </script>
    
</head>
<body >
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="ScriptManager1" />
        <table align="center" style="border:2px;table-layout:fixed;width:350px">
            <colgroup>
                <col style="width:150px;" />
                <col style="width:200px;text-align:left;" />
            </colgroup>
            <tr>
                <td colspan="2" align="center"><h3>Dynamic Table</h3></td>
            </tr>
            <tr>
                <td><asp:Label runat="server" ID="lblFieldName">Field Name</asp:Label></td>
                <td><asp:TextBox runat="server" ID="txtFieldName" Width="160"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label runat="server" ID="lblFieldType">Field Type</asp:Label></td>
                <td>
                    <asp:DropDownList runat="server" ID="lstFieldType" Width="160" onchange="setLength();">                    
                    </asp:DropDownList>
                </td>
            </tr>
             <tr>
                <td><asp:Label runat="server" style="display:none" ID="lblFieldLen">Field Length</asp:Label></td>
                <td>
                    <asp:TextBox style="display:none" type="number" min="0" runat="server" ID="txtFieldLen" Width="160"></asp:TextBox>
                    <asp:TextBox style="display:none" type="number" min="0" runat="server" ID="txtLen1" Width="70"></asp:TextBox>
                    <asp:TextBox style="display:none" type="number" min="0" runat="server" ID="txtLen2" Width="70"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td><asp:Label runat="server" ID="lblDfltValue">Default Value</asp:Label></td>
                <td><asp:TextBox runat="server" ID="txtDfltValue" Width="160"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2" align="center"><asp:Button runat="server" ID="btnAdd" UseSubmitBehavior="false" OnClientClick="return addField()" Text="Add Field"/></td>
            </tr>
        </table>
        </form>
        
        <div style="position:relative;" align="center">
          <div style="width:800px;">
            <div id="myGrid" style="width:100%;height:400px;"></div>
            <div id="pager" style="width:100%;height:20px;"></div>
          </div>
        </div>
        
        <script src="lib/jquery-ui-1.8.16.custom.min.js"></script>
        <script src="lib/jquery.event.drag-2.2.js"></script>

        <script src="slick/slick.core.js"></script>
        <script src="slick/slick.formatters.js"></script>
        <script src="slick/slick.grid.js"></script>
        <script src="slick/slick.dataview.js"></script>
        <script src="controls/slick.pager.js"></script>
<script>
  var dataView;
  var grid;
  var data = [];
  var columns = [];
    // prepare the data
    
    initData();
    var options = {
        editable: false,
        enableAddRow: false,
        enableCellNavigation: true
    };

    var percentCompleteThreshold = 0;
    var prevPercentCompleteThreshold = 0;
    var h_runfilters = null;

    function myFilter(item, args) {
        return item["percentComplete"] >= args;
    }
   
   function init(firstTime) {      

        
            //alert('in func');
       if (firstTime) {
           dataView = new Slick.Data.DataView({ inlineFilters: false });

           grid = new Slick.Grid("#myGrid", dataView, columns, options);

           pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));
           dataView.onRowCountChanged.subscribe(function (e, args) {
               grid.updateRowCount();
               grid.render();
           });

           dataView.onRowsChanged.subscribe(function (e, args) {
               grid.invalidateRows(args.rows);
               grid.render();
           });
       }

            // wire up the slider to apply the filter to the model
            $("#pcSlider").slider({
                "range": "min",
                "slide": function (event, ui) {
                    if (percentCompleteThreshold != ui.value) {
                        window.clearTimeout(h_runfilters);
                        h_runfilters = window.setTimeout(filterAndUpdate, 10);
                        percentCompleteThreshold = ui.value;
                    }
                }
            });

            function filterAndUpdate() {
                var isNarrowing = percentCompleteThreshold > prevPercentCompleteThreshold;
                var isExpanding = percentCompleteThreshold < prevPercentCompleteThreshold;
                var renderedRange = grid.getRenderedRange();

                dataView.setFilterArgs(percentCompleteThreshold);
                dataView.setRefreshHints({
                    ignoreDiffsBefore: renderedRange.top,
                    ignoreDiffsAfter: renderedRange.bottom + 1,
                    isFilterNarrowing: isNarrowing,
                    isFilterExpanding: isExpanding
                });
                dataView.refresh();

                prevPercentCompleteThreshold = percentCompleteThreshold;
            }

            // initialize the model after all the events have been hooked up
            dataView.beginUpdate();

            dataView.setItems(data);
            //dataView.setFilter(myFilter);
            //dataView.setFilterArgs(0);
            dataView.endUpdate();        
    }
</script>
        
</body>
</html>
