!INC Local Scripts.EAConstants-JScript

/*
 * Script Name: Select Language Notes
 * Author: Michael van der Zel
 * Purpose: Select Notes in configured language
 * Date: 24-feb-2022
 */
//const LANGUAGE = "en-US";
const LANGUAGE = "nl-NL";
 
	function moveNext()
	{
		if(this.iElem > -1)
		{
			this.iElem++;
			if(this.iElem < this.Package.Count)
			{
				return true;
			}
			this.iElem = this.Package.Count;
		}
		return false;
	}
	function item()
	{
		if( this.iElem > -1 && this.iElem < this.Package.Count)
		{
			return this.Package.GetAt(this.iElem);
		}
		return null;
	}

	function atEnd()
	{
		if((this.iElem > -1) && (this.iElem < this.Package.Count))
		{
			return false;
		}
		//Session.Output("at end!");
		return true;
	}

	function Check( obj)
	{
		if(obj == undefined)
		{
			//Session.Output("Undefined object");
			return false;
		}
		return true;
	}	
 
function Enumerator( object )
{
	this.iElem = 0;
	this.Package = object;
	this.atEnd = atEnd;
	this.moveNext = moveNext;
	this.item = item;
	this.Check = Check;
	if(!Check(object))
	{
		this.iElem = -1;
	}
}

function EnumerateElements( indent, elements )
{	
	// Iterate through all elements and add them to the list
	var elementEnumerator = new Enumerator( elements );
	while ( !elementEnumerator.atEnd() )
	{
		var currentElement as EA.Element;
		currentElement = elementEnumerator.item();

		Session.Output( indent + currentElement.Name );

		var notes = currentElement.Notes;
		notes = notes.replace( /&lt;/g, "<" ); // EA14 dubble escapes e.g. MDO BP
		notes = notes.replace( /&gt;/g, ">" ); // EA14 dubble escapes e.g. MDO BP
		var after = notes.indexOf( "<" + LANGUAGE + ">" );
		var before = notes.indexOf( "</" + LANGUAGE + ">" );
		if (after != -1) 
		{
			notes = notes.substring(after + 7, before);
			if ( notes == "undefined" )
			{
				notes = "";
			}
			Session.Output( after + "," + before + "," + notes );
			currentElement.Notes = notes;
			currentElement.Update();
		}
		
		EnumerateElements( indent, currentElement.Elements );
					
		elementEnumerator.moveNext();
	}
}

function DumpElements( indent, thePackage )
{
	// Cast thePackage to EA.Package so we get intellisense
	var currentPackage as EA.Package;
	currentPackage = thePackage;
	EnumerateElements ( indent, currentPackage.Elements );
}

function DumpPackage( indent, thePackage )
{
	// Cast thePackage to EA.Package so we get intellisense
	var currentPackage as EA.Package;
	currentPackage = thePackage;
	
	// Add the current package's name to the list
	Session.Output( indent + currentPackage.Name );
	
	// Dump the elements this package contains
	DumpElements( indent + "    ", currentPackage );
	
	// Recursively process any child packages
	var childPackageEnumerator = new Enumerator( currentPackage.Packages );
	while ( !childPackageEnumerator.atEnd() )
	{
		var childPackage as EA.Package;
		childPackage = childPackageEnumerator.item();
		
		DumpPackage( indent + "    ", childPackage );
		
		childPackageEnumerator.moveNext();
	}
}

function main()
{
	// Show the script output window
	//Repository.EnsureOutputVisible( "Script" );

	// Get the currently selected package in the tree to work on
	var thePackage as EA.Package;
	thePackage = Repository.GetTreeSelectedPackage();
	DumpPackage ( "    ", thePackage );
}

main();
