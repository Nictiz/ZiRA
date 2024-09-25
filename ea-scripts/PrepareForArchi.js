!INC Local Scripts.EAConstants-JScript

/*
 * Script Name: Swap Name and Alias
 * Author: Michael van der Zel
 * Purpose: Put nl and en into TaggedValues so they flow through to the ArchiMate export
 * Date: 26-sep-2024
 */
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

		Session.Output( indent + currentElement.Name + " <-> " + currentElement.Alias );

		var name = currentElement.Name;
		var alias = currentElement.Alias;
		var tvName_nl = currentElement.TaggedValues.GetByName("Name_nl");
		if (tvName_nl == null)
		{
			tvName_nl = currentElement.TaggedValues.AddNew("Name_nl", "");
		}
		tvName_nl.Value = name;
		tvName_nl.Update();
		var tvName_en = currentElement.TaggedValues.GetByName("Name_en");
		if (tvName_en == null)
		{
			tvName_en = currentElement.TaggedValues.AddNew("Name_en", "");
		}
		tvName_en.Value = alias;
		tvName_en.Update();

		var notes = currentElement.Notes;
		notes = notes.replace( /&lt;/g, "<" ); // EA14 dubble escapes e.g. MDO BP
		notes = notes.replace( /&gt;/g, ">" ); // EA14 dubble escapes e.g. MDO BP
		var after = notes.indexOf( "<nl-NL>" );
		var before = notes.indexOf( "</nl-NL>" );
		if (after != -1) 
		{
			notes = notes.substring(after + 7, before);
			if ( notes == "undefined" )
			{
				notes = "";
			}
			var tvDoc_nl = currentElement.TaggedValues.GetByName("Doc_nl");
			if (tvDoc_nl == null) tvDoc_nl = currentElement.TaggedValues.AddNew("Doc_nl", "");
			if (notes.length > 255)
			{
				var tvDoc_nl1 = currentElement.TaggedValues.GetByName("Doc_nl1");
				if (tvDoc_nl1 == null) tvDoc_nl1 = currentElement.TaggedValues.AddNew("Doc_nl1", "");
				tvDoc_nl1.Value = notes.substring(255);
				tvDoc_nl1.Update();
				notes = notes.substring(0,255);
				tvDoc_nl.Notes = "";
			}
			tvDoc_nl.Value = notes;
			tvDoc_nl.Update();
			Session.Output( "Doc_nl: " + after + "," + before + "," + notes );
		}
		
		var notes = currentElement.Notes;
		notes = notes.replace( /&lt;/g, "<" ); // EA14 dubble escapes e.g. MDO BP
		notes = notes.replace( /&gt;/g, ">" ); // EA14 dubble escapes e.g. MDO BP
		var after = notes.indexOf( "<en-US>" );
		var before = notes.indexOf( "</en-US>" );
		if (after != -1) 
		{
			notes = notes.substring(after + 7, before);
			if ( notes == "undefined" )
			{
				notes = "";
			}
			var tvDoc_en = currentElement.TaggedValues.GetByName("Doc_en");
			if (tvDoc_en == null)
			{
				tvDoc_en = currentElement.TaggedValues.AddNew("Doc_en", "");
			}
			if (notes.length > 255)
			{
				var tvDoc_en1 = currentElement.TaggedValues.GetByName("Doc_en1");
				if (tvDoc_en1 == null) tvDoc_en1 = currentElement.TaggedValues.AddNew("Doc_en1", "");
				tvDoc_en1.Value = notes.substring(255);
				tvDoc_en1.Update();
				notes = notes.substring(0,255);
				tvDoc_en.Notes = "";
			}
			tvDoc_en.Value = notes;
			tvDoc_en.Update();
			Session.Output( "Doc_en: " + after + "," + before + "," + notes );
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
	EnumerateElements( indent, currentPackage.Elements );
}

function DumpPackage( indent, thePackage )
{
	// Cast thePackage to EA.Package so we get intellisense
	var currentPackage as EA.Package;
	currentPackage = thePackage;
	
	// Add the current package's name to the list
	Session.Output( indent + currentPackage.Name + " <-> " + currentPackage.Alias );
	
//	var name = currentPackage.Name;
//	var alias = currentPackage.Alias;
//	currentPackage.Name = alias; -> Name_nl
//	currentPackage.Alias = name; -> Name_en
//	currentPackage.Update();

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
