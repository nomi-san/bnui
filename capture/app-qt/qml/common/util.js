.pragma library
/*
 *******************************************************************************************************
 ========================================== Valid Properties ===========================================
 *******************************************************************************************************
 * source
 * state
 * top
 * implicitHeight
 * smooth
 * width
 * visible
 * transitions
 * data
 * clip
 * resources
 * anchors
 * right
 * parent
 * verticalCenter
 * status
 * pos
 * focus
 * states
 * baselineOffset
 * horizontalCenter
 * bottom
 * baseline
 * sourceComponent
 * transformOriginPoint
 * progress
 * scale
 * left
 * activeFocus
 * childrenRect
 * effect
 * children
 * opacity
 * rotation
 * transform
 * transformOrigin
 * objectName
 * item
 * x
 * enabled
 * y
 * z
 * height
 * implicitWidth
 */


function getFilteredProperties(anObject, indent, filterFunction)
{
	var output = "";
	var props = [];

	if (filterFunction instanceof Array)
	{
		props = filterFunction;
		filterFunction = undefined;
	}
	else
	{
		for (var aProperty in anObject)
			props.push(aProperty)
	}

	for (var i = 0; i < props.length; i++)
	{
		var aProperty = props[i];
		var show = filterFunction === undefined ||
			filterFunction(aProperty);

		if (typeof(anObject[aProperty]) !== 'function' && show)
		{
			output += indent + "  " + aProperty + ': ';
			output += anObject[aProperty] + '\n';
		}
	}

	return output;
}

function outputProperties(anObject, filterFunction)
{
	var output = "";
	var indent = "  ";

	if (typeof(anObject) !== 'object')
	{
		return output;
	}

	output += "<pre>";
	output += indent + '{\n';
	output += getFilteredProperties(anObject, indent, filterFunction);
	output += indent + "}\n"
	output += "</pre>";

	return output;
}

// @param   item:           The qml object, usually the root window.
// @param   level           Increments based on where an object lies in the hierarchy.
// @param   needProperties: Boolean value, pass 1 to print properties from each object iterated upon, 0 for only object hiearchy.
// @param   list:           Pass in a list of properties to show only those specified. If none is passed, all properties will be shown.
// @param   filterFunction: Function delegate that should contain the logic for filtering which properties you would like to display,
//                          and how. The function should return true or false and accept a property as a parameter.
//                          If left undefined, a default filter is loaded that will filter by name.
//                          Minimum filterFunction definition:
//                                function propertyFilter(aProperty){ return true; }

function printObjectPropertyList(item, needProperties, filterFunction, level)
{
	var indentation = "";
	var output = " ";

	if (level === undefined)
	{
		level = 1;
	}

	for (var i = 1; i < level; i++)
	{
		indentation += "   ";
	}

	output = indentation + item;
	console.log(output);

	if (needProperties == 1)
	{
		console.log(outputProperties(item, filterFunction));
	}

	for (var i = 0; i < item.children.length; i++)
	{
		printObjectPropertyList(item.children[i], needProperties, filterFunction, level + 1);
	}
}

function printObjectPropertyListFilteredByName(item, needProperties, propertyList, level)
{
	var filter = function(aProperty)
	{
		if (propertyList === undefined || propertyList.length === 0)
		{
			return true;
		}

		for (var i = 0; i < propertyList.length; ++i)
		{
			if (propertyList[i] === aProperty)
			{
				return true;
			}
		}
		return false;
	}

	printObjectPropertyList(item, needProperties, filter, level);
}
