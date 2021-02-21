
function setLength() {
    try {
        var dtype = event.srcElement;
        
        var typeName = new String(dtype.options[dtype.selectedIndex].text);

        $get("lblFieldLen").style.display = 'none';
        $get("txtFieldLen").style.display = 'none';
        $get("txtLen1").style.display = 'none';
        $get("txtLen2").style.display = 'none';
        if (typeName.endsWith('()')) {
            $get("lblFieldLen").style.display = 'inline';
            $get("txtFieldLen").style.display = 'inline';
        } else if (typeName.endsWith('(,)')) {
            $get("lblFieldLen").style.display = 'inline';
            $get("txtLen1").style.display = 'inline';
            $get("txtLen2").style.display = 'inline';
        }
    } catch (e) {
        alert(e.message);
    }
}
function errShow(lbl, err) {
    lbl.style.color = 'red';
    alert(err);
}
function fieldLegal(lbl) {
    lbl.style.color = 'green';
}
function validateField() {
    if ($get('txtFieldName').value == "") {
        errShow($get('lblFieldName'), 'Field Name is required');
        return false;
    } else {
        fieldLegal($get('lblFieldName'));
    }
    if ($get('lstFieldType').selectedIndex == 0) {
        errShow($get('lblFieldType'), 'Field Type is required');
        return false;
    } else {
        fieldLegal($get('lblFieldType'));
    }
    if ($get('txtFieldLen').style.display == 'inline' && $get('txtFieldLen').value=="") {
        errShow($get('lblFieldLen'), 'Field Length is required');
        return false;
    } else {
        fieldLegal($get('lblFieldLen'));
    }
    if ($get('txtLen1').style.display == 'inline' && ($get('txtLen1').value == "" || $get('txtLen2').value == "")) {
        errShow($get('lblFieldLen'), 'Field Length is required');
        return false;
    } else {
        fieldLegal($get('lblFieldLen'));
    }
    if ($get('txtDfltValue').value == "") {
        errShow($get('lblDfltValue'), 'Default value is required');
        return false;
    } else {
        fieldLegal($get('lblDfltValue'));
    }
    return true;
}
function addField() {
    if (!validateField())
        return false;
    var srvUrl = '/WebTable.asmx/AddCol?';
    srvUrl += 'name=' + $get('txtFieldName').value;
    srvUrl += '&dataType=' + $get('lstFieldType').value;
    if ($get('txtFieldLen').style.display == 'inline') {
        srvUrl += '&length=' + $get('txtFieldLen').value;
    } else if ($get('txtLen1').style.display == 'inline') {
        srvUrl += '&length=' + $get('txtLen1').value + ',' + $get('txtLen2').value;
    } else {
        srvUrl += '&length=0';
    }
    srvUrl += '&dflt=' + $get('txtDfltValue').value;
    $.ajax({
        url: srvUrl
    }).then(function (dataHTML) {
        alert(dataHTML.documentElement.innerHTML);
        columns = [];
        data = [];
        page = 0;
        maxPage = 0;
        initData();
    });
    return false;
}
function DataItem(row) {
    for (let i = 0; i < columns.length; i++) {
        let value = row.querySelector(columns[i].name).innerHTML;
        eval('this.' + columns[i].name + '="' + value + '"');
    }
}

function initData(pageFrom, pageTo, schema) {
    if (arguments.length == 0) {
        pageFrom = 0;
        pageTo = 0;
        schema = true;
    }
    $.post("/WebTable.asmx/GetPages", { pageFrom: pageFrom, pageTo: pageTo, schema: schema},
        function (dataHTML) {
            if (schema) {
                let nodes = dataHTML.querySelectorAll('element');
                for (let i = 0; i < nodes.length; i++) {
                    if (nodes[i].childNodes.length == 0) {
                        let col_name = nodes[i].getAttribute('name');
                        let data_type = nodes[i].getAttribute('type');
                        columns.push({ id: col_name, name: col_name, field: col_name, width: 80 });
                    }
                }
            }
            
            let rows = dataHTML.querySelectorAll('Row');
            for (let i = 0; i < rows.length; i++) {
                data.push(new DataItem(rows[i]));
            }
           
        });
    if (schema)
        setTimeout("init(true)", 1000);
    else
        setTimeout("init(false)", 1000);
}
